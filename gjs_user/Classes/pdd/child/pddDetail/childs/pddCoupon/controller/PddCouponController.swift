//
//  PddCouponController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/18.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import WebKit

class PddCouponController: UIViewController, WKNavigationDelegate, UIWebViewDelegate, WKUIDelegate {

    lazy var pddCouponWebView: WKWebView = {
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
    let noWeb = UIView(frame: CGRect(x: 0, y: (kScreenH-100)/2 - 88, width: kScreenW, height: 140))
    let loading = UIProgressView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 4))
    var webAddress = "https://pages.tmall.com/wow/jinkou/act/zhiyingchaoshi"
    var goodsId = ""
    var couponUrl = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        self.view.addSubview(noWeb)
        // 添加跨域
        pddCouponWebView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        pddCouponWebView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        self.view.addSubview(pddCouponWebView)
        loadData()
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
        title.text = "领取优惠券"
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
        },
        error:{
                            
        },
        failure:{
                            
        })
    }
    
    // 顶部返回按钮
    @objc func webBack(){
        if(pddCouponWebView.canGoBack){
            pddCouponWebView.goBack()
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
        pddCouponWebView.addSubview(noWeb)
    }
    
    // 开始加载网页
    func webView(_ webView: WKWebView, didCommit: WKNavigation!){
        let webUrl = webView.url
        let urlStr = webUrl?.absoluteString
        print("识别到的url:::::::::::::",urlStr)
    }
    
    // 重新加载网页
    @objc func reloadWeb(){
        noWeb.removeFromSuperview()
        loadData()
    }
    
    // 网页加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.loading.setProgress(0.0, animated: false)
//        setNoWeb()
    }
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        let url = navigationResponse.response.url
//        print("监听到的链接::::::::::::",url)
//        let urlString = (url != nil) ? (url?.absoluteString)! : ""
//        if urlString.contains("pinduoduo://") && UIApplication.shared.canOpenURL(URL.init(string: "pinduoduo://")!) {
//            UIApplication.shared.openURL(url!)
//            decisionHandler(.cancel)
//            return
//        } else if urlString.contains("alipay://") && UIApplication.shared.canOpenURL(URL.init(string: "alipay://")!) {
//            UIApplication.shared.openURL(url!)
//            decisionHandler(.cancel)
//            return
//        } else if urlString.contains("weixin://") && UIApplication.shared.canOpenURL(URL.init(string: "weixin://")!) {
//            UIApplication.shared.openURL(url!)
//            decisionHandler(.cancel)
//            return
//        }
//        decisionHandler(.allow)
//    }
    
    // 尝试拿到urlschemes
    @available(iOS 10.0, *)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,  decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        let url = navigationAction.request.url
        let urlString = (url != nil) ? (url?.absoluteString)! : ""
        if urlString.contains("pinduoduo://") && UIApplication.shared.canOpenURL(URL.init(string: "pinduoduo://")!) {
            UIApplication.shared.openURL(url!)
            decisionHandler(.cancel)
            return
        } else if urlString.contains("alipay://") && UIApplication.shared.canOpenURL(URL.init(string: "alipay://")!) {
            UIApplication.shared.openURL(url!)
            decisionHandler(.cancel)
            return
        } else if urlString.contains("weixin://") && UIApplication.shared.canOpenURL(URL.init(string: "weixin://")!) {
            UIApplication.shared.openURL(url!)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
    // 内部链接点击
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if navigationAction.targetFrame == nil {
//            webView.load(navigationAction.request)
//        }
//        decisionHandler(WKNavigationActionPolicy.allow)
//    }
    
    
    // 网页加载
    func loadData(){
        self.loading.alpha = 1
        loading.setProgress(0.2, animated: true)
        loading.trackTintColor = .white
        loading.progressTintColor = kLowOrangeColor
        pddCouponWebView.addSubview(loading)
        let url = URL(string: webAddress)!
        let request = URLRequest(url: url)
        pddCouponWebView.load(request)
        pddCouponWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    // 监听进度条变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        //  加载进度条
        if keyPath == "estimatedProgress" {
            loading.setProgress(Float((self.pddCouponWebView.estimatedProgress)), animated: true)
            if (self.pddCouponWebView.estimatedProgress)  >= 1.0 {
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

}
