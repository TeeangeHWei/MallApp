//
//  myIncomeView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/15.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
@available(iOS 11.0, *)
class MyIncomeView: UIViewController, UIScrollViewDelegate {
    private var allHeight = 0
    private var data:MyIncomeModel?
    
    let balanceNum = UILabel()
    var todayPay:UILabel = UILabel()
    var todayDeal:UILabel = UILabel()
    var todaySettle:UILabel = UILabel()
    
    var yesterdayPay:UILabel = UILabel()
    var yesterdayDeal:UILabel = UILabel()
    var yesterdaySettle:UILabel = UILabel()
    
    var thisMouthConsume:UILabel = UILabel()
    var lastMouthConsume:UILabel = UILabel()
    var lastMouthSettle:UILabel = UILabel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        title.text = "收益报表"
        title.textAlignment = .center
        title.textColor = .white
        navigationItem.titleView = title
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.apply(gradient: kGradientColors)
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLoad() {
        let body = UIScrollView()
        body.backgroundColor = kBGGrayColor
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH)
        }
        self.view.addSubview(body)
        
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
        body.addSubview(balance)
        allHeight += 120
        
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
        
        
        let dayArr = [ "下单笔数","成交预估收入","结算预估收入"]
        let mouthArr = ["本月消费预估收入","上月消费预估收入","上月消费结算预估收入"]
//        // -------- 今日预估收入 --------
        setEstimate(1, body, dayArr)
        // -------- 昨日预估收入 --------
        setEstimate(2, body, dayArr)
        // -------- 月预估收入 --------
        setEstimate(3, body, mouthArr)
        
        // -------- 规则说明 --------
        let rule = UIView()
        rule.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .flexEnd
        }
        body.addSubview(rule)
        let ruleBtn = UIButton()
        ruleBtn.setTitle("规则说明", for: .normal)
        ruleBtn.setTitleColor(kLowOrangeColor, for: .normal)
        ruleBtn.titleLabel?.font = FontSize(14)
        ruleBtn.tag = 4
        ruleBtn.addTarget(self, action: #selector(setAlert), for: .touchUpInside)
        ruleBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginRight = 15
        }
        rule.addSubview(ruleBtn)
        loadData()
        
        body.delegate = self
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight), right: CGFloat(0))
        body.yoga.applyLayout(preservingOrigin: true)
    }
    
    // 设置单个预估收入dom
    func setEstimate (_ date: Int, _ father: UIScrollView, _ numArr: [String]) {
        var title = "今日预估收入"
        if date == 1 {
            title = "今日预估收入"
        } else if date == 2 {
            title = "昨日预估收入"
        } else if date == 3 {
            title = "月预估收入"
        }
        let estimate = UIView()
        estimate.backgroundColor = .white
        estimate.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.paddingLeft = 15
            layout.paddingRight = 15
            layout.marginBottom = 15
        }
        father.addSubview(estimate)
        let estimateTitle = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW - 30, height: 36))
        estimateTitle.addBorder(side: .bottom, thickness: 1, color: klineColor)
        estimateTitle.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.height = 36
        }
        estimate.addSubview(estimateTitle)
        let titleLeft = UIView()
        titleLeft.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        estimateTitle.addSubview(titleLeft)
        let icon = UIImageView(image: UIImage(named: "myIncome-1"))
        icon.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 16
            layout.height = 16
            layout.marginRight = 5
        }
        titleLeft.addSubview(icon)
        let titleText = UILabel()
        titleText.text = title
        titleText.font = FontSize(14)
        titleText.configureLayout { (layout) in
            layout.isEnabled = true
        }
        titleLeft.addSubview(titleText)
        let titleRight = UIButton()
        titleRight.tag = date
        titleRight.addTarget(self, action: #selector(setAlert), for: .touchUpInside)
        titleRight.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        estimateTitle.addSubview(titleRight)
        let rightText = UILabel()
        rightText.text = "说明"
        rightText.font = FontSize(14)
        rightText.textColor = kLowGrayColor
        rightText.configureLayout { (layout) in
            layout.isEnabled = true
        }
        titleRight.addSubview(rightText)
        let arrow = UIImageView(image: UIImage(named: "arrow-gray"))
        arrow.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 14
            layout.width = 7
            layout.marginLeft = 5
        }
        titleRight.addSubview(arrow)
        // 预估收入数额
        let numList = UIView()
        numList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.paddingTop = 20
            layout.paddingBottom = 20
        }
        estimate.addSubview(numList)
        for (index,item) in numArr.enumerated() {
            let numItem = UIView()
            numItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.flexDirection = .column
                layout.alignItems = .center
                layout.width = YGValue((kScreenW - 30)/3)
            }
            numList.addSubview(numItem)
            let name = UILabel()
            name.text = item
            name.numberOfLines = 2
            name.font = FontSize(14)
            name.textAlignment = .center
            name.configureLayout { (layout) in
                layout.isEnabled = true
                layout.marginBottom = 15
                layout.width = YGValue((kScreenW - 30)/3 - 20)
            }
            numItem.addSubview(name)
            let num = UILabel()
            if date == 1{ //本日数据
                if index == 0{
                    todayPay.text = "0"
                    todayPay.font = FontSize(14)
                    todayPay.textColor = kLowOrangeColor
                    todayPay.textAlignment = .center
                    todayPay.configureLayout { (layout) in
                        layout.isEnabled = true
                        layout.width = YGValue(60)
                    }
                    numItem.addSubview(todayPay)
                }else if index == 1{
                    todayDeal.text = "¥0"
                    todayDeal.font = FontSize(14)
                    todayDeal.textColor = kLowOrangeColor
                    todayDeal.textAlignment = .center
                    todayDeal.configureLayout { (layout) in
                        layout.isEnabled = true
                        layout.width = YGValue(60)
                    }
                    numItem.addSubview(todayDeal)
                }else{
                    todaySettle.text = "¥0"
                    todaySettle.font = FontSize(14)
                    todaySettle.textColor = kLowOrangeColor
                    todaySettle.textAlignment = .center
                    todaySettle.configureLayout { (layout) in
                        layout.isEnabled = true
                        layout.width = YGValue(60)
                    }
                    numItem.addSubview(todaySettle)
                }
            }else if date == 2{ //昨日数据
                if index == 0{
                    yesterdayPay.text = "0"
                    yesterdayPay.font = FontSize(14)
                    yesterdayPay.textColor = kLowOrangeColor
                    yesterdayPay.textAlignment = .center
                    yesterdayPay.configureLayout { (layout) in
                        layout.isEnabled = true
                        layout.width = YGValue(60)
                    }
                    numItem.addSubview(yesterdayPay)
                }else if index == 1{
                    yesterdayDeal.text = "¥0"
                    yesterdayDeal.font = FontSize(14)
                    yesterdayDeal.textColor = kLowOrangeColor
                    yesterdayDeal.textAlignment = .center
                    yesterdayDeal.configureLayout { (layout) in
                        layout.isEnabled = true
                        layout.width = YGValue(60)
                    }
                    numItem.addSubview(yesterdayDeal)
                }else{
                    yesterdaySettle.text = "¥0"
                    yesterdaySettle.font = FontSize(14)
                    yesterdaySettle.textColor = kLowOrangeColor
                    yesterdaySettle.textAlignment = .center
                    yesterdaySettle.configureLayout { (layout) in
                        layout.isEnabled = true
                        layout.width = YGValue(60)
                    }
                    numItem.addSubview(yesterdaySettle)
                }
            }else{ //本月数据
                if index == 0{
                    thisMouthConsume.text = "¥0"
                    thisMouthConsume.font = FontSize(14)
                    thisMouthConsume.textColor = kLowOrangeColor
                    thisMouthConsume.textAlignment = .center
                    thisMouthConsume.configureLayout { (layout) in
                        layout.isEnabled = true
                        layout.width = YGValue(60)
                    }
                    numItem.addSubview(thisMouthConsume)
                }else if index == 1{
                    lastMouthConsume.text = "¥0"
                    lastMouthConsume.font = FontSize(14)
                    lastMouthConsume.textColor = kLowOrangeColor
                    lastMouthConsume.textAlignment = .center
                    lastMouthConsume.configureLayout { (layout) in
                        layout.isEnabled = true
                        layout.width = YGValue(60)
                    }
                    numItem.addSubview(lastMouthConsume)
                }else{
                    lastMouthSettle.text = "¥0"
                    lastMouthSettle.font = FontSize(14)
                    lastMouthSettle.textColor = kLowOrangeColor
                    lastMouthSettle.textAlignment = .center
                    lastMouthSettle.configureLayout { (layout) in
                        layout.isEnabled = true
                        layout.width = YGValue(60)
                    }
                    numItem.addSubview(lastMouthSettle)
                }
            }
            num.font = FontSize(14)
            num.textColor = kLowOrangeColor
            num.configureLayout { (layout) in
                layout.isEnabled = true
            }
            numItem.addSubview(num)
            if index < 2 {
                let line = UIView()
                line.backgroundColor = klineColor
                line.configureLayout { (layout) in
                    layout.isEnabled = true
                    layout.width = 1
                    layout.height = 30
                }
                numList.addSubview(line)
            }
        }
        allHeight += 162
    }
    // 设置弹窗
    @objc func setAlert (btn: UIButton) {
        let index = btn.tag
        // 日预估说明
        let dayArr = [
            [
                "key": "1.付款笔数：",
                "value": "今/昨当日付款笔数"
            ],
            [
                "key": "2.成交预估收入：",
                "value": "今/昨订单还没有确认收货到佣金"
            ],
            [
                "key": "3.结算预估收入：",
                "value": "今/昨确认收货的订单包括上月的订单在今/昨确定"
            ]
        ]
        let mouthArr = [
            [
                "key": "1.月消费预估收入：",
                "value": "本月/上月卖出去的所有佣金"
            ],
            [
                "key": "2.本月消费结算预估收入：",
                "value": "在本月内确认收货的订单，包括上月的订单在本月内确认的"
            ],
            [
                "key": "3.上月消费结算预估收入：",
                "value": "本月25号可提现金额。（如果该数据为0，即本月不可提现)"
            ]
        ]
        let ruleArr = [
            [
                "key": "",
                "value": "1、下单支付后会在预估收入里查看（会有不定期的延时）。"
            ],
            [
                "key": "",
                "value": "2、订单在确认收货（结算）后才会呈现在结算预估收入里。"
            ],
            [
                "key": "",
                "value": "3、当申请售后（维权）成功后会从预估收入及结算预估收入中剔除。"
            ],
            [
                "key": "",
                "value": "4、取消订单、退款退货、申请售后维权都会产生预估收入和结算收入的数据变动。"
            ]
        ]
        var thisArr = [Dictionary<String,String>]()
        
        let alert = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: UIScreen.main.bounds.size.height))
        alert.backgroundColor = colorwithRGBA(0, 0, 0, 0.3)
        alert.configureLayout { (layout) in
            layout.isEnabled = true
            layout.justifyContent = .center
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(UIScreen.main.bounds.size.height)
        }
        let alertMain = UIView()
        alertMain.backgroundColor = .white
        alertMain.layer.cornerRadius = 5
        alertMain.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.width = YGValue(kScreenW * 0.8)
            layout.padding = 30
        }
        alert.addSubview(alertMain)
        let alertTitle = UILabel()
        if index == 1 || index == 2 {
            alertTitle.text = "日预估收入说明"
        } else if index == 3 {
            alertTitle.text = "月预估收入说明"
        } else {
            alertTitle.text = "规则说明"
        }
        alertTitle.font = FontSize(16)
        alertTitle.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginBottom = 30
        }
        alertMain.addSubview(alertTitle)
        // 数据列表
        let dataList = UIView()
        dataList.configureLayout { (layout) in
            layout.isEnabled = true
        }
        alertMain.addSubview(dataList)
        if index == 1 || index == 2 {
            thisArr = dayArr
        } else if index == 3 {
            thisArr = mouthArr
        } else {
            thisArr = ruleArr
        }
        for item in thisArr {
            let listItem = UILabel()
            listItem.numberOfLines = 2
            let paraph = NSMutableParagraphStyle()
            paraph.lineSpacing = 5
            listItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.marginBottom = 20
            }
            let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : kMainTextColor, NSAttributedString.Key.paragraphStyle: paraph]
            let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : kGrayTextColor, NSAttributedString.Key.paragraphStyle: paraph]
            let attributedString1 = NSMutableAttributedString(string:item["key"]!, attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string:item["value"]!, attributes:attrs2)
            attributedString1.append(attributedString2)
            listItem.attributedText = attributedString1
            dataList.addSubview(listItem)
        }
        // 关闭按钮
        let closeBtn = UIButton()
        closeBtn.setTitle("知道了", for: .normal)
        closeBtn.titleLabel?.font = FontSize(14)
        closeBtn.backgroundColor = kLowOrangeColor
        closeBtn.layer.cornerRadius = 18
        closeBtn.layer.masksToBounds = true
        closeBtn.addTarget(self, action: #selector(closedAction), for: .touchUpInside)
        closeBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 100
            layout.height = 36
            layout.marginTop = 20
        }
        alertMain.addSubview(closeBtn)
        
        alert.yoga.applyLayout(preservingOrigin: true)
        //获取delegate
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        //添加tag
        alert.tag = 101
        //添加视图
        delegate.window?.addSubview(alert)
    }
    // 修改系统状态栏字颜色为白色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // 关闭弹窗
    @objc func closedAction(btn: UIButton) {
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.viewWithTag(101)?.removeFromSuperview()
    }
    // 跳转提现页面
    @objc func toWithdraw(btn: UIButton) {
        navigationController?.pushViewController(WithdrawView(), animated: true)
    }
    // 跳转账单详情
    @objc func toBill(btn: UIButton) {
        navigationController?.pushViewController(billView(), animated: true)
    }
    
    func loadData(){
        AlamofireUtil.post(url: "/user/wallet/myEarnings",
        param: [:],
        success: { (res,data) in
            self.data = MyIncomeModel.deserialize(from: data.description)!
            self.balanceNum.text = "¥"+(self.data?.balance!)!
            //本日数据
            self.todayPay.text = self.data?.todayPay
            self.todayDeal.text = "¥"+self.data!.todayDeal!
            self.todaySettle.text = "¥"+self.data!.todaySettle!
            //昨日数据
            self.yesterdayPay.text = self.data?.yesterdayPay
            self.yesterdayDeal.text = "¥"+self.data!.yesterdayDeal!
            self.yesterdaySettle.text = "¥"+self.data!.yesterdaySettle!
            //月数据
            self.thisMouthConsume.text = "¥"+self.data!.thisMouthConsume!
            self.lastMouthConsume.text = "¥"+self.data!.lastMouthConsume!
            self.lastMouthSettle.text = "¥"+self.data!.lastMouthSettle!
            
        },
        error: {},
        failure: {})
    }
}
