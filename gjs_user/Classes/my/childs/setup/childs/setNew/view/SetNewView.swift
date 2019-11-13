//
//  setNewView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/20.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class SetNewView: ViewController {
    private let switchBtn = UISwitch()
    // 打开APP系统设置页
    private let urlObj = URL(string:UIApplication.openSettingsURLString)

    let incomeBtn = UISwitch()
    let fansBtn = UISwitch()
    
    var newfansNotify = false
    var profitNotify = false
    
    @IBAction func swtichNotiTap(_ sender: UISwitch) {
        // 前往设置
        if #available(iOS 10, *) {
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: { (success) in })
        } else {
            UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
        }
//        UIApplication.shared.open(urlObj! as URL, options: [ : ]) { (result) in
//            // 如果判断是否返回成功
//            if result {
//                let notiSetting = UIApplication.shared.currentUserNotificationSettings
//                if notiSetting?.types == UIUserNotificationType.init(rawValue: 0) {
//                    self.switchBtn.isOn = false
//                    self.switchBtn.isEnabled = true
//                } else {
//                    self.switchBtn.isOn = true
//                    self.switchBtn.isEnabled = false
//                }
//
//
//            }
//        }
    }
    override func viewDidLoad() {
        
        let navView = customNav(titleStr: "消息提醒", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        
        let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - headerHeight))
        body.backgroundColor = kBGGrayColor
        body.addBorder(side: .top, thickness: 1, color: klineColor)
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - headerHeight)
            layout.paddingTop = 1
            layout.position = .relative
        }
        self.view.addSubview(body)
        
        // 提示
        let cue = UILabel()
        cue.text = "    如需修改通知，您可以在系统设置重新修改"
        cue.textColor = kLowOrangeColor
        cue.backgroundColor = kBGRedColor
        cue.font = FontSize(12)
        cue.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(30)
        }
        body.addSubview(cue)
        
        // 接收消息通知
        let allSwitch = UIView()
        allSwitch.backgroundColor = .white
        allSwitch.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(50)
            layout.paddingLeft = 15
            layout.paddingRight = 15
            layout.marginBottom = 15
        }
        body.addSubview(allSwitch)
        let allLeft = UILabel()
        allLeft.text = "接收消息通知"
        allLeft.font = FontSize(14)
        allLeft.configureLayout { (layout) in
            layout.isEnabled = true
        }
        allSwitch.addSubview(allLeft)
        switchBtn.onTintColor = kLowOrangeColor
        switchBtn.addTarget(self, action: #selector(allSwitchChange), for: .valueChanged)
        switchBtn.configureLayout { (layout) in
            layout.isEnabled = true
        }
        allSwitch.addSubview(switchBtn)
        
        // 收益消息
        let incomeSwitch = UIView()
        incomeSwitch.backgroundColor = .white
        incomeSwitch.addBorder(side: .bottom, thickness: 1, color: klineColor)
        incomeSwitch.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(50)
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        body.addSubview(incomeSwitch)
        let incomeLeft = UILabel()
        incomeLeft.text = "收益通知"
        incomeLeft.font = FontSize(14)
        incomeLeft.configureLayout { (layout) in
            layout.isEnabled = true
        }
        incomeSwitch.addSubview(incomeLeft)
        incomeBtn.onTintColor = kLowOrangeColor
        incomeBtn.addTarget(self, action: #selector(incomeChange), for: .valueChanged)
        incomeBtn.configureLayout { (layout) in
            layout.isEnabled = true
        }
        incomeSwitch.addSubview(incomeBtn)
        // 收益消息
        let fansSwitch = UIView()
        fansSwitch.backgroundColor = .white
        fansSwitch.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(50)
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        body.addSubview(fansSwitch)
        let fansLeft = UILabel()
        fansLeft.text = "新粉丝提醒"
        fansLeft.font = FontSize(14)
        fansLeft.configureLayout { (layout) in
            layout.isEnabled = true
        }
        fansSwitch.addSubview(fansLeft)
        fansBtn.onTintColor = kLowOrangeColor
        fansBtn.addTarget(self, action: #selector(fansChange), for: .valueChanged)
        fansBtn.configureLayout { (layout) in
            layout.isEnabled = true
        }
        fansSwitch.addSubview(fansBtn)
        
        body.yoga.applyLayout(preservingOrigin: true)
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 判断是否已开启消息通知
        initNotifications()
        self.hideKeyboardWhenTappedAround()
    }
    
    // 判断是否开启了消息通知
    func initNotifications() {
        let notiSetting = UIApplication.shared.currentUserNotificationSettings
        if notiSetting?.types == UIUserNotificationType.init(rawValue: 0) {
            switchBtn.isOn = false
        } else {
            switchBtn.isOn = true
            switchBtn.isEnabled = false
        }
        
    }
    
    // 总开关改变
    @objc func allSwitchChange (sender: UISwitch) {
        IDDialog.id_show(title: "开启消息通知提醒", msg: "获取最新通知、收益、粉丝管理", leftActionTitle: "忽略", rightActionTitle: "去开启", leftHandler: {
            sender.isOn = false
        }) {
            self.swtichNotiTap(sender)
        }
    }
    
    // 收益开关点击事件
    @objc func incomeChange (sender: UISwitch) {
        if switchBtn.isOn == false {
            IDDialog.id_show(title: "开启消息通知提醒", msg: "获取最新通知、收益、粉丝管理", leftActionTitle: "忽略", rightActionTitle: "去开启", leftHandler: {
                sender.isOn = self.profitNotify
            }) {
                sender.isOn = self.profitNotify
                self.swtichNotiTap(sender)
            }
        } else {
            self.profitNotify = sender.isOn
            setMsgRemind()
        }
    }
    
    // 粉丝开关点击事件
    @objc func fansChange (sender: UISwitch) {
        if switchBtn.isOn == false {
            IDDialog.id_show(title: "开启消息通知提醒", msg: "获取最新通知、收益、粉丝管理", leftActionTitle: "忽略", rightActionTitle: "去开启", leftHandler: {
                sender.isOn = self.newfansNotify
            }) {
                sender.isOn = self.newfansNotify
                self.swtichNotiTap(sender)
            }
        } else {
            self.newfansNotify = sender.isOn
            setMsgRemind()
        }
    }
    
    // 获取开关设置
    func getData () {
        AlamofireUtil.post(url:"/user/notifySetup/msgRemind", param: [:],
        success:{(res,data) in
            if data["newfansNotify"].int! == 1 {
                self.newfansNotify = true
                self.fansBtn.isOn = true
            }
            if data["profitNotify"].int! == 1 {
                self.profitNotify = true
                self.incomeBtn.isOn = true
            }
        },
        error:{
            
        },
        failure:{
            
        })
    }
    
    // 消息收取设置
    func setMsgRemind () {
        print(self.profitNotify)
        print(self.newfansNotify)
        AlamofireUtil.post(url:"/user/notifySetup/setMsgRemind", param: [
            "profitNotify" : (self.profitNotify ? 1 : 0),
            "newfansNotify" : (self.newfansNotify ? 1 : 0)
        ],
        success:{(res,data) in
            IDToast.id_show(msg: "设置成功", success: .success)
        },
        error:{
            
        },
        failure:{
                            
        })
    }


}
