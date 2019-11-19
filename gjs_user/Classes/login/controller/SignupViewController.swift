//
//  SignupViewController.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/8/24.
//  Copyright © 2019 大杉网络. All rights reserved.
//
import UIKit

@available(iOS 11.0, *)
class SignupViewController: UIViewController {

    var openId : String?
    var nickname : String?
    var avatar : String?
    private var step = 1
    private let signupView = SignupView(frame: CGRect(x: 0, y: headerHeight+kCateTitleH, width: kScreenW, height: kScreenH))
    private var verifySign:String! = ""
    private var phoneSign:String! = ""
    private var parentId:String! = ""
    
    //自定义头部
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.isHidden = false
//        setNav(titleStr: "注册账号", titleColor: kMainTextColor, navItem: navigationItem, navController: navigationController)
//        let leftBtn = UIBarButtonItem(title: "上一步", style: .plain, target: self, action: #selector(backBefore))
//        leftBtn.tintColor = kHighOrangeColor
//        leftBtn.setTitleTextAttributes([NSAttributedString.Key.font: FontSize(14)], for: .normal)
//        self.navigationItem.leftBarButtonItem = leftBtn;
    }
    
    @objc func backBefore(){
        if(step == 1){
            navigationController?.popViewController(animated: true)
        }else{
            if(step == 5){
                step = 3
            }else{
                step -= 1
            }
            nextStep()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        signupView.nextBtn.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        self.nextStep()
        self.view.addSubview(signupView)
        setNavUi()
    }

    func setNavUi(){
        
        navigationController?.navigationBar.isHidden = true
        let topView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: headerHeight))
        topView.backgroundColor = .clear
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight))
        navBar.backgroundColor = .clear
        let navItem = UINavigationItem()
        let backBtn = UIBarButtonItem(title: "上一步", style: .plain, target: self, action: #selector(backBefore))
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        title.text = "注册账号"
        title.textAlignment = .center
        title.textColor = .black
        navItem.titleView = title
        backBtn.tintColor = kHighOrangeColor
        backBtn.setTitleTextAttributes([NSAttributedString.Key.font: FontSize(14)], for: .normal)
        navItem.setLeftBarButton(backBtn, animated: true)
        navBar.tintColor = .white
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.pushItem(navItem, animated: true)
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.view.addSubview(topView)
        topView.addSubview(navBar)
        
    }
    //下一步按钮
    @objc func nextStep() {
        self.signupView.activeBtn(flag: false)
        if step == 1{
            if UserDefaults.getIsShow() == 1{
                signupView.firstStep()
                signupView.invite.addTarget(self, action: #selector(getSuper), for: .editingChanged)
            }else{
                signupView.secondStep()
                signupView.invite.addTarget(self, action: #selector(getSuper), for: .editingChanged)
                signupView.phone.addTarget(self, action: #selector(checkPhone), for: .editingChanged)
            }
            
        }else if step == 2{
            signupView.secondStep()
            signupView.phone.addTarget(self, action: #selector(checkPhone), for: .editingChanged)
        }else if step == 3{
            signupView.thridStep()
            self.verifyClick()
            signupView.verifyImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(verifyClick)))
            signupView.verify.addTarget(self, action: #selector(inputVerify), for: .editingChanged)
            signupView.phoneCodeBtn.addTarget(self, action: #selector(phoneCodeClick), for: .touchUpInside)
        }else if step == 4{
            signupView.fourthStep()
            self.signupView.activeBtn(flag: true)
            step += 1
        }else if step == 5{
            self.signupView.activeBtn(flag: true)
            signup()
        }
    }
    
    //获取上级信息(限制只能输入6位)
    @objc func getSuper(){
        if((signupView.invite.text ?? "").count == 6){
            self.signupView.activeBtn(flag: false)
            AlamofireUtil.post(url: "/user/info/public/getUserByCode",
            param: [
                "code":signupView.invite.text!,
            ],
            success: {(res, data) in
                if(!data.isEmpty && data != ""){
                    self.signupView.superInfo(headerStr: data["headPortrait"].description, nickStr: data["nickName"].description)
                    self.signupView.activeBtn(flag: true)
                    self.parentId = data["id"].description
                    print("dataid::::",self.parentId)
                    self.step = 2
                }else{
                    self.signupView.superInfo()
                    self.signupView.activeBtn(flag: false)
                }
            },
            error: {
            },
            failure: {
            })
        }else if((signupView.invite.text ?? "").count > 6){ //超出部分截取
            signupView.invite.text = signupView.invite.text?.id_subString(from: 0, offSet: 6)
        }else{
            self.signupView.superInfo()
            self.signupView.activeBtn(flag: false)
        }
    }
    
    //验证手机号码（合法性，是否存在）限制11位，超出隐藏
    @objc func checkPhone(){
        if(signupView.phone.text?.count == 11){
            self.signupView.activeBtn(flag: false)
            if(Commons.isPhone(phone: signupView.phone.text ?? "")){
                AlamofireUtil.post(url: "/user/autho/public/validatedPhone",
                param: [
                    "phone":signupView.phone.text!
                ],
                success: {(res, data) in
                    if(data.description == "false"){
                        self.step = 3
                        self.signupView.activeBtn(flag: true)
                    }else{
                        IDToast.id_show(msg: "手机号码被占用", success:.fail)
                    }
                },
                error: {
                },
                failure: {
                })
            }else{
                IDToast.id_show(msg: "手机格式错误", success:.fail)
            }
        }else if((signupView.phone.text ?? "").count > 11){
            signupView.phone.text = signupView.phone.text?.id_subString(from: 0, offSet: 11)
        }else{
            self.signupView.activeBtn(flag: false)
        }
    }
    
    //获取图片验证码
    @objc func verifyClick(){
        AlamofireUtil.get(url: "/public/verifyCode",
        success: {(res,data) in
            self.signupView.verifyImg.image = UIImage(data: data)
            self.verifySign = res.allHeaderFields[AnyHashable("verifysign")] as? String
        },
        failure: {
        })
    }
    
    //校验图片验证码4位，获取短信验证码
    @objc func inputVerify(){
        if((signupView.verify.text ?? "").count==4){
            self.phoneCodeClick()
        }else if((signupView.verify.text ?? "").count > 4){ //超出部分截取
            signupView.verify.text = signupView.verify.text?.id_subString(from: 0, offSet: 4)
        }
    }
    
    //获取短信验证码
    @objc func phoneCodeClick(){
        CountDown.countDown(btn: signupView.phoneCodeBtn, phone: signupView.phone.text!,
                          verify: signupView.verify.text!, verifySign: self.verifySign!, type: 0,
        success: { (data) in
            if(data != "warning"){
                self.phoneSign = data
            }
            self.signupView.phoneCodeShow()
            //验证码输入结束（下一步）
            self.signupView.phoneCode.inputFinish = { data in
                self.step = 4
                self.signupView.activeBtn(flag: true)
            }
        })
    }
    
    //注册方法
    func signup(){
        print(self.openId)
        if(signupView.password.text!.count < 6){
            IDToast.id_show(msg: "密码至少为6位", success:.fail)
            return
        }
        if(signupView.password.text! != signupView.rePassword.text!){
            IDToast.id_show(msg: "密码不一致", success:.fail)
            return
        }
        IDLoading.id_showWithWait()
        AlamofireUtil.post(url: "/user/autho/public/register",
        param: [
            "phone" : signupView.phone.text!,
            "password" : signupView.password.text!,
            "phoneCode" : signupView.phoneCode.text!,
            "phoneSign" : self.phoneSign!,
            "parentId" : (self.parentId != "") ? self.parentId! : "1015",
            "openId" : self.openId ?? "",
            "headImg" : self.avatar ?? "",
            "nickName" : self.nickname ?? ""
        ],
        success: {(res, data) in
            print("data::::",data)
            IDLoading.id_dismissWait()
            IDToast.id_show(msg: "注册成功", success:.success)
            self.navigationController?.pushViewController(LoginCommonViewController(), animated: true)
        },
        error: {
        },
        failure: {
        })
    }
    
}
