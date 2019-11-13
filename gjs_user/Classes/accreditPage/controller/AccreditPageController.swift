//
//  FAQ  FAQ  FAQView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/21.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit
import WebKit
import WKCookieWebView

fileprivate class WKCookieProcessPool: WKProcessPool {
    static let pool = WKCookieProcessPool()
}

class AccreditPageController : UIViewController, WKNavigationDelegate {

    var again = true
    lazy var webView: WKCookieWebView = {
        let webView: WKCookieWebView = WKCookieWebView(frame: self.view.bounds)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.wkNavigationDelegate = self
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let urlString = "https://oauth.taobao.com/authorize?response_type=token&client_id=27483814&redirect_uri=https://ganjinsheng.com/user/blank&view=wap"
        let isNeedPreloadForCookieSync = true
        
        if isNeedPreloadForCookieSync {
            // After running the app, before the first webview was loaded,
            // Cookies may not be set properly,
            // In that case, use the loader in advance to synchronize.
            // You can use the webview.
            WKCookieWebView.preloadWithDomainForCookieSync(urlString: urlString) { [weak self] in
                self?.setupWebView()
                self?.webView.load(URLRequest(url: URL(string: urlString)!))
            }
        } else {
            setupWebView()
            webView.load(URLRequest(url: URL(string: urlString)!))
        }
    }
    
    // MARK: - Private
    private func setupWebView() {
        view.addSubview(webView)
        
        let views: [String: Any] = ["webView": webView]
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[webView]-0-|",
            options: [],
            metrics: nil,
            views: views))
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[webView]-0-|",
            options: [],
            metrics: nil,
            views: views))
        
        webView.onDecidePolicyForNavigationAction = { (webView, navigationAction, decisionHandler) in
            decisionHandler(.allow)
        }
        
        webView.onDecidePolicyForNavigationResponse = { (webView, navigationResponse, decisionHandler) in
            decisionHandler(.allow)
        }
        
        webView.onUpdateCookieStorage = { [weak self] (webView) in
            self?.printCookie()
        }
    }
    
    private func printCookie() {
        print("=====================Cookies=====================")
        HTTPCookieStorage.shared.cookies?.forEach {
            print($0)
        }
        print("=================================================")
    }
    
    // 开始加载网页
    func webView(_ webView: WKWebView, didCommit: WKNavigation!){
        print("url::::::::::::::::::::::",webView.url)
        let url = webView.url
        let urlStr : String = url!.absoluteString
        if urlStr.contains("ganjinsheng.com/user/blank#access_token") {
            let startIndex = ("https://ganjinsheng.com/user/blank#access_token=").count
            let endIndex = urlStr.positionOf(sub: "&token_type", backwards: false)
            let sessionKey = urlStr.id_subString(from: startIndex, offSet: endIndex - startIndex)
            self.getRid(sessionKey)
        }
    }
    
    // 获取rid
    func getRid (_ key : String) {
        
        AlamofireUtil.post(url:"/taobao/autho/saveRelationId", param: [
            "sessionKey" : key
        ],
        success:{(res,data) in
            //更新rid
            var info = UserDefaults.getInfo()
            info["relationId"] = data.string
            UserDefaults.setInfo(value: info as! [String : String])
        },
        error:{
            
        },
        failure:{
            
        })
    }
}


extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail.error : \(error)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("didFailProvisionalNavigation.error : \(error)")
    }
    
}
