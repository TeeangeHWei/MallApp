//
//  ForgetViewController.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/8/24.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class ForgetViewController: ViewController {
    
    private let forgetView = ForgetView(frame: CGRect(x: 0, y: headerHeight+kCateTitleH, width: kScreenW, height: kScreenH))
    private var verifySign : String! = ""
    private var phoneSign : String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navView = customNav(titleStr: "忘记密码", titleColor: kMainTextColor, border: false)
               self.view.addSubview(navView)
        self.view.backgroundColor = .white
//        setNav(titleStr: "忘记密码", titleColor: kMainTextColor, navItem: navigationItem, navController: navigationController)
        //获取图片验证码
        self.verifyClick()
        forgetView.verifyImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(verifyClick)))
        //获取短信验证码
        CountDown.countDownSchedule(btn: forgetView.phoneCodeBtn)
        forgetView.phoneCodeBtn.addTarget(self, action: #selector(phoneCodeClick), for: .touchUpInside)
        forgetView.btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.view.addSubview(forgetView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.navigationBar.isHidden = false
    }
    
    //获取图片验证码
    @objc func verifyClick(){
        AlamofireUtil.get(url: "/public/verifyCode",
            success: {(res,data) in
                self.forgetView.verifyImg.image = UIImage(data: data)
                self.verifySign = res.allHeaderFields[AnyHashable("verifysign")] as? String
            },
            failure: {
                            
        })
    }
    
    //获取验证码
    @objc func phoneCodeClick(){
        CountDown.countDown(btn: forgetView.phoneCodeBtn, phone: forgetView.phone.text!,
                          verify: forgetView.verify.text!, verifySign: self.verifySign!, type: 1,
        success: { (data) in
            if(data != "warning"){
                self.phoneSign = data
            }
        })
    }
    
    //重置密码
    @objc func btnClick(){
        if(forgetView.phone.text!==""||forgetView.verify.text!==""||forgetView.phoneCode.text!==""||forgetView.password.text!==""){
            IDToast.id_show(msg: "请填写完整信息", success:.fail)
            return
        }
        if forgetView.password.text!.count < 6{
            IDToast.id_show(msg: "密码至少6位", success:.fail)
            return
        }
        if forgetView.password.text! != forgetView.rePassword.text!{
            IDToast.id_show(msg: "密码输入不一致", success:.fail)
            return
        }
        IDLoading.id_showWithWait()
        AlamofireUtil.post(url: "/user/autho/public/findPassword",
            param: [
                "phone":forgetView.phone.text!,
                "phoneCode":forgetView.phoneCode.text!,
                "phoneSign":self.phoneSign!,
                "newPassword":forgetView.password.text!
            ],
            success: {(res, data) in
                IDLoading.id_dismissWait()
                IDToast.id_show(msg: "密码重置成功",success:.success)
//                self.navigationController?.pushViewController(LoginViewController(), animated: true)
                self.navigationController?.popViewController(animated: true)
            },
            error: {
                
            },
            failure: {
        })
    }

}
