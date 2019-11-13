//
//  nicknameView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/18.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class NicknameView: ViewController {
    let input = IDTextField()
    override func viewDidLoad() {
        let navView = customNav(titleStr: "修改昵称", titleColor: kMainTextColor)
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
        
        // 输入框
        let inputBox = UIView()
        inputBox.backgroundColor = .white
        inputBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.paddingLeft = 15
            layout.paddingRight = 15
            layout.marginTop = 10
        }
        body.addSubview(inputBox)
        input.text = UserDefaults.getInfo()["nickName"] as! String
        input.maxLength = 8
        input.clearButtonMode = .whileEditing
        input.font = FontSize(14)
        input.placeholder = "请输入昵称"
        input.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 30)
            layout.height = YGValue(46)
        }
        inputBox.addSubview(input)
        
        // -------- 提交按钮 --------
        let submitBtn = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.8, height: 40))
        submitBtn.addTarget(self, action: #selector(submit), for: .touchUpInside)
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
        body.addSubview(submitBtn)
        
        body.yoga.applyLayout(preservingOrigin: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func submit (_ btn: UIButton) {
        let nicknameValue : String = input.text!
        if nicknameValue == "" {
            IDToast.id_show(msg: "昵称不能为空", success: .fail)
            return
        }
        AlamofireUtil.post(url:"/user/info/updateNickName", param: ["nickName":nicknameValue],
        success:{(res, data) in
            var info : [String : Any] = UserDefaults.getInfo()
            info["nickName"] = nicknameValue
            UserDefaults.setInfo(value: info as! [String : String])
            IDToast.id_show(msg: "修改成功", success: .success)
            self.navigationController?.popViewController(animated: true)
        },
        error:{
                            
        },
        failure:{
                            
        })
    }
    
}
