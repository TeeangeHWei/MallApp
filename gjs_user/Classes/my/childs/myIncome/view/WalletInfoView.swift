//
//  WalletInfoView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/23.
//  Copyright © 2019 大杉网络. All rights reserved.
//


@available(iOS 11.0, *)
class WalletInfoView: UIView {

    let balanceNum = UILabel()
    var moneyList = [UILabel]() // 0:累计收入 1:已提现 2:未结算
    var navC : UINavigationController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureLayout { (layout) in
            layout.isEnabled = true
        }
        // --------余额--------
        let balance = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 120))
        balance.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        balance.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.justifyContent = .center
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(120)
        }
        self.addSubview(balance)
        
        balanceNum.text = "¥0"
        balanceNum.font = FontSize(24)
        balanceNum.textColor = .white
        balanceNum.textAlignment = .center
        balanceNum.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(120)
        }
        balance.addSubview(balanceNum)
        let balanceExplain = UILabel()
        balanceExplain.text = "账户余额（元）"
        balanceExplain.font = FontSize(14)
        balanceExplain.textColor = .white
        balanceExplain.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginTop = 8
            layout.marginBottom = 10
        }
        balance.addSubview(balanceExplain)
        let balanceBtns = UIView()
        balanceBtns.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .center
            layout.alignItems = .center
        }
        balance.addSubview(balanceBtns)
        let withdrawBtn = UIButton()
        withdrawBtn.addTarget(self, action: #selector(toWithdraw), for: .touchUpInside)
        withdrawBtn.setTitle("提现", for: .normal)
        withdrawBtn.backgroundColor = .white
        withdrawBtn.setTitleColor(kLowOrangeColor, for: .normal)
        withdrawBtn.titleLabel?.font = FontSize(14)
        withdrawBtn.layer.cornerRadius = 15
        withdrawBtn.layer.masksToBounds = true
        withdrawBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.25)
            layout.height = 30
            layout.marginRight = 10
        }
        balanceBtns.addSubview(withdrawBtn)
        let billBtn = UIButton()
        billBtn.addTarget(self, action: #selector(toBill), for: .touchUpInside)
        billBtn.setTitle("账单详情", for: .normal)
        billBtn.backgroundColor = .clear
        billBtn.setTitleColor(.white, for: .normal)
        billBtn.titleLabel?.font = FontSize(14)
        billBtn.layer.cornerRadius = 15
        billBtn.layer.borderWidth = 1
        billBtn.layer.borderColor = UIColor.white.cgColor
        billBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.25)
            layout.height = 30
        }
        balanceBtns.addSubview(billBtn)
        
        // 累计收入等
        let SecondaryDataList = UIView()
        SecondaryDataList.backgroundColor = .white
        SecondaryDataList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = 80
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        self.addSubview(SecondaryDataList)
        for index in 1...5 {
            if index == 2 || index == 4 {
                // 间隔线
                let borderLine = UIView()
                borderLine.backgroundColor = klineColor
                borderLine.configureLayout { (layout) in
                    layout.isEnabled = true
                    layout.width = 1
                    layout.height = 40
                }
                SecondaryDataList.addSubview(borderLine)
            } else {
                // 单个数据项
                let SecondaryDataItem = UIView()
                SecondaryDataItem.configureLayout { (layout) in
                    layout.isEnabled = true
                    layout.width = YGValue((kScreenW - 2)/3)
                    layout.height = 60
                    layout.alignItems = .center
                    layout.justifyContent = .center
                }
                SecondaryDataList.addSubview(SecondaryDataItem)
                // 标题
                let itemTitle = UILabel()
                itemTitle.font = FontSize(14)
                itemTitle.textColor = kMainTextColor
                itemTitle.textAlignment = .center
                if index == 1 {
                    itemTitle.text = "累计收入"
                } else if index == 3 {
                    itemTitle.text = "已提现"
                } else if index == 5 {
                    itemTitle.text = "未结算"
                }
                itemTitle.configureLayout { (layout) in
                    layout.isEnabled = true
                    layout.width = YGValue((kScreenW - 2)/3)
                    layout.marginBottom = 6
                }
                SecondaryDataItem.addSubview(itemTitle)
                // 金额
                let itemMoney = UILabel()
                itemMoney.font = FontSize(16)
                itemMoney.textColor = kLowOrangeColor
                itemMoney.textAlignment = .center
                itemMoney.text = "¥ 0.0"
                itemMoney.configureLayout { (layout) in
                    layout.isEnabled = true
                    layout.width = YGValue((kScreenW - 2)/3)
                }
                SecondaryDataItem.addSubview(itemMoney)
                moneyList.append(itemMoney)
                
            }
        }
        
        self.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 跳转提现页面
    @objc func toWithdraw(btn: UIButton) {
        navC!.pushViewController(WithdrawView(), animated: true)
    }
    // 跳转账单详情
    @objc func toBill(btn: UIButton) {
        navC!.pushViewController(billView(), animated: true)
    }

}
