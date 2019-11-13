//
//  LoginViewController.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/8/24.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class LoginViewController: ViewController {

    private let loginView = LoginView(frame:CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - headerHeight))
    override func viewDidLoad() {
        super.viewDidLoad()
        let navView = customNav(titleStr: "手机登录", titleColor: kMainTextColor, border: false)
        self.view.addSubview(navView)
        self.view.backgroundColor = .white
        loginView.sms.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(toSMSLogin)))
        loginView.forget.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(toForget)))
        loginView.btn.addTarget(self, action: #selector(login), for: .touchUpInside)
        self.view.addSubview(loginView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
//        setNav(titleStr: "手机登录", titleColor: kMainTextColor, navItem: navigationItem, navController: navigationController)
    }
    
    //短信登录
    @objc func toSMSLogin(){
        navigationController?.pushViewController(LoginByPhoneViewController(), animated: true)
    }
    //忘记密码
    @objc func toForget(){
        navigationController?.pushViewController(ForgetViewController(), animated: true)
    }
    
    //登录
    @objc func login () {
        if(loginView.account.text!==""||loginView.password.text!==""){
            IDToast.id_show(msg: "请填写完整信息", success: .fail)
            return
        }
        IDLoading.id_showWithWait()
        AlamofireUtil.post(url:"/user/autho/public/loginByAccount", param: ["phone":loginView.account.text!,"password":loginView.password.text!],
            success:{(res,data) in
                UserDefaults.setAuthoToken(value: data["token"].description)
                self.getInfo()
                IDLoading.id_dismissWait()
                IDToast.id_show(msg: "登录成功", success: .success)
                let vcCount = self.navigationController?.viewControllers.count
                self.navigationController?.popToViewController((self.navigationController?.viewControllers[vcCount! - 3])!, animated: true)
            },
            error:{
                IDLoading.id_dismissWait()
            },
            failure:{
                IDLoading.id_dismissWait()
        })
    }
    
    // 获取用户信息
    func getInfo(){
        AlamofireUtil.post(url:"/user/info/getUserInfo", param: [:],
        success:{(res, data) in
            // 获取并将用户信息保存到缓存中
            UserDefaults.setInfo(value: data.dictionary!.compactMapValues({ (data) -> String? in
                data.description
            }))
        },
        error:{},
        failure:{})
    }
}
