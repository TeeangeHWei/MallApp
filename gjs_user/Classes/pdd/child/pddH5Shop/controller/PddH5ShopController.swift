//
//  PddH5ShopController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/16.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import WebKit

@available(iOS 11.0, *)
class PddH5ShopController: UIViewController, WKNavigationDelegate, UIWebViewDelegate {
    
    let supermarketWebView = WKWebView(frame: CGRect(x:0 ,y:headerHeight, width: kScreenW, height: kScreenH))
    let noWeb = UIView(frame: CGRect(x: 0, y: (kScreenH-100)/2 - 88, width: kScreenW, height: 140))
    let loading = UIProgressView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 4))
    var webAddress = "https://chaoshi.m.tmall.com/"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let shareBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        shareBtn.addTarget(self, action: #selector(shareBox), for: .touchUpInside)
        shareBtn.setImage(UIImage(named: "icon-share"), for: .normal)
        let shareView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        shareView.addSubview(shareBtn)
        let rightBtn = UIBarButtonItem(customView: shareView)
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
        self.view.addSubview(noWeb)
        self.view.addSubview(supermarketWebView)
        loadData()
        setNav()
        supermarketWebView.navigationDelegate = self
    }
    func setNav(){
    let coustomNavView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height:headerHeight))
        coustomNavView.backgroundColor = .white
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight))
        let navItem = UINavigationItem()
        let backBtn = UIBarButtonItem(image: UIImage(named: "arrow-back"), style: .plain, target: nil, action: #selector(backAction(sender:)))
      
        
        navBar.tintColor = .black
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.isTranslucent = true
        navItem.setLeftBarButton(backBtn, animated: true)
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        title.text = "我的H5商城"
        title.textAlignment = .center
        title.textColor = .black
        navItem.titleView = title
        navBar.pushItem(navItem, animated: true)
        coustomNavView.addSubview(navBar)
        view.addSubview(coustomNavView)
    }
    @objc func backAction(sender:UIButton) -> Void {
        print("触发了+++++")
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AlamofireUtil.cancelAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 顶部返回按钮
    @objc func webBack(){
        if(supermarketWebView.canGoBack){
            supermarketWebView.goBack()
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
        supermarketWebView.addSubview(noWeb)
    }
    
    // 开始加载网页
    func webView(_ webView: WKWebView, didCommit: WKNavigation!){
        let webUrl = webView.url
        let urlStr = webUrl?.absoluteString
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
        supermarketWebView.addSubview(loading)
        let url = URL(string: webAddress)!
        let request = URLRequest(url: url)
        supermarketWebView.load(request)
        supermarketWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    // 监听进度条变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        //  加载进度条
        if keyPath == "estimatedProgress"{
            loading.setProgress(Float((self.supermarketWebView.estimatedProgress)), animated: true)
            if (self.supermarketWebView.estimatedProgress)  >= 1.0 {
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
//        self.supermarketWebView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    // 分享弹窗模块
    @objc func shareBox(){
        var data = ShareSdkModel()
        data.title = "赶紧省"
        data.content = "既能省钱又能赚钱的APP"
        data.url = webAddress
        data.image = UIImage(named: "logo")
        data.type = .webPage
        let ShareBox = ShareSdkView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: UIScreen.main.bounds.size.height), data: data)
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.addSubview(ShareBox)
    }
}
