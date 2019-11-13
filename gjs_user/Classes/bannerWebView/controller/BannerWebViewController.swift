//
//  BannerWebViewController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/5.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import WebKit

@available(iOS 11.0, *)
class BannerWebViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate, UIWebViewDelegate {
    
    // 淘宝授权相关webView
    let taobaoWebView = UIWebView()

    var webAddress = "https://www.ganjinsheng.com/user"
    var toUrl = "/one/page/zeroBuy?keyword=123"
    var headerTitle = "0元购"
    lazy var bannerWebView: WKWebView = {
        ///偏好设置
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.selectionGranularity = WKSelectionGranularity.character
        configuration.userContentController = WKUserContentController()
        // 给webview与swift交互起名字，webview给swift发消息的时候会用到
        configuration.userContentController.add(WeakScriptMessageDelegate(self), name: "toDetail")
        configuration.userContentController.add(WeakScriptMessageDelegate(self), name: "toInvitePage")
        configuration.userContentController.add(WeakScriptMessageDelegate(self), name: "tbAuthorize")
        configuration.userContentController.add(WeakScriptMessageDelegate(self), name: "showTaoBaoDetail")
        configuration.userContentController.add(WeakScriptMessageDelegate(self), name: "jumpToMain")
        configuration.userContentController.add(WeakScriptMessageDelegate(self), name: "shareAll")
        configuration.userContentController.add(WeakScriptMessageDelegate(self), name: "copyStr")
        var bannerWebView = WKWebView(frame: CGRect(x: 0,
                                              y: headerHeight,
                                              width: kScreenW,
                                              height: kScreenH - headerHeight),
                                configuration: configuration)
        // 让webview翻动有回弹效果
        bannerWebView.scrollView.bounces = false
        // 只允许webview上下滚动
        bannerWebView.scrollView.alwaysBounceVertical = true
        bannerWebView.navigationDelegate = self
        return bannerWebView
    }()
    let noWeb = UIView(frame: CGRect(x: 0, y: (kScreenH-100)/2 - 88, width: kScreenW, height: 140))
    let loading = UIProgressView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 4))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
//        setNav(titleStr: headerTitle, titleColor: kMainTextColor, navItem: navigationItem, navController: navigationController)
        let leftBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(webBack))
        leftBtn.image = UIImage(named: "arrow-back")
        leftBtn.tintColor = kMainTextColor
        self.navigationItem.leftBarButtonItem = leftBtn
    }
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
        setNav()
        // 淘宝授权webView配置
        taobaoWebView.delegate = self
        
        self.view.addSubview(noWeb)
        self.view.addSubview(bannerWebView)
        loadData()
        bannerWebView.navigationDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AlamofireUtil.cancelAll()
    }
    
    // 设置导航栏
    func setNav () {
        let coustomNavView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height:headerHeight))
        coustomNavView.backgroundColor = .white
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight))
        let navItem = UINavigationItem()
        let backBtn = UIBarButtonItem(image: UIImage(named: "arrow-back"), style: .plain, target: nil, action: #selector(backAction(sender:)))
        navItem.setLeftBarButton(backBtn, animated: true)
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        navBar.tintColor = kMainTextColor
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.isTranslucent = true
        title.text = headerTitle
        title.textAlignment = .center
        title.textColor = kMainTextColor
        navItem.titleView = title
        navBar.pushItem(navItem, animated: true)
        coustomNavView.addSubview(navBar)
        self.view.addSubview(coustomNavView)
    }
    
    @objc func backAction(sender:UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 顶部返回按钮
    @objc func webBack(){
        if(bannerWebView.canGoBack){
            bannerWebView.goBack()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // 没有网络
    func setNoWeb(){
        let noWebImg = UIImageView(image: UIImage(named: "no-web"))
        noWebImg.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 100)
        noWebImg.contentMode = .scaleAspectFit
        let reloadBtn = UIButton(frame: CGRect(x: (kScreenW-100)/2, y: 110, width: 100, height: 30))
        reloadBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        reloadBtn.setTitle("重新加载", for: .normal)
        reloadBtn.setTitleColor(.white, for: .normal)
        reloadBtn.titleLabel?.font = FontSize(16)
        reloadBtn.layer.masksToBounds = true
        reloadBtn.layer.cornerRadius = 4
        reloadBtn.addTarget(self, action: #selector(reloadWeb), for: .touchUpInside)
        noWeb.addSubview(noWebImg)
        noWeb.addSubview(reloadBtn)
        bannerWebView.addSubview(noWeb)
    }
    
    // 重新加载网页
    @objc func reloadWeb(){
        noWeb.removeFromSuperview()
        loadData()
    }
    
    ///在网页加载完成时调用js方法
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // https://www.ganjinsheng.com/user/null
        if webView.url?.absoluteString == "https://www.ganjinsheng.com/user/null" {
            webView.evaluateJavaScript("saveData('" + UserDefaults.getAuthoToken() + "','" + toUrl + "')", completionHandler: nil)
        }
    }
    
    // 网页加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.loading.setProgress(0.0, animated: false)
        setNoWeb()
    }
    
    // 网页加载
    func loadData(){
        self.loading.alpha = 1
        loading.setProgress(0.2, animated: true)
        loading.trackTintColor = .white
        loading.progressTintColor = kLowOrangeColor
        bannerWebView.addSubview(loading)
        print("webAddress",webAddress)
        let url = URL(string: webAddress)!
        let request = URLRequest(url: url)
        bannerWebView.load(request)
        bannerWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    // 监听进度条变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        //  加载进度条
        if keyPath == "estimatedProgress"{
            loading.setProgress(Float((self.bannerWebView.estimatedProgress)), animated: true)
            if (self.bannerWebView.estimatedProgress)  >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                    self.loading.alpha = 0
                }, completion: { (finish) in
                    self.loading.setProgress(0.0, animated: false)
                })
            }
        }
    }
    
    // 销毁方法
    deinit {
        self.bannerWebView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    /*
    **********
    以下为供给js调用的方法
    **********
    */
    
    // 0元购分享方法
    func shareAll(_ data: String) {
        let dataDic = Commons.getDictionaryFromJSONString(data)
        var data = ShareSdkModel()
        data.title = dataDic["title"] as! String
        data.content = dataDic["content"] as! String
        data.url = dataDic["link"] as! String
        data.image = UIImage(named: "logo")
        data.type = .webPage
        let ShareBox = ShareSdkView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: UIScreen.main.bounds.size.height), data: data)
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.addSubview(ShareBox)
    }
    
    // js跳转app内宝贝详情
    func toDetail(_ id: String) {
        detailId = Int(id)
        navigationController?.pushViewController(DetailController(), animated: true)
    }
    // js跳转淘宝商品详情
    func showTaoBaoDetail1(_ url : String) {
        showTaoBaoDetail(url: url)
    }
    // js调起分享弹窗模块
    @objc func shareBox(_ data : [String:String]){
        var shareData = ShareSdkModel()
        shareData.title = data["title"]
        shareData.content = data["content"]
        if let image = data["image"] {
            shareData.type = .image
//            shareData.image =
        } else {
            shareData.type = .webPage
            shareData.url = data["link"]
            shareData.image = UIImage(named: "logo")
        }
        let ShareBox = ShareSdkView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: UIScreen.main.bounds.size.height), data: shareData)
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.addSubview(ShareBox)
    }
    // js复制内容到剪切板
    func copyStr (_ str : String) {
        UIPasteboard.general.string = str
        IDToast.id_show(msg: "复制成功", success: .success)
    }
    // ---------拉新活动------------
    // 立即邀请
    func toInvitePage () {
        navigationController?.pushViewController(ShareController(), animated: true)
    }
    
    
    /*
     ***********
     以下为淘宝授权相关方法
     ***********
     */
    // 淘宝授权
    func tbAuthorize () {
        if !(ALBBSession.sharedInstance()?.isLogin())! {
            ALBBSDK.sharedInstance()?.setAuthOption(NormalAuth)
            ALBBSDK.sharedInstance()?.auth(DetailController(), successCallback: { (session) in
//                self.taobaoWebView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
                self.taobaoWebView.backgroundColor = .white
                self.view.addSubview(self.taobaoWebView)
                accreditTwo(url: "https://oauth.taobao.com/authorize?response_type=token&client_id=27483814&redirect_uri=https://ganjinsheng.com/user/blank&view=wap", nav: self.navigationController!, VC: DetailController(), webView: self.taobaoWebView)
            }, failureCallback: { (session, Error) in
                print("失败了")
            })
        } else {
            let session = ALBBSession.sharedInstance()
//            IDToast.id_show(msg: "已授权", success: .fail)
        }
    }
    
    // 获取rid
    func getRid (_ key : String) {
        
        AlamofireUtil.post(url:"/taobao/autho/saveRelationId", param: [
            "sessionKey" : key
        ],
        success:{(res,data) in
            //更新rid
            print("saveRelationId",data)
            var info = UserDefaults.getInfo()
            info["relationId"] = data.string
            UserDefaults.setInfo(value: info as! [String : String])
        },
        error:{
            
        },
        failure:{
            
        })
    }
    
    // 回首页
    func jumpToMain () {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // 监听webView加载
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        // 截取链接中的sessionKey并传后台
        let url = request.url
        let urlStr = request.url?.absoluteString
        if urlStr!.contains("ganjinsheng.com/user/blank#access_token") {
            let startIndex = ("https://ganjinsheng.com/user/blank#access_token=").count
            let endIndex = urlStr!.positionOf(sub: "&token_type", backwards: false)
            let sessionKey = urlStr!.id_subString(from: startIndex, offSet: endIndex - startIndex)
            self.getRid(sessionKey)
        }
        
        return true
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        // js 模拟点击授权
        webView.stringByEvaluatingJavaScript(from: "document.querySelector('.button-submit').click()")
        
    }

}

@available(iOS 11.0, *)
extension BannerWebViewController: WKScriptMessageHandler {
    ///接收js调用方法
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        ///在控制台中打印html中console.log的内容,方便调试
        let body = message.body
        ///message.name是约定好的方法名,message.body是携带的参数
        switch message.name {
        case "toDetail":
            ///不接收参数时直接不处理message.body即可,不用管Html传了什么
            toDetail(message.body as? String ?? "")
        case "showTaoBaoDetail":
            showTaoBaoDetail1(message.body as? String ?? "")
        case "toInvitePage":
            toInvitePage()
        case "tbAuthorize":
            tbAuthorize()
        case "jumpToMain":
            jumpToMain()
        case "shareAll":
            shareAll(message.body as? String ?? "")
        case "copyStr":
            copyStr(message.body as? String ?? "")
        default:
            break
        }
    }
}
