//
//  ToRouseController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/1.
//  Copyright © 2019 大杉网络. All rights reserved.
//

class ToRouseController: ViewController {

    let smsBalanceView = SmsBalance(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 60))
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        
        view.backgroundColor = kBGGrayColor
        view.addSubview(smsBalanceView)
        let smsTemplate = SmsTemplate(frame: CGRect(x: 0, y: 60, width: kScreenW, height: 450), nav: navigationController)
        view.addSubview(smsTemplate)
        let smsFooter = SmsFooter(frame: CGRect(x: 0, y: kScreenH - headerHeight - 60, width: kScreenW, height: 60), nav: navigationController)
        view.addSubview(smsFooter)
        if let smsData = smsData {
            self.smsBalanceView.smsBalance.text = "短信余额：\(smsData.smsBalance!)"
            self.smsBalanceView.smsCost.text = "短信收费标准：\(smsData.smsCost!)元/条"
        } else {
            self.smsBalanceView.smsBalance.text = "短信余额：0.0"
            self.smsBalanceView.smsCost.text = "短信收费标准：0.0元/条"
        }
    }
    
    func setNavigation () {
        setNav(titleStr: "唤醒会员", titleColor: kMainTextColor, navItem: navigationItem, navController: navigationController)
        let mesagebtn = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        mesagebtn.addTarget(self, action: #selector(toFlow), for: .touchUpInside)
        mesagebtn.setTitle("余额明细", for: .normal)
        mesagebtn.setTitleColor(kMainTextColor, for: .normal)
        mesagebtn.titleLabel?.font = FontSize(14)
        let mesagebtn1 = UIBarButtonItem(customView: mesagebtn)
//        mesagebtn.addTarget(self, action: #selector(toNews), for: .touchUpInside)
        navigationItem.rightBarButtonItem = mesagebtn1
    }
    
    @objc func toFlow (_ btn: UIButton) {
        navigationController?.pushViewController(FlowController(), animated: true)
    }
    
    

}
