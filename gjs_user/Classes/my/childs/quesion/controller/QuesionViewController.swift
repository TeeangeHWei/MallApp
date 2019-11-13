//
//  FAQ  FAQ  FAQView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/21.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit
import WebKit

class QuesionViewController : UIViewController, WKNavigationDelegate {
    
    let webView = WKWebView(frame: CGRect(x:0 ,y:headerHeight, width: kScreenW, height: kScreenH - headerHeight))
    let noWeb = UIView(frame: CGRect(x: 0, y: (kScreenH-100)/2 - 88, width: kScreenW, height: 140))
    let loading = UIProgressView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 4))
    let webAddress = "https://www.ganjinsheng.com/user/problemForApp"
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        self.view.addSubview(noWeb)
        self.view.addSubview(webView)
        loadData()
        webView.navigationDelegate = self
    }
    
    func setNav () {
        // 设置nav
        let coustomNavView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height:headerHeight))
        coustomNavView.backgroundColor = .white
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight))
        let navItem = UINavigationItem()
        let backBtn = UIBarButtonItem(image: UIImage(named: "arrow-back"), style: .plain, target: nil, action: #selector(backAction(sender:)))
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        navBar.tintColor = kMainTextColor
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.isTranslucent = true
        navItem.setLeftBarButton(backBtn, animated: true)
        title.text = "常见问题"
        title.textAlignment = .center
        title.textColor = kMainTextColor
        navItem.titleView = title
        navBar.pushItem(navItem, animated: true)
        coustomNavView.addSubview(navBar)
        self.view.addSubview(coustomNavView)
        let leftBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(webBack))
        leftBtn.image = UIImage(named: "arrow-back")
        leftBtn.tintColor = kMainTextColor
        self.navigationItem.leftBarButtonItem = leftBtn;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AlamofireUtil.cancelAll()
    }
    
    // 返回
    @objc func backAction(sender:UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
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
    
}
