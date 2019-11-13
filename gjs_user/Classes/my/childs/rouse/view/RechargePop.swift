//
//  RechargePop.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/25.
//  Copyright © 2019 大杉网络. All rights reserved.
//


class RechargePop: UIView {
    
    let moneyInput = IDTextField()
    let wayText = UILabel()
    var isLoading = false
    var walletInfo:WalletInfo = WalletInfo()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.tag = 106
        self.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = YGValue(kScreenH)
            layout.width = YGValue(kScreenW)
            layout.position = .relative
        }
        let shade = UIView()
        shade.backgroundColor = colorwithRGBA(0, 0, 0, 0.5)
        shade.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(close(sender:)))
        shade.addGestureRecognizer(tap)
        shade.configureLayout { (layout) in
            layout.isEnabled = true
            layout.top = 0
            layout.left = 0
            layout.height = YGValue(kScreenH)
            layout.width = YGValue(kScreenW)
            layout.position = .absolute
        }
        self.addSubview(shade)
        let rechargeForm = UIView()
        rechargeForm.backgroundColor = .white
        rechargeForm.configureLayout { (layout) in
            layout.isEnabled = true
            layout.position = .absolute
            layout.bottom = 0
            layout.left = 0
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.padding = 15
        }
        self.addSubview(rechargeForm)
        // 标题
        let title = UILabel()
        title.text = "充值(元)"
        title.font = FontSize(16)
        title.textColor = kMainTextColor
        title.textAlignment = .center
        title.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.marginBottom = 10
        }
        rechargeForm.addSubview(title)
        // 输入框
        moneyInput.onlyNumberAndPoint = true
        moneyInput.addTarget(self, action: #selector(keyOut), for: .editingChanged)
        moneyInput.font = FontSize(14)
        moneyInput.textAlignment = .center
        moneyInput.placeholder = "请输入金额"
        moneyInput.layer.borderColor = klineColor.cgColor
        moneyInput.layer.borderWidth = 1
        moneyInput.layer.cornerRadius = 5
        moneyInput.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.8)
            layout.height = 40
        }
        rechargeForm.addSubview(moneyInput)
        // 注释
        let notes = UILabel()
        notes.text = "*注：一次充值最低10元，最高50000元"
        notes.textColor = kHighOrangeColor
        notes.font = FontSize(12)
        notes.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.8)
            layout.marginTop = 10
        }
        rechargeForm.addSubview(notes)
        // 支付方式标题
        let payWayTitle = UILabel()
        payWayTitle.text = "支付方式"
        payWayTitle.font = FontSize(16)
        payWayTitle.textColor = kMainTextColor
        payWayTitle.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.8)
            layout.marginTop = 15
        }
        rechargeForm.addSubview(payWayTitle)
        // 支付方式列表
        let payWayList = UIView()
        payWayList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.8)
        }
        rechargeForm.addSubview(payWayList)
        // 余额支付
        let payForBalance = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.8, height: 50))
        payForBalance.addBorder(side: .bottom, thickness: 1, color: klineColor)
        payForBalance.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.8)
            layout.height = 50
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
        }
        payWayList.addSubview(payForBalance)
        let wayLeft = UIView()
        wayLeft.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.7)
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        payForBalance.addSubview(wayLeft)
        let wayIcon = UIImageView(image: UIImage(named: "balance"))
        wayIcon.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 24
            layout.height = 24
            layout.marginRight = 8
        }
        wayLeft.addSubview(wayIcon)
        wayText.text = "赶紧省可用余额（\(walletInfo.wallet!.balance!)元）"
        wayText.font = FontSize(14)
        wayText.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.7 - 32)
        }
        wayLeft.addSubview(wayText)
        let checkIcon = UIImageView(image: UIImage(named: "rouse-select"))
        checkIcon.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 14
            layout.height = 14
        }
        payForBalance.addSubview(checkIcon)
        // 提示
//        let reminder = UILabel()
//        reminder.text = "提示：一次充值最低100元，支付宝充值代扣手续费1%"
//        reminder.font = FontSize(12)
//        reminder.textColor = kLowGrayColor
//        reminder.configureLayout { (layout) in
//            layout.isEnabled = true
//            layout.width = YGValue(kScreenW * 0.8)
//            layout.marginTop = 10
//        }
//        rechargeForm.addSubview(reminder)
        // 按钮组
        let btnList = UIView()
        btnList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .center
            layout.width = YGValue(kScreenW * 0.8)
            layout.marginTop = 10
            layout.paddingBottom = 10
        }
        rechargeForm.addSubview(btnList)
        let cancelBtn = UIButton()
        cancelBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        cancelBtn.backgroundColor = colorwithRGBA(150, 150, 150, 1)
        cancelBtn.setTitleColor(.white, for: .normal)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.titleLabel?.font = FontSize(14)
        cancelBtn.layer.cornerRadius = 18
        cancelBtn.layer.masksToBounds = true
        cancelBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(100)
            layout.height = 36
            layout.marginRight = 15
        }
        btnList.addSubview(cancelBtn)
        let confirmBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
        confirmBtn.addTarget(self, action: #selector(recharge), for: .touchUpInside)
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.setTitleColor(.white, for: .normal)
        confirmBtn.titleLabel?.font = FontSize(14)
        confirmBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        confirmBtn.layer.cornerRadius = 18
        confirmBtn.layer.masksToBounds = true
        confirmBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(100)
            layout.height = 36
        }
        btnList.addSubview(confirmBtn)
        
        
        
        self.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func close (sender : UITapGestureRecognizer) {
        self.window?.viewWithTag(106)?.removeFromSuperview()
    }
    
    @objc func keyOut (textField: UITextField) {
        let balanceStr = walletInfo.wallet!.balance!
        let balance = Commons.strToDou(balanceStr)
        var money = 0.0
        if let text = textField.text {
            money = Commons.strToDou(text)
        }
        if money > balance {
            IDToast.id_show(msg: "充值金额不得大于余额", success: .fail)
            moneyInput.text = ""
        }
    }
    
    @objc func recharge () {
        if isLoading {
            return
        }
        isLoading = true
        var money = 0.0
        var moneyStr = 0
        if let text = moneyInput.text {
            money = Commons.strToDou(text)
        }
        if money <= 0.0 {
            IDToast.id_show(msg: "充值金额不得小于0", success: .fail)
            return
        } else {
            moneyStr = Int(money * 100)
        }
        IDLoading.id_showWithWait()
        AlamofireUtil.post(url: "/user/smsTemplate/recharge", param: [
            "money" : moneyStr
        ],
        success:{(res, data) in
            IDToast.id_show(msg: "充值成功", success: .success)
            self.getWallet()
            IDLoading.id_dismissWait()
            self.isLoading = false
        },
        error:{
            IDLoading.id_dismissWait()
            self.isLoading = false
        },
        failure:{
            IDLoading.id_dismissWait()
            self.isLoading = false
        })
    }
    
    // 获取钱包信息
    func getWallet () {
        AlamofireUtil.post(url: "/user/wallet/getWalletInfo",
        param: [:],
        success: { (res,data) in
            let walletInfo = WalletInfo.deserialize(from: data.description)!
            self.wayText.text = "赶紧省可用余额（\(walletInfo.wallet!.balance!)元）"
        },
        error: {},
        failure: {})
    }
    
}
