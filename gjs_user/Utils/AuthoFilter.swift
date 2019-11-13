//
//  AuthoFilter.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/8/29.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

@available(iOS 11.0, *)
private let swizzling: (UIViewController.Type) -> () = { viewController in
    
    let originalSelector = #selector(viewController.viewDidLoad)
    let swizzledSelector = #selector(viewController.proj_viewWillAppear(animated:))
    
    let originalMethod = class_getInstanceMethod(viewController, originalSelector)
    let swizzledMethod = class_getInstanceMethod(viewController, swizzledSelector)
    
    method_exchangeImplementations(originalMethod!, swizzledMethod!)
}

// 重写UIVIewController，添加全局过滤拦截
@available(iOS 11.0, *)
extension UIViewController {
    
    open class func initClass() {
        guard self === UIViewController.self else { return }
        swizzling(self)
    }
    
    @objc func proj_viewWillAppear(animated: Bool) {
        self.proj_viewWillAppear(animated: animated)
        let viewControllerName = NSStringFromClass(type(of: self))
        //放行路径
        var flag = false
        let publicView = ["Home","BaseView","TabBarView","Classify","LoginCommonView","LoginByPhone", "LoginView","ForgetView","SignupView"]
        for item in publicView {
            // 路径包含“放行路径”
            if viewControllerName.contains(item){
                flag = true
                break
            }
        }
        // 验证是否存在密钥
        if(!flag && UserDefaults.getAuthoToken() == ""){
            navigationController?.pushViewController(LoginCommonViewController(), animated: false)
        }
    }
}
