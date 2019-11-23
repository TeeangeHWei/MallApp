//
//  ExpertArticleController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/29.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import WebKit


@available(iOS 11.0, *)
class ExpertArticleController : UIViewController, WKNavigationDelegate {
    
    
    lazy var webView: WKWebView = {
        ///偏好设置
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.selectionGranularity = WKSelectionGranularity.character
        configuration.userContentController = WKUserContentController()
        // 给webview与swift交互起名字，webview给swift发消息的时候会用到
        configuration.userContentController.add(WeakScriptMessageDelegate(self), name: "toDetail")

        var webView = WKWebView(frame: CGRect(x: 0,
                                              y: headerHeight,
                                              width: kScreenW,
                                              height: kScreenH),
                                configuration: configuration)
        // 让webview翻动有回弹效果
        webView.scrollView.bounces = false
        // 只允许webview上下滚动
        webView.scrollView.alwaysBounceVertical = true
        webView.navigationDelegate = self
        return webView
    }()
    
//    let webView = WKWebView(frame: CGRect(x:0 ,y:-55, width: kScreenW, height: kScreenH))
    let noWeb = UIView(frame: CGRect(x: 0, y: (kScreenH-100)/2 - 88, width: kScreenW, height: 140))
    let loading = UIProgressView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 4))
    let webAddress = "https://www.ganjinsheng.com/user/page/expertArticle"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        self.view.addSubview(noWeb)
        self.view.addSubview(webView)
        loadData()
        webView.navigationDelegate = self
    }
    
    func setNav(){
    let coustomNavView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height:headerHeight))
        coustomNavView.backgroundColor = .white
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight))
        let navItem = UINavigationItem()
        let backBtn = UIBarButtonItem(image: UIImage(named: "arrow-back"), style: .plain, target: nil, action: #selector(backAction(sender:)))
      
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        navBar.tintColor = .black
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.isTranslucent = true
        navItem.setLeftBarButton(backBtn, animated: true)
        title.text = "达人说"
        title.textAlignment = .center
        title.textColor = .black
        navItem.titleView = title
        navBar.pushItem(navItem, animated: true)
        coustomNavView.addSubview(navBar)
        view.addSubview(coustomNavView)
    }
    @objc func backAction(sender:UIButton) -> Void {
       
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 顶部返回按钮
    @objc func webBack(){
        if(webView.canGoBack){
            webView.goBack()
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
        webView.addSubview(noWeb)
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
    
    // 网页加载
    func loadData(){
        self.loading.alpha = 1
        loading.setProgress(0.2, animated: true)
        loading.trackTintColor = .white
        loading.progressTintColor = kLowOrangeColor
        webView.addSubview(loading)
        let url = URL(string: webAddress)!
        let request = URLRequest(url: url)
        webView.load(request)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    // 监听进度条变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        //  加载进度条
        if keyPath == "estimatedProgress"{
            loading.setProgress(Float((self.webView.estimatedProgress)), animated: true)
            if (self.webView.estimatedProgress)  >= 1.0 {
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
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    // js跳转app内宝贝详情
    func toDetail(_ id: String) {
        detailId = Int(id)
        navigationController?.pushViewController(DetailController(), animated: true)
    }
}

@available(iOS 11.0, *)
extension ExpertArticleController: WKScriptMessageHandler {
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
        default:
            break
        }
    }
}




//class ExpertArticleController: UIViewController {
//    
//    var body : ExpertArticleView?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = .white
//        getData()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setNav(titleStr: "达人说", titleColor: kMainTextColor, navItem: navigationItem, navController: navigationController)
//    }
//    
//    func getData () {
//        AlamofireUtil.post(url:"/product/public/talentInfo", param: ["talentcat":0],
//        success:{(res,data) in
//            // topdata 轮播图数据
//            let topdata = data["data"]["topdata"]
//            articelBannerImg = [String]()
//            for topItem in topdata.array! {
//                let app_image = topItem["app_image"]
//                articelBannerImg.append(app_image.string!)
//            }
//            // newdata 本周最新
//            newWeekDataList = NewWeekDataList.deserialize(from: data["data"].description)!.newdata!
//            // clickdata 大家都在看
//            articleList = ArticleList.deserialize(from: data["data"].description)!.clickdata!
//            self.body = ExpertArticleView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - headerHeight))
//            self.view.addSubview(self.body!)
//        },
//        error:{
//            
//        },
//        failure:{
//            
//        })
//    }
//}
