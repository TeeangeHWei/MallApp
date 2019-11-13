//
//  MyIncomeController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/23.
//  Copyright © 2019 大杉网络. All rights reserved.
//


@available(iOS 11.0, *)
class MyIncomeController: ViewController {
    // 筛选数据
    let titles = ["    全部", "    淘宝", "  拼多多"]
    var timeType = 1
    let walletInfoView = WalletInfoView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: 200))
    let incomeListView = IncomeListView(frame: CGRect(x: 0, y: headerHeight + 200, width: kScreenW, height: 500))
    var walletType = 0
    override func viewDidLoad() {
        let navView = customNav(titleStr: "收益报表", titleColor: .white, border: false)
        navView.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        self.view.addSubview(navView)
        view.backgroundColor = kBGGrayColor
        walletInfoView.navC = navigationController!
        view.addSubview(walletInfoView)
        for item in incomeListView.timeBtnArr {
            item.addTarget(self, action: #selector(timeChange), for: .touchUpInside)
        }
        incomeListView.selectBtn.addTarget(self, action: #selector(selectPopView), for: .touchUpInside)
        view.addSubview(incomeListView)
        
        getWallet()
        getOrderIncome()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // 修改系统状态栏字颜色为白色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // 获取钱包信息
    func getWallet () {
        AlamofireUtil.post(url: "/user/wallet/getWalletInfo",
        param: [:],
        success: { (res,data) in
            let walletInfo = WalletInfo.deserialize(from: data.description)!
            self.walletInfoView.balanceNum.text = walletInfo.wallet?.balance!
            self.walletInfoView.moneyList[0].text = walletInfo.wallet?.totalIncome!
            self.walletInfoView.moneyList[1].text = walletInfo.withdrawal!
            self.walletInfoView.moneyList[2].text = walletInfo.notSettle!
        },
        error: {},
        failure: {})
    }
    
    // 获取付款笔数和预估收益
    func getOrderIncome () {
        var walletType = ""
        if self.walletType != 0 {
            walletType = String(self.walletType)
        }
        AlamofireUtil.post(url: "/user/wallet/getOrderIncome",
                           param: ["timeFlag":self.timeType, "type": walletType],
        success: { (res,data) in
            let orderIncome = OrderIncome.deserialize(from: data.description)!
            self.incomeListView.userOrderLabel.text = orderIncome.userCount!
            self.incomeListView.userIncomeLabel.text = "¥ \(orderIncome.userSum!)"
            self.incomeListView.teamOrderLabel.text = orderIncome.teamCount!
            self.incomeListView.teamIncomeLabel.text = "¥ \(orderIncome.teamSum!)"
            if let curSettle = orderIncome.curSettle {
                self.incomeListView.totalNum.text = "¥ \(curSettle)"
                if self.timeType == 2 {
                    self.incomeListView.totalKey.text = "次月22号预计到账："
                } else if self.timeType == 3 {
                    self.incomeListView.totalKey.text = "本月22号预计到账："
                }
                self.incomeListView.totalIncome.isHidden = false
            } else {
                self.incomeListView.totalIncome.isHidden = true
            }
        },
        error: {},
        failure: {})
    }
    
    @objc func timeChange (_ btn: UIButton) {
        self.timeType = btn.tag
        self.getOrderIncome()
        self.incomeListView.timeBtnArr[self.incomeListView.timeType - 1].gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), [UIColor.clear,UIColor.clear])
        self.incomeListView.timeBtnArr[self.incomeListView.timeType - 1].setTitleColor(kMainTextColor, for: .normal)
        self.incomeListView.timeBtnArr[btn.tag - 1].gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        self.incomeListView.timeBtnArr[btn.tag - 1].setTitleColor(.white, for: .normal)
        self.incomeListView.timeType = btn.tag
    }
    @objc func selectPopView(){
        print("点击了")
        
        let property = FWMenuViewProperty()
        property.popupCustomAlignment = .topRight
        property.popupAnimationType = .scale
        property.maskViewColor = UIColor.clear
        property.touchWildToHide = "1"
        property.popupViewEdgeInsets = UIEdgeInsets(top: 296 + headerHeight, left: 0, bottom: 0, right: 23)
        property.topBottomMargin = 10
        property.animationDuration = 0.3
        property.popupArrowStyle = .round
        property.popupArrowVertexScaleX = 1
        property.buttonFontSize = 15
        property.cornerRadius = 5

        property.textAlignment = .center

        let menuView = FWMenuView.menu(itemTitles: titles, itemImageNames: nil, itemBlock: { (popupView, index, title) in
                self.incomeListView.selectValue.text = title
                self.walletType = index
                self.getOrderIncome()
        }, property: property)
        menuView.show()
    }
}
