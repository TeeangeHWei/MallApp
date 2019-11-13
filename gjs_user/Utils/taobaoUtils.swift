//
//  taobaoUtils.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/9.
//  Copyright © 2019 大杉网络. All rights reserved.
//
import WebKit
    
// 判断淘宝
func canToTaobao () {
    print(UIApplication.shared.canOpenURL(URL(string: "taobao://")!))
    if (UIApplication.shared.canOpenURL(URL(string: "taobao://")!)) {
        print("yes")
    } else {
        print("no")
    }
}

// 二次授权
func accreditTwo (url: String, nav: UINavigationController, VC: UIViewController, webView: UIWebView) {
    
    print("进入二次授权方法")
    let taobaoWebView = webView
    
    let view = AlibcWebViewController.init()
    let showParam = AlibcTradeShowParams.init()
    showParam.openType = AlibcOpenType.auto
    showParam.isNeedPush = true
    showParam.isNeedCustomNativeFailMode = true
    showParam.nativeFailMode = .jumpH5
    showParam.linkKey = "taobao"
    let res = AlibcTradeSDK.sharedInstance()?.tradeService()?.open(byUrl: url, identity: "trade", webView: taobaoWebView, parentController: view, showParams: showParam, taoKeParams: nil, trackParam: nil, tradeProcessSuccessCallback: { (AlibcTradeResult) in
        print("调用open成功")
        print(AlibcTradeResult)
    }, tradeProcessFailedCallback: { (Error) in
        print("调用open失败")
        print(Error)
    })
    
//    if res == 1 {
//        nav.pushViewController(VC, animated: true)
//    }
}



//打开淘宝详情
func showTaoBaoDetail(url:String) {

//    if UIApplication.shared.canOpenURL(URL(string: "taobao://")!) {
    
        let view = AlibcWebViewController.init()
        let showParam = AlibcTradeShowParams.init()
        showParam.openType = AlibcOpenType.native
        showParam.isNeedPush = true
        showParam.isNeedCustomNativeFailMode = true
        showParam.nativeFailMode = .jumpH5
        showParam.linkKey = "taobao"
        AlibcTradeSDK.sharedInstance()?.tradeService()?.open(byUrl: url, identity: "trade", webView: nil, parentController: view, showParams: showParam, taoKeParams: nil, trackParam: nil, tradeProcessSuccessCallback: { (AlibcTradeResult) in
            
        }, tradeProcessFailedCallback: { (Error) in
            
        })
        
//    }

}


