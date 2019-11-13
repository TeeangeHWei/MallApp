//
//  passwordView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/19.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class PasswordView: ViewController {
    
    private var old:IDTextField!
    private var new:IDTextField!
    private var reNew:IDTextField!
    
    override func viewDidLoad() {
        let navView = customNav(titleStr: "修改密码", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - headerHeight))
        body.backgroundColor = kBGGrayColor
        body.addBorder(side: .top, thickness: 1, color: klineColor)
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - headerHeight)
            layout.paddingTop = 1
        }
        self.view.addSubview(body)
        // 表单列表
        let formList = UIView()
        formList.backgroundColor = .white
        formList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.marginTop = 10
        }
        body.addSubview(formList)
        // 手机号码
        let phoneNum : String = UserDefaults.getInfo()["phone"] as! String
        let hiddenNum :String = phoneNum.id_subString(from: 0, offSet: 3)+"****"+phoneNum.id_subString(from: 7, offSet: 11)
        let phone = formItem(isInput: false, leftS: "手机号码", centerS: hiddenNum, isValue: true, inputType: 0)
        formList.addSubview(phone)
        // 旧密码
        let oldPassword = formItem(isInput: true, leftS: "旧密码", centerS: "请输入旧密码（若无，可不填）", isValue: false, inputType: 1)
        formList.addSubview(oldPassword)
        // 新密码
        let newPassword = formItem(isInput: true, leftS: "新密码", centerS: "请输入新密码", isValue: false, inputType: 2)
        formList.addSubview(newPassword)
        // 重复新密码
        let againPassword = formItem(isInput: true, leftS: "重复新密码", centerS: "请确认您的新密码", isValue: false, inputType: 3)
        formList.addSubview(againPassword)
        
        // -------- 提交按钮 --------
        let submitBtn = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.8, height: 40))
        submitBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        submitBtn.setTitle("确认修改", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.titleLabel?.font = FontSize(14)
        submitBtn.layer.cornerRadius = 3
        submitBtn.layer.masksToBounds = true
        submitBtn.layer.shadowColor = kLowOrangeColor.cgColor
        submitBtn.layer.shadowOpacity = 0.5
        submitBtn.layer.shadowRadius = 3
        submitBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.8)
            layout.height = 40
            layout.marginTop = 20
            layout.marginLeft = YGValue(kScreenW * 0.1)
        }
        submitBtn.addTarget(self, action: #selector(updatePassword), for: .touchUpInside)
        body.addSubview(submitBtn)
        
        body.yoga.applyLayout(preservingOrigin: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // 表单单项
    func formItem (isInput: Bool, leftS: String, centerS: String, isValue: Bool, inputType: Int) -> UIView {
        let formItem = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 50))
        formItem.addBorder(side: .bottom, thickness: 1, color: klineColor)
        formItem.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(50)
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        let itemWidth = kScreenW - 30
        let key = UILabel()
        key.font = FontSize(14)
        key.text = leftS
        key.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(itemWidth * 0.25)
        }
        formItem.addSubview(key)
        if isInput {
            let center = IDTextField()
            center.clearButtonMode = .whileEditing
            center.isSecureTextEntry = true
            center.font = FontSize(14)
            if isValue {
                center.text = centerS
            } else {
                center.placeholder = centerS
            }
            center.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(itemWidth * 0.75)
            }
            formItem.addSubview(center)
            //数据赋值
            if inputType == 1{
                old = center
            }else if inputType == 2{
                new = center
            }else if inputType == 3{
                reNew = center
            }
        } else {
            let center = UILabel()
            center.text = centerS
            center.font = FontSize(14)
            center.textColor = kLowGrayColor
            center.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(itemWidth * 0.75)
            }
            formItem.addSubview(center)
        }
        return formItem
    }
    
    @objc func updatePassword() {
        if(old.text! == "" || new.text! == "" || reNew.text! == ""){
            IDToast.id_show(msg: "请填写完整信息", success: .fail)
            return
        }
        if((new.text ?? "").count < 6){
            IDToast.id_show(msg: "密码至少位6位", success: .fail)
            return
        }
        if(new.text! != reNew.text!){
            IDToast.id_show(msg: "密码不一致", success: .fail)
            return
        }
        AlamofireUtil.post(url: "/user/autho/setPassword", param: ["oldPassword":old.text!,"newPassword":new.text!],
        success: { (res,data) in
            IDToast.id_show(msg: "修改成功", success: .success)
            UserDefaults.removeAutho()
            self.navigationController?.pushViewController(LoginCommonViewController(), animated: true)
        },
        error: {
        },
        failure:{
        })
    }
}
