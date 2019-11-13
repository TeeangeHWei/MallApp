//
//  rouseController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/26.
//  Copyright © 2019 大杉网络. All rights reserved.
//

class RouseController: ViewController {
    
    var isCancel = false
    private var allHeight = 0
    // 请求相关参数
    private var isLoading = false
    private var isFinish = false
    
    let rouseView = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
    let rouseFooter = RouseFooterView(frame: CGRect(x: 0, y: kScreenH - headerHeight - 60, width: kScreenW, height: 80))
    let loadingView = UIActivityIndicatorView(style: .white)
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 打印当前滚动条实时位置
        let height = allHeight - Int(kScreenH) + Int(headerHeight) + 40
        if Int(scrollView.contentOffset.y) >= height && !isLoading {
            isLoading = true
//            getData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rouseFooter.nav = navigationController!
        setNav(titleStr: "", titleColor: .white, navItem: navigationItem, navController: navigationController)
        setNavigation()
        view.addSubview(rouseView)
        view.addSubview(rouseFooter)
        getData()
        getSmsBalance()
//        self.addChild(SelectorController())
//        self.view.addSubview(SelectorController().view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isCancel = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }
    
    func setNavigation () {
        let title = UIView()
        title.backgroundColor = kBGGrayColor
        title.layer.cornerRadius = 5
        title.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 220
            layout.height = 30
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.paddingTop = 5
            layout.paddingBottom = 5
        }
        let titleLeft = UILabel()
        titleLeft.text = "365天内-新增成员"
        titleLeft.textAlignment = .center
        titleLeft.font = FontSize(14)
        titleLeft.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 150
        }
        title.addSubview(titleLeft)
        let titleRight = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 18))
        titleRight.text = "筛选"
        titleRight.textAlignment = .center
        titleRight.font = FontSize(14)
        titleRight.textColor = kLowOrangeColor
        titleRight.addBorder(side: .left, thickness: 1, color: kLowGrayColor)
        titleRight.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 70
        }
        title.addSubview(titleRight)
        title.yoga.applyLayout(preservingOrigin: true)
        navigationItem.titleView = title
    }
    
    // 获取下级列表
    func getData () {
        if isFinish {
            return
        }
        self.loadingView.frame = CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 50)
        self.loadingView.isHidden = false
        AlamofireUtil.post(url: "/user/invite/getUserByDiff", param: [
            "day" : "365",
            "type" : "2"
        ],
        success:{(res, data) in
            if self.isCancel {
                return
            }
            var memberList = [MemberItemData]()
            for item in data.array! {
                let memberItem = MemberItemData.deserialize(from: item.description)!
                memberList.append(memberItem)
            }
            memberNum = memberList.count
            self.rouseFooter.leftLabel1.text = "\(memberList.count)位会员，7天内未登录"
            for item in memberList {
                let memberItem = MemberItem(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 80), data: item)
                self.rouseView.addSubview(memberItem)
                self.allHeight += 80
            }
            self.loadingView.isHidden = true
            self.isLoading = false
            self.rouseView.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(self.allHeight + 120), right: CGFloat(0))
        },
        error:{
            
        },
        failure:{
            
        })
    }
    
    // 获取短信余额
    func getSmsBalance () {
        AlamofireUtil.post(url: "/user/smsTemplate/getSmsBalance",
        param: [:],
        success: { (res,data) in
            smsData = SmsData.deserialize(from: data.description)!
        },
        error: {},
        failure: {})
    }
    
    // 设置loading控件
    func setLoading () {
        loadingView.isHidden = true
        loadingView.color = .darkGray
        loadingView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 50)
        loadingView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = 50
        }
        loadingView.startAnimating()
        rouseView.addSubview(loadingView)
    }
}
