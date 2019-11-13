//
//  IncomeListView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/23.
//  Copyright © 2019 大杉网络. All rights reserved.
//


@available(iOS 11.0, *)
class IncomeListView: UIView {
    
    // 数据面板宽度
    private let panelWidth = kScreenW * 0.9 - 30
    // 日期类型
    var timeType = 1
    // 时间按钮组
    var timeBtnArr = [UIButton]()
    // 我的付款笔数
    let userOrderLabel = UILabel()
    // 团队付款笔数
    let teamOrderLabel = UILabel()
    // 我的预估收益
    let userIncomeLabel = UILabel()
    // 团队预估收益
    let teamIncomeLabel = UILabel()
    // 结算收入
    let totalKey = UILabel()
    let totalIncome = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.9 - 30, height: 50))
    let totalNum = UILabel()
    let selectBtn = UIButton()
    let selectValue = UILabel()
    var titleView : UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        let isShow = UserDefaults.getIsShow()
        self.configureLayout { (layout) in
            layout.isEnabled = true
        }
        
        // 日期按钮列表
        let btnList = UIView()
        btnList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .center
            layout.alignItems = .center
            layout.height = 56
        }
        self.addSubview(btnList)
        let btnTextList = [
            "今日收益",
            "昨日收益",
            "本月收益",
            "上月收益"
        ]
        for (index, item) in btnTextList.enumerated() {
            let timeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.2, height: 28))
            timeBtn.tag = index + 1
            timeBtn.setTitle(item, for: .normal)
            timeBtn.layer.cornerRadius = 14
            timeBtn.layer.masksToBounds = true
            timeBtn.titleLabel?.font = FontSize(14)
            timeBtn.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(kScreenW * 0.2)
                layout.height = 28
            }
            if item == "今日收益" {
                timeBtn.setTitleColor(.white, for: .normal)
                timeBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
            } else {
                timeBtn.setTitleColor(kMainTextColor, for: .normal)
            }
            btnList.addSubview(timeBtn)
            timeBtnArr.append(timeBtn)
        }
        
        // 付款笔数及收益
        let dataPanel = UIView()
        dataPanel.backgroundColor = .white
        dataPanel.layer.cornerRadius = 10
        dataPanel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.9)
            layout.marginLeft = YGValue(kScreenW * 0.05)
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        self.addSubview(dataPanel)
        // 我的订单收益
        let panelUser = setPanelItem(title: "我的订单收益", orderLabel: userOrderLabel, incomeLabel: userIncomeLabel)
        dataPanel.addSubview(panelUser)
        // 团队订单收益
        let panelTeam = setPanelItem(title: "团队订单收益", orderLabel: teamOrderLabel, incomeLabel: teamIncomeLabel)
        if isShow == 1 {
            dataPanel.addSubview(panelTeam)
        }
        // 结算收入
        totalIncome.addBorder(side: .top, thickness: 1, color: klineColor)
        totalIncome.layer.mask = totalIncome.configRectCorner(view: totalIncome, corner: [.bottomLeft, .bottomRight], radii: CGSize(width: 10, height: 10))
        totalIncome.backgroundColor = .white
        totalIncome.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .center
            layout.alignItems = .center
            layout.width = YGValue(self.panelWidth)
            layout.height = 50
        }
        if isShow == 1 {
            dataPanel.addSubview(totalIncome)
        }
        totalKey.text = "次月22号预计到账："
        totalKey.font = FontSize(14)
        totalKey.textColor = kMainTextColor
        totalKey.configureLayout { (layout) in
            layout.isEnabled = true
        }
        totalIncome.addSubview(totalKey)
        totalNum.text = "¥ 0.0"
        totalNum.font = FontSize(16)
        totalNum.textColor = kLowOrangeColor
        totalNum.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 60
        }
        totalIncome.addSubview(totalNum)
        // 规则说明
        let rule = UIView()
        rule.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.8)
            layout.marginTop = 15
            layout.marginLeft = YGValue(kScreenW * 0.1)
            layout.flexDirection = .row
            layout.justifyContent = .flexEnd
        }
        self.addSubview(rule)
        let ruleBtn = UIButton()
        ruleBtn.tag = 3
        ruleBtn.addTarget(self, action: #selector(toAlert), for: .touchUpInside)
        ruleBtn.setTitle("规则说明", for: .normal)
        ruleBtn.setTitleColor(kLowOrangeColor, for: .normal)
        ruleBtn.titleLabel?.font = FontSize(14)
        ruleBtn.configureLayout { (layout) in
            layout.isEnabled = true
        }
        rule.addSubview(ruleBtn)
        
        
        self.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPanelItem (title: String, orderLabel: UILabel, incomeLabel: UILabel) -> UIView {
        
        let panelItem = UIView()
        panelItem.configureLayout { (layout) in
            layout.isEnabled = true
        }
        // 面板标题
        titleView = UIView(frame: CGRect(x: 0, y: 0, width: panelWidth, height: 40))
        titleView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(self.panelWidth)
            layout.height = 40
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
        }
        titleView.addBorder(side: .bottom, thickness: 1, color: klineColor)
        panelItem.addSubview(titleView)
        let itemTitle = UILabel()
        itemTitle.text = title
        itemTitle.textColor = kMainTextColor
        itemTitle.font = FontSize(14)
        itemTitle.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 40
        }
        titleView.addSubview(itemTitle)
        
        
        
        if title == "我的订单收益" {
            // 平台收益筛选按钮
            selectBtn.configureLayout { (layout) in
                layout.isEnabled = true
                layout.height = 40
                layout.flexDirection = .row
                layout.alignItems = .center
            }
            titleView.addSubview(selectBtn)
            
            selectValue.text = "全部"
            selectValue.textAlignment = .right
            selectValue.font = FontSize(14)
            selectValue.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = 80
                layout.height = 40
                layout.flexDirection = .row
                layout.alignItems = .center
            }
            selectBtn.addSubview(selectValue)
            let selectIcon = UIImageView(image: UIImage(named: "arrow-bottom"))
            selectIcon.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = 20
                layout.height = 20
                layout.marginLeft = 8
            }
            selectBtn.addSubview(selectIcon)
        }
        // 面板数据
        let itemData = UIView()
        itemData.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
        }
        panelItem.addSubview(itemData)
        // 付款笔数
        let orderData = setPanelDataItem(title: "付款笔数", numLabel: orderLabel)
        itemData.addSubview(orderData)
        // 预估收益
        let incomeData = setPanelDataItem(title: "预估收益", numLabel: incomeLabel)
        itemData.addSubview(incomeData)
        
        return panelItem
    }
    
    func setPanelDataItem (title: String, numLabel: UILabel) -> UIView {
        
        let orderData = UIView()
        orderData.configureLayout { (layout) in
            layout.isEnabled = true
            layout.alignItems = .center
            layout.width = YGValue(self.panelWidth * 0.5)
            layout.paddingTop = 20
            layout.paddingBottom = 20
        }
        let orderTitle = UIView()
        orderTitle.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(self.panelWidth * 0.5)
            layout.flexDirection = .row
            layout.justifyContent = .center
            layout.alignItems = .center
        }
        orderData.addSubview(orderTitle)
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = FontSize(14)
        titleLabel.textAlignment = .center
        titleLabel.textColor = kMainTextColor
        titleLabel.configureLayout { (layout) in
            layout.isEnabled = true
        }
        orderTitle.addSubview(titleLabel)
        let helpBtn = UIButton()
        if title == "付款笔数" {
            helpBtn.tag = 1
        } else {
            helpBtn.tag = 2
        }
        helpBtn.addTarget(self, action: #selector(toAlert), for: .touchUpInside)
        helpBtn.setImage(UIImage(named: "help"), for: .normal)
        helpBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 14
            layout.height = 14
            layout.marginLeft = 3
        }
        orderTitle.addSubview(helpBtn)
        numLabel.text = "0"
        numLabel.textAlignment = .center
        numLabel.font = FontSize(16)
        numLabel.textColor = kLowOrangeColor
        numLabel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(self.panelWidth * 0.5)
            layout.marginTop = 8
        }
        orderData.addSubview(numLabel)
        
        return orderData
    }
    @objc func toAlert (_ btn: UIButton) {
        var timeStr = "今日"
        if timeType == 2 {
            timeStr = "昨日"
        } else if timeType == 3 {
            timeStr = "本月"
        } else if timeType == 4 {
            timeStr = "上月"
        }
        let index = btn.tag
        // 付款笔数说明
        let dayArr = [
            [
                "key": "",
                "value": "\(timeStr)所有付款的订单数量，只包含有效订单"
            ]
        ]
        let mouthArr = [
            [
                "key": "",
                "value": "\(timeStr)创建的所有有效订单预估收益"
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
        if index == 1 {
            alertTitle.text = "付款笔数说明"
        } else if index == 2 {
            alertTitle.text = "预估收益说明"
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
    
    // 关闭弹窗
    @objc func closedAction(btn: UIButton) {
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.viewWithTag(101)?.removeFromSuperview()
    }
  
}
