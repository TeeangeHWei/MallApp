//
//  withdrawView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/16.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class WithdrawView: ViewController, UIScrollViewDelegate {
    private var allHeight = 0
    
    //支付宝账号
    private let item2Center = UILabel()
    //真实姓名
    private let item3Center = UILabel()
    //可提现余额
    private var item5Left:UILabel!
    private var balance:Float! = 0.00
    //提现金额
    private let item4Center = IDTextField()
    
    override func viewDidLoad() {
        //是否为提现日
        isDay()
        
        let navView = customNav(titleStr: "提现", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: 0))
        body.backgroundColor = kBGGrayColor
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH)
            layout.paddingTop = 10
        }
        body.addBorder(side: .top, thickness: 1, color: klineColor)
        self.view.addSubview(body)
        
        // -------- 表单 ---------
        let formList = UIView()
        formList.backgroundColor = .white
        formList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
        }
        body.addSubview(formList)
        
        let itemWidth = kScreenW - 20
        // 提现方式
        let formItem1 = setFormItem()
        formList.addSubview(formItem1)
        let item1Left = UILabel()
        item1Left.text = "提现方式"
        item1Left.font = FontSize(14)
        item1Left.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(itemWidth * 0.75)
        }
        formItem1.addSubview(item1Left)
        let item1Right = UIImageView(image: UIImage(named: "alipay"))
        item1Right.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = YGValue(24)
            layout.width = YGValue(80)
        }
        formItem1.addSubview(item1Right)
        // 账号
        let formItem2 = setFormItem()
        formList.addSubview(formItem2)
        let item2Left = UILabel()
        item2Left.text = "到账支付宝"
        item2Left.font = FontSize(14)
        item2Left.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(itemWidth * 0.25)
        }
        formItem2.addSubview(item2Left)
        item2Center.text = UserDefaults.getInfo()["alipayAccount"] as? String
        item2Center.font = FontSize(14)
        item2Center.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(itemWidth * 0.5)
        }
        formItem2.addSubview(item2Center)
        let item2Right = UIView()
        item2Right.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .flexEnd
            layout.width = YGValue(itemWidth * 0.25)
        }
        formItem2.addSubview(item2Right)
        let upload = UIButton()
        upload.setTitle("修改", for: .normal)
        upload.setTitleColor(kLowOrangeColor, for: .normal)
        upload.titleLabel?.font = FontSize(14)
        upload.layer.borderWidth = 1
        upload.layer.borderColor = kLowOrangeColor.cgColor
        upload.layer.cornerRadius = 12
        upload.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 24
            layout.width = 60
        }
        upload.addTarget(self, action: #selector(toAlipay), for: .touchUpInside)
        item2Right.addSubview(upload)
        // 真实姓名
        let formItem3 = setFormItem()
        formList.addSubview(formItem3)
        let item3Left = UILabel()
        item3Left.text = "真实姓名"
        item3Left.font = FontSize(14)
        item3Left.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(itemWidth * 0.25)
        }
        formItem3.addSubview(item3Left)
        
        item3Center.text = UserDefaults.getInfo()["alipayRealname"] as? String
        item3Center.font = FontSize(14)
        item3Center.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(itemWidth * 0.75)
        }
        formItem3.addSubview(item3Center)
        // 提现金额
        let formItem4 = setFormItem()
        formList.addSubview(formItem4)
        let item4Left = UILabel()
        item4Left.text = "提现金额"
        item4Left.font = FontSize(14)
        item4Left.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(itemWidth * 0.25)
        }
        formItem4.addSubview(item4Left)
        
        item4Center.placeholder = "请输入提现金额"
        item4Center.font = FontSize(14)
        item4Center.onlyNumberAndPoint = true
        item4Center.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(itemWidth * 0.5)
        }
        formItem4.addSubview(item4Center)
        let item4Right = UIView()
        item4Right.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .flexEnd
            layout.width = YGValue(itemWidth * 0.25)
        }
        formItem4.addSubview(item4Right)
        let allMoney = UIButton()
        allMoney.setTitle("全部提现", for: .normal)
        allMoney.setTitleColor(colorwithRGBA(0, 172, 252, 1), for: .normal)
        allMoney.titleLabel?.font = FontSize(14)
        allMoney.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 24
            layout.width = 100
        }
        allMoney.addTarget(self, action: #selector(setAllMoney), for: .touchUpInside)
        item4Right.addSubview(allMoney)
        // 可用余额
        let formItem5 = setFormItem()
        formList.addSubview(formItem5)
        
        item5Left = UILabel()
        item5Left.text = "可用余额：¥ 0.00"
        loading()
        item5Left.font = FontSize(14)
        item5Left.textColor = kLowGrayColor
        item5Left.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(itemWidth * 0.5)
        }
        formItem5.addSubview(item5Left)
        let item5Right = UILabel()
        item5Right.text = "最低提现金额为1元"
        item5Right.font = FontSize(14)
        item5Right.textColor = kLowGrayColor
        item5Right.textAlignment = .right
        item5Right.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(itemWidth * 0.5)
        }
        formItem5.addSubview(item5Right)
        
        // -------- 提示 --------
        let cue = UILabel()
        cue.text = "*每月25号后可提现上个月内确认收货的订单收益"
        cue.font = FontSize(12)
        cue.textColor = kLowOrangeColor
        cue.configureLayout { (layout) in
            layout.isEnabled = true
            layout.padding = 10
            layout.marginLeft = 10
        }
        body.addSubview(cue)
        
        // -------- 提交按钮 --------
        let submitBtn = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.8, height: 40))
        submitBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        submitBtn.setTitle("提交申请", for: .normal)
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
            layout.marginLeft = YGValue(kScreenW * 0.1)
        }
        submitBtn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        body.addSubview(submitBtn)
        
        // -------- 收益明细 --------
        let flow = UIButton()
        flow.setTitle("收益明细", for: .normal)
        flow.addTarget(self, action: #selector(toBill), for: .touchUpInside)
        flow.setTitleColor(colorwithRGBA(0, 172, 252, 1), for: .normal)
        flow.titleLabel?.font = FontSize(14)
        flow.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.4)
            layout.marginLeft = YGValue(kScreenW * 0.3)
            layout.marginTop = 20
        }
        body.addSubview(flow)
        
        body.delegate = self
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight + 80), right: CGFloat(0))
        body.yoga.applyLayout(preservingOrigin: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // 表单单项容器
    func setFormItem () -> UIView {
        let formItem = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 46))
        formItem.addBorder(side: .bottom, thickness: 1, color: klineColor)
        formItem.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(46)
            layout.paddingLeft = 10
            layout.paddingRight = 10
        }
        return formItem
    }
    // 前往绑定支付宝
    @objc func toAlipay(){
        navigationController?.pushViewController(AlipayView(), animated: true)
    }
    // 前往收益明细
    @objc func toBill (btn: UIButton) {
        navigationController?.pushViewController(billView(), animated: true)
    }
    // 全部提现
    @objc func setAllMoney (btn: UIButton) {
        item4Center.text = String(self.balance)
    }
    
    //加载数据
    func loading(){
        AlamofireUtil.post(url: "/user/wallet/myEarnings", param: [:],
        success: { (res, data) in
            self.item5Left.text = "可提现余额：¥ " + Commons.strToDoubleStr(str: data["balance"].description)
            self.balance = Float(data["balance"].description)
        },
        error: {},
        failure: {})
    }
    
    @objc func submit(){
        if(!Commons.isMoney(money:item4Center.text!)){
            IDToast.id_show(msg: "金额输入有误",success:.fail)
            return
        }
        if((Float(item4Center.text ?? "0") ?? 0) < 1){
            IDToast.id_show(msg: "提现金额最少为1元",success:.fail)
            return
        }
        if((Float(item4Center.text ?? "0") ?? 0) > balance){
            IDToast.id_show(msg: "余额不足",success:.fail)
            return
        }
        IDDialog.id_show(title: "", msg: "是否确定提现？", leftActionTitle: "取消", rightActionTitle: "确定", leftHandler: {
            
        }) {
            AlamofireUtil.post(url: "/user/withdrawal/withdrawDeposit",
            param: [
                "type" : "2",
                "amount" : self.item4Center.text!
            ],
            success: { (res,data) in
                IDToast.id_show(msg: "提现申请成功",success:.fail)
                self.navigationController?.popViewController(animated: true)
            },
            error: {},
            failure: {})
        }
    }
    
    //判断是否为提现日
    func isDay(){
        AlamofireUtil.post(url: "/user/withdrawal/isDays", param: [:],
        success: { (res, data) in
        },
        error: {
            self.navigationController?.popViewController(animated: true)
        },
        failure: {})
    }
}
