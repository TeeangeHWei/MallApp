//
//  loginCommonView.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/8/23.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class LoginCommonViewController: UIViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let leftBtn = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(toHome))
        leftBtn.tintColor = .white
        self.navigationItem.leftBarButtonItem = leftBtn;
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
    }

    @objc func toHome(){
        let delegate = UIApplication.shared.delegate
        delegate?.window??.rootViewController = TabBarViewController()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // 修改系统状态栏字颜色为白色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainView = UIView()
        mainView.frame = self.view.bounds
        mainView.backgroundColor = .white
        let bg = UIImageView(image: UIImage(named: "loginBg"))
        bg.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenW/1.53)
        bg.contentMode = .scaleAspectFill
        
        let logo = UIImageView(image: UIImage(named: "logo"))
        logo.frame = CGRect(x: kScreenW/2-45, y: kScreenW/1.53+80, width: 90, height: 90)
        
        
        let signupBox = UIView(frame: CGRect(x: kScreenW*0.08, y: kScreenW/1.53+210, width: kScreenW*0.84, height: 46))
        signupBox.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        signupBox.layer.masksToBounds = true
        signupBox.layer.cornerRadius = 24
        signupBox.tag = 0
        signupBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toView(sender:))))
        
        let signContent = UIView()
        let signImg = UIImageView(image: UIImage(named: "signup"))
        let signText = UILabel()
        
        signContent.addSubview(signImg)
        signContent.addSubview(signText)
        signupBox.addSubview(signContent)
        
        signContent.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(46)
        }
        signImg.contentMode = .scaleAspectFit
        signImg.snp.makeConstraints { (make) in
            make.width.equalTo(22)
            make.height.equalTo(22)
            make.top.equalTo(12)
            make.left.equalTo(0)
        }
        signText.text = "注册"
        signText.textColor = .white
        signText.font = BoldFontSize(20)
        signText.snp.makeConstraints { (make) in
            make.height.equalTo(46)
            make.left.equalTo(signImg.snp.right).offset(8)
            make.right.equalTo(0)
        }
        
        let phoneBox = UIView(frame: CGRect(x: kScreenW*0.08, y: kScreenW/1.53+280, width: kScreenW*0.42 - 8, height: 44))
        phoneBox.backgroundColor = kBGGrayColor
        phoneBox.layer.cornerRadius = 23
        phoneBox.layer.masksToBounds = true
        phoneBox.tag = 1
        phoneBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toView(sender:))))
        
        let phoneImg = UIImageView(image: UIImage(named: "login-phone"))
        let phoneText = UILabel()
        
        phoneBox.addSubview(phoneImg)
        phoneBox.addSubview(phoneText)
        
        phoneImg.layer.cornerRadius = 17
        phoneImg.layer.masksToBounds = true
        phoneImg.contentMode = .scaleAspectFit
        phoneImg.snp.makeConstraints { (make) in
            make.height.equalTo(32)
            make.width.equalTo(32)
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(6)
        }
        
        phoneText.text = "手机登录"
        phoneText.textColor = kGrayTextColor
        phoneText.font = FontSize(16)
        phoneText.snp.makeConstraints { (make) in
            make.left.equalTo(phoneImg.snp.right).offset(8)
            make.height.equalTo(44)
        }
        
        let wechatBox = UIView(frame: CGRect(x: kScreenW*0.5 + 8, y: kScreenW/1.53+280, width: kScreenW*0.42 - 8, height: 44))
        wechatBox.backgroundColor = kBGGrayColor
        wechatBox.layer.cornerRadius = 23
        wechatBox.layer.masksToBounds = true
        wechatBox.tag = 2
        wechatBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toView(sender:))))
        
        let wechatImg = UIImageView(image: UIImage(named: "login-wechat"))
        let wechatText = UILabel()
        
        wechatBox.addSubview(wechatImg)
        wechatBox.addSubview(wechatText)
        
        wechatImg.layer.cornerRadius = 17
        wechatImg.layer.masksToBounds = true
        wechatImg.contentMode = .scaleAspectFit
        wechatImg.snp.makeConstraints { (make) in
            make.height.equalTo(32)
            make.width.equalTo(32)
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(6)
        }
        
        wechatText.text = "微信登录"
        wechatText.textColor = kGrayTextColor
        wechatText.font = FontSize(16)
        wechatText.snp.makeConstraints { (make) in
            make.left.equalTo(wechatImg.snp.right).offset(8)
            make.height.equalTo(44)
        }
        
        let tip = UILabel()
        mainView.addSubview(tip)
        
        tip.text = "登录即代表您已同意《赶紧省隐私协议》"
        tip.font = FontSize(12)
        tip.textColor = kLowGrayColor
        tip.textAlignment = .center
        tip.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenW)
            make.bottom.equalTo(mainView.snp.bottom).offset(-20)
        }
        
        mainView.addSubview(bg)
        mainView.addSubview(logo)
        mainView.addSubview(signupBox)
        mainView.addSubview(phoneBox)
        if (UIApplication.shared.canOpenURL(URL(string: "wechat://")!)) {
            mainView.addSubview(wechatBox)
        }
        self.view.addSubview(mainView)
    }
    
    
    @objc func toView(sender:UITapGestureRecognizer){
        if sender.view?.tag == 0{
            navigationController?.pushViewController(SignupViewController(), animated: true)
        }else if sender.view?.tag == 1 {
            navigationController?.pushViewController(LoginViewController(), animated: true)
        }else {
            getUid()
        }
    }
    
    // 微信授权获取uid
    func getUid () {
        print("进入方法")
        ShareSDK.getUserInfo(.typeWechat) { (state, info, error) in
            switch state {
            case .success:
                self.wechatLogin((info?.uid)!, (info?.nickname)!, (info?.icon)!)
                break
            case .begin:
                print("开始授权")
                break
            case .fail:
                print("授权失败")
                break
            case .cancel:
                print("授权取消")
                break
            case .upload:
                print("上传")
                break
            }
        }
    }
    // 微信登录
    func wechatLogin (_ id : String, _ nickname : String, _ avatar : String) {
        IDLoading.id_showWithWait()
        AlamofireUtil.post(url:"/user/autho/public/weChatAutho", param: [
            "openId" : id
        ],
        success:{(res,data) in
            UserDefaults.setAuthoToken(value: data["token"].description)
            self.getInfo()
            IDLoading.id_dismissWait()
            IDToast.id_show(msg: "登录成功", success: .success)
            let vcCount = self.navigationController?.viewControllers.count
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[vcCount! - 2])!, animated: true)
        },
        error:{
            let vc = SignupViewController()
            vc.openId = id
            vc.nickname = nickname
            vc.avatar = avatar
            self.navigationController?.pushViewController(vc, animated: true)
        },
        failure:{
            
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
