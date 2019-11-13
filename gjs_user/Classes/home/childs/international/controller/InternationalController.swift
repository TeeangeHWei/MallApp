//
//  InternationalController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/4.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import WebKit

class InternationalController: UIViewController, WKNavigationDelegate, UIWebViewDelegate, WKUIDelegate {

    var isCancel = false
    lazy var internationalWebView: WKWebView = {
        ///偏好设置
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.setValue(true, forKey: "_allowUniversalAccessFromFileURLs")
        configuration.preferences = preferences
        configuration.selectionGranularity = WKSelectionGranularity.character
        configuration.userContentController = WKUserContentController()
        // 给webview与swift交互起名字，webview给swift发消息的时候会用到
//        configuration.userContentController.add(WeakScriptMessageDelegate(self), name: "toDetail")

        var webView = WKWebView(frame: CGRect(x: 0,
                                              y: headerHeight,
                                              width: kScreenW,
                                              height: kScreenH - headerHeight),
                                configuration: configuration)
        // 让webview翻动有回弹效果
        webView.scrollView.bounces = false
        // 只允许webview上下滚动
        webView.scrollView.alwaysBounceVertical = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        return webView
    }()
//    var internationalWebView = WKWebView(frame: CGRect(x:0 ,y:0, width: kScreenW, height: kScreenH))
    let noWeb = UIView(frame: CGRect(x: 0, y: (kScreenH-100)/2 - 88, width: kScreenW, height: 140))
    let loading = UIProgressView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 4))
    let webAddress = "https://pages.tmall.com/wow/jinkou/act/zhiyingchaoshi"
    var goodsId = ""
    var couponUrl = ""
    let taobaoWebView = UIWebView()
    let topView = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 40))
    let bottomView = UIView(frame: CGRect(x: 0, y: kScreenH - headerHeight - 50, width: kScreenW, height: 50))
    let bottomBtn = UIButton(frame: CGRect(x: 50, y: 5, width: kScreenW - 100, height: 40))
    let shareBtn = UIButton(frame: CGRect(x: 50, y: 5, width: (kScreenW - 100) * 0.4, height: 40))
    let buyBtn = UIButton(frame: CGRect(x: 50 + (kScreenW - 100) * 0.4, y: 5, width: (kScreenW - 100) * 0.6, height: 40))
    
    override func viewWillAppear(_ animated: Bool) {
        isCancel = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        // 二次授权webView配置
        taobaoWebView.delegate = self
        self.view.addSubview(noWeb)
        // 添加跨域
        internationalWebView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        internationalWebView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        self.view.addSubview(internationalWebView)
        loadData()
        // 顶部遮盖层
        topView.text = "请点击底部按钮“搜卷查收益”"
        topView.font = FontSize(14)
        topView.textAlignment = .center
        topView.isHidden = true
        topView.backgroundColor = colorwithRGBA(255, 231, 171, 1)
        self.view.addSubview(topView)
        
        bottomView.backgroundColor = .white
        bottomView.isHidden = true
        self.view.addSubview(bottomView)
        // 搜索按钮
        bottomBtn.setTitle("搜券查收益", for: .normal)
        bottomBtn.setTitleColor(kMainTextColor, for: .normal)
        bottomBtn.addTarget(self, action: #selector(self.getData), for: .touchUpInside)
        bottomBtn.layer.cornerRadius = 20
        bottomBtn.titleLabel?.font = FontSize(14)
        bottomBtn.backgroundColor = colorwithRGBA(255, 210, 15, 1)
        bottomView.addSubview(bottomBtn)
        // 分享按钮
        shareBtn.isHidden = true
        shareBtn.backgroundColor = colorwithRGBA(255, 210, 15, 1)
        shareBtn.setTitle("分享", for: .normal)
        shareBtn.setTitleColor(kMainTextColor, for: .normal)
        shareBtn.titleLabel?.font = FontSize(14)
        shareBtn.layer.mask = shareBtn.configRectCorner(view: shareBtn, corner: [.bottomLeft, .topLeft], radii: CGSize(width: 20, height: 20))
        bottomView.addSubview(shareBtn)
        // 购买按钮
        buyBtn.addTarget(self, action: #selector(self.toBuy), for: .touchUpInside)
        buyBtn.isHidden = true
        buyBtn.backgroundColor = colorwithRGBA(42, 40, 42, 1)
        buyBtn.setTitle("立即购买", for: .normal)
        buyBtn.setTitleColor(.white, for: .normal)
        buyBtn.titleLabel?.font = FontSize(14)
        buyBtn.layer.mask = buyBtn.configRectCorner(view: buyBtn, corner: [.bottomRight, .topRight], radii: CGSize(width: 20, height: 20))
        bottomView.addSubview(buyBtn)
    }
    
    func setNav () {
        let coustomNavView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height:headerHeight))
        coustomNavView.backgroundColor = .white
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight))
        let navItem = UINavigationItem()
        let backBtn = UIBarButtonItem(image: UIImage(named: "arrow-back"), style: .plain, target: nil, action: #selector(webBack))
        navItem.setLeftBarButton(backBtn, animated: true)
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        navBar.tintColor = kMainTextColor
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.isTranslucent = true
        title.text = "天猫国际"
        title.textAlignment = .center
        title.textColor = kMainTextColor
        navItem.titleView = title
        navBar.pushItem(navItem, animated: true)
        coustomNavView.addSubview(navBar)
        self.view.addSubview(coustomNavView)
    }
    
    // 获取宝贝信息
    @objc func getData (_ btn: UIButton) {
        AlamofireUtil.post(url:"/product/public/detail", param: ["itemid" : goodsId],
        success:{(res,data) in
            let goodsInfo = DetailData.deserialize(from: data["data"].description)!
            // 计算收益
            let commission = Commons.strToDou(goodsInfo.tkmoney!) * Commons.getScale()
            self.topView.text = "预估收益：\(String(format:"%.2f",commission))元"
            self.bottomBtn.isHidden = true
            self.shareBtn.isHidden = false
            self.buyBtn.isHidden = false
//            delegate.window?.viewWithTag(101)?.removeFromSuperview()
        },
        error:{
                            
        },
        failure:{
                            
        })
    }
    
    // 顶部返回按钮
    @objc func webBack(){
        if(internationalWebView.canGoBack){
            internationalWebView.goBack()
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
        internationalWebView.addSubview(noWeb)
    }
    
    // 开始加载网页
    func webView(_ webView: WKWebView, didCommit: WKNavigation!){
        let webUrl = webView.url
        let urlStr = webUrl?.absoluteString
        print(urlStr)
        // 判断并截取宝贝id
        if urlStr!.contains("item.htm") {
            topView.isHidden = false
            bottomView.isHidden = false
            let startIndex = urlStr!.positionOf(sub: "&id=", backwards: false) + 4
            var endIndex = urlStr!.positionOf(sub: "&scm=", backwards: false)
//            if endIndex - startIndex > 15 {
//                endIndex = urlStr!.positionOf(sub: "&locType=", backwards: false)
//            }
            goodsId = urlStr!.id_subString(from: startIndex, offSet: endIndex - startIndex)
        } else {
            topView.isHidden = true
            bottomView.isHidden = true
            bottomBtn.isHidden = false
            shareBtn.isHidden = true
            buyBtn.isHidden = true
        }
    }
    
    // 重新加载网页
    @objc func reloadWeb(){
        noWeb.removeFromSuperview()
        loadData()
    }
    
    // 网页加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.loading.setProgress(0.0, animated: false)
        setNoWeb()
    }
    
    // 内部链接点击
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    
    // 网页加载
    func loadData(){
        self.loading.alpha = 1
        loading.setProgress(0.2, animated: true)
        loading.trackTintColor = .white
        loading.progressTintColor = kLowOrangeColor
        internationalWebView.addSubview(loading)
        let url = URL(string: webAddress)!
        let request = URLRequest(url: url)
        internationalWebView.load(request)
        internationalWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    // 监听进度条变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        //  加载进度条
        if keyPath == "estimatedProgress"{
            loading.setProgress(Float((self.internationalWebView.estimatedProgress)), animated: true)
            if (self.internationalWebView.estimatedProgress)  >= 1.0 {
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
//        self.internationalWebView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    
    // 淘宝授权
    func accredit () {
        if !(ALBBSession.sharedInstance()?.isLogin())! {
            ALBBSDK.sharedInstance()?.setAuthOption(NormalAuth)
            ALBBSDK.sharedInstance()?.auth(SupermarketController(), successCallback: { (session) in
                self.taobaoWebView.backgroundColor = .white
                self.view.addSubview(self.taobaoWebView)
                accreditTwo(url: "https://oauth.taobao.com/authorize?response_type=token&client_id=27483814&redirect_uri=https://ganjinsheng.com/user/blank&view=wap", nav: self.navigationController!, VC: SupermarketController(), webView: self.taobaoWebView)
            }, failureCallback: { (session, Error) in
                print("失败了")
            })
        } else {
            let session = ALBBSession.sharedInstance()
//            IDToast.id_show(msg: "已授权", success: .fail)
        }
    }
    
    // 立即购买
    @objc func toBuy(_ btn: UIButton) {
        // 高佣转链
        self.getUrl(1)
    }
    
    // 获取rid
    func getRid (_ key : String) {
        
        AlamofireUtil.post(url:"/taobao/autho/saveRelationId", param: [
            "sessionKey" : key
        ],
        success:{(res,data) in
            if self.isCancel {
                return
            }
            //更新rid
            var info = UserDefaults.getInfo()
            info["relationId"] = data.string!
            UserDefaults.setInfo(value: info as! [String : String])
        },
        error:{
            
        },
        failure:{
            
        })
    }
    
    // 高佣转链
    func getUrl (_ n : Int) {
        if let rid = UserDefaults.getInfo()["relationId"] {
            AlamofireUtil.post(url:"/product/public/ratesurl", param: [
                "itemid" : self.goodsId,
                "relation_id" : rid
            ],
            success:{(res,data) in
                if data["code"] != nil && data["code"] == 1 {
                    // 好单库接口
                    
                } else {
                    if data["tbk_privilege_get_response"]["result"]["data"]["coupon_click_url"] != nil {
                        if data["tbk_privilege_get_response"]["result"]["data"]["coupon_total_count"] != nil {
                            self.couponUrl = data["tbk_privilege_get_response"]["result"]["data"]["coupon_click_url"].string!
                        } else {
                            self.couponUrl = data["tbk_privilege_get_response"]["result"]["data"]["item_url"].string!
                        }
                    } else {
                        if data["msg"] == "您淘宝未授权，请到好单库放单后台授权页面授权！" {
                            IDToast.id_show(msg: "您淘宝未授权", success: .fail)
                        } else {
                            IDToast.id_show(msg: "该宝贝已下架", success: .fail)
                        }
                        return
                    }
                }
                if n == 1 {
                    // 打开淘宝优惠券
                    showTaoBaoDetail(url: self.couponUrl)
                } else {
                    // 分享
                }
            },
            error:{
                
            },
            failure:{
                
            })
        } else {
            print("没有rid")
            self.accredit()
        }
    }
    
    // UIView监听方法
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
