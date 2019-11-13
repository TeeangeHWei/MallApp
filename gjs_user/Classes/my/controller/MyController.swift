//
//  myController.swift
//  zcs_user
//
//  Created by 大杉网络 on 2019/8/7.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import LLCycleScrollView

@available(iOS 11.0, *)
class MyController: ViewController, UIScrollViewDelegate {
    
    let navItem = UINavigationItem()
    var isCancel = false
    private var info : [String : String] = UserDefaults.getInfo() as! [String:String]
    private let nickname = UILabel()
    private let avatar = UIImageView(image: UIImage(named: "loading"))
    private let codeValue = UILabel()
    private let grade1 : UIImage = UIImage(named: "grade-1")!
    private let grade2 : UIImage = UIImage(named: "grade-2")!
    private let grade3 : UIImage = UIImage(named: "grade-3")!
    private var grade : UIImageView = UIImageView()
    private var numLabelList : [UILabel] = [UILabel]()
    private let moneyValue = UILabel()
    // 轮播图数组
    private var bannerList = [MyBanner]()
    var swiper : LLCycleScrollView?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let titlelabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        titlelabel.text = info["nickName"]!
        titlelabel.textColor = .white
        navItem.titleView = titlelabel
        //打印当前滚动条实时位置
        if scrollView.contentOffset.y <= 0 {
            var offset = scrollView.contentOffset
            offset.y = 0
            scrollView.contentOffset = offset
        }
        if scrollView.contentOffset.y > 10 {
            titlelabel.text = info["nickName"]!
        }else {
            titlelabel.text = ""
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        let isShow = UserDefaults.getIsShow()
        var allHeight = 0
        let containerSize = self.view.bounds.size
        
        let root = self.view!
        root.backgroundColor = colorwithRGBA(247,247,247,1)
        
        let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: containerSize.width, height: (containerSize.height - headerHeight - kTabBarHeight)))
        body.showsVerticalScrollIndicator = false
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.width = YGValue(containerSize.width)
            layout.height = YGValue(containerSize.height - kNavigationBarHeight - kTabBarHeight)
        }
        root.addSubview(body)
        
        body.delegate = self
        
        
        
        self.scrollViewDidScroll(body)
        // --------基本信息--------
        let basic = UIView(frame: CGRect(x: 0, y: 0, width: containerSize.width, height: 140))
        basic.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        basic.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.width = YGValue(containerSize.width)
            layout.height = YGValue(120)
//            layout.paddingTop = 20
        }
        body.addSubview(basic)
        allHeight += 200
        
        // 个人信息
        let info = UIView()
        info.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.width = YGValue(containerSize.width)
            layout.height = YGValue(80)
            layout.paddingLeft = 20
        }
        basic.addSubview(info)
        // 头像
        avatar.isUserInteractionEnabled = true
//        avatar.add
        avatar.layer.cornerRadius = 40
        avatar.layer.borderWidth = 2
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.layer.masksToBounds = true
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(avatarToSetup(sender:)))
        avatar.addGestureRecognizer(avatarTap)
        avatar.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(80)
            layout.height = YGValue(80)
            layout.marginRight = YGValue(10)
        }
        info.addSubview(avatar)
        // 个人信息right
        let infoRight = UIView()
        infoRight.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.justifyContent = .center
            layout.width = YGValue(containerSize.width - 130)
        }
        info.addSubview(infoRight)
        // 昵称
        nickname.text = "用户昵称"
        nickname.textColor = .white
        nickname.font = FontSize(16)
        nickname.configureLayout { (layout) in
            layout.isEnabled = true
        }
        infoRight.addSubview(nickname)
        // 会员等级
        if isShow == 0 {
            grade.isHidden = true
        }
        grade.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(78)
            layout.height = YGValue(18)
            layout.marginTop = 5
            layout.marginBottom = 5
        }
        infoRight.addSubview(grade)
        // 邀请码
        let invite = UIView()
        if isShow == 0 {
            invite.isHidden = true
        }
        invite.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        infoRight.addSubview(invite)
        let inviteCode = UIView()
        inviteCode.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        invite.addSubview(inviteCode)
        let codeKey = UILabel()
        codeKey.text = "邀请码:"
        codeKey.textColor = .white
        codeKey.font = FontSize(14)
        codeKey.configureLayout { (layout) in
            layout.isEnabled = true
        }
        inviteCode.addSubview(codeKey)
        codeValue.text = "EEEEEE"
        codeValue.textColor = .white
        codeValue.font = BoldFontSize(14)
        codeValue.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 65
        }
        inviteCode.addSubview(codeValue)
        // 复制按钮
        let copyBtn = UIButton()
        copyBtn.addTarget(self, action: #selector(MyView.wishSeed(_:)), for: UIControl.Event.touchUpInside)
        copyBtn.setTitle("复制", for: .normal)
        copyBtn.setTitleColor(colorwithRGBA(247,51,47,1), for: .normal)
        copyBtn.backgroundColor = .white
        copyBtn.titleLabel?.font = FontSize(14)
        copyBtn.layer.cornerRadius = 5
        copyBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 44
            layout.height = 20
            layout.marginLeft = 5
        }
        invite.addSubview(copyBtn)
        
        
        // --------我的收益--------
        let myIncome = UIView()
        myIncome.backgroundColor = .white
        myIncome.layer.cornerRadius = 5
        myIncome.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(containerSize.width - 20)
            layout.height = 130
            layout.marginLeft = 10
            layout.marginTop = -15
        }
        body.addSubview(myIncome)
        allHeight += 115
        // 标题
        let myIncomeT = UIView(frame: CGRect(x: 0, y: 0, width: containerSize.width - 20, height: 36))
        myIncomeT.tag = 1
        myIncomeT.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(toDetail(sender:)))
        myIncomeT.addGestureRecognizer(tap)
        myIncomeT.addBorder(side: .bottom, thickness: CGFloat(1), color: klineColor)
        myIncomeT.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.paddingLeft = 15
            layout.paddingRight = 15
            layout.width = YGValue(containerSize.width - 20)
            layout.height = 36
        }
        myIncome.addSubview(myIncomeT)
        
        let incomeTLeft = UIView()
        incomeTLeft.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        myIncomeT.addSubview(incomeTLeft)
        let incomeImg = UIImageView(image: UIImage(named: "income"))
        incomeImg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 18
            layout.height = 18
            layout.marginRight = 5
        }
        incomeTLeft.addSubview(incomeImg)
        let tLabel = UILabel()
        tLabel.text = "我的收益"
        tLabel.font = FontSize(14)
        tLabel.configureLayout { (layout) in
            layout.isEnabled = true
        }
        incomeTLeft.addSubview(tLabel)
        let arrow = UIImageView(image: UIImage(named: "arrow-black"))
        arrow.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 8
            layout.height = 14
        }
        myIncomeT.addSubview(arrow)
        // 收益信息
        let myIncomeList = UIView()
        myIncomeList.tag = 1
        myIncomeList.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(toDetail(sender:)))
        myIncomeList.addGestureRecognizer(tap2)
        myIncomeList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.width = YGValue(containerSize.width - 20)
            layout.height = 70
            layout.paddingTop = 10
            layout.paddingBottom = 10
        }
        myIncome.addSubview(myIncomeList)
        for index in 1...3 {
            var name = "今日预估"
            var num = 15.0
            var needBorder = true
            if index == 1 {
                name = "今日预估"
                num = 15.11
                needBorder = true
            } else if index == 2 {
                name = "昨日预估"
                num = 15.0
                needBorder = true
            } else if index == 3 {
                name = "本月预估"
                num = 15.26
                needBorder = false
            }
            let myIncomeItem = UIView(frame: CGRect(x: 0, y: 0, width: (containerSize.width - 20)/3, height: 50))
            if needBorder {
                myIncomeItem.addBorder(side: .right, thickness: CGFloat(1), color: klineColor)
            }
            myIncomeItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.flexDirection = .column
                layout.alignItems = .center
                layout.justifyContent = .center
                layout.width = YGValue((containerSize.width - 20)/3)
                layout.height = 50
            }
            myIncomeList.addSubview(myIncomeItem)
            let numLabel = UILabel()
            numLabel.text = String(format:"%.2f",num)
            numLabel.textAlignment = .center
            numLabel.font = FontSize(16)
            numLabel.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue((containerSize.width - 20)/3)
                layout.marginBottom = 10
            }
            myIncomeItem.addSubview(numLabel)
            numLabelList.append(numLabel)
            let nameLabel = UILabel()
            nameLabel.text = name
            nameLabel.font = FontSize(12)
            nameLabel.textColor = colorwithRGBA(150,150,150,1)
            nameLabel.configureLayout { (layout) in
                layout.isEnabled = true
            }
            myIncomeItem.addSubview(nameLabel)
        }
        
        // 累计收益
        let total = UIView()
        total.layer.contents = UIImage(named:"totalbgd")?.cgImage
        total.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.width = YGValue(containerSize.width - 30)
            layout.height = YGValue((containerSize.width - 30)*0.14)
            layout.marginLeft = 5
            layout.paddingLeft = 35
            layout.paddingRight = 35
            layout.paddingBottom = 5
        }
        myIncome.addSubview(total)
        // total left
        let totalLeft = UIView()
        totalLeft.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        total.addSubview(totalLeft)
        let totalIcon = UIImageView(image: UIImage(named: "total-icon"))
        totalIcon.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.width = YGValue(20)
            layout.height = YGValue(20)
            layout.marginRight = 5
        }
        totalLeft.addSubview(totalIcon)
        let money = UIView()
        money.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        totalLeft.addSubview(money)
        let moneyKey = UILabel()
        moneyKey.text = "累计收入"
        moneyKey.font = FontSize(12)
        moneyKey.textColor = colorwithRGBA(110,87,57,1)
        moneyKey.configureLayout { (layout) in
            layout.isEnabled = true
        }
        money.addSubview(moneyKey)
        
        moneyValue.text = "5.98"
        moneyValue.font = FontSize(16)
        moneyValue.textColor = colorwithRGBA(110,87,57,1)
        moneyValue.configureLayout { (layout) in
            layout.isEnabled = true
            layout.minWidth = YGValue(kScreenW * 0.4)
            layout.marginLeft = 5
        }
        money.addSubview(moneyValue)
        // total right
        let totalRight = UIButton()
        totalRight.titleLabel?.font = FontSize(14)
        totalRight.setTitle("提现", for: .normal)
        totalRight.setTitleColor(colorwithRGBA(110,87,57,1), for: .normal)
        totalRight.addTarget(self, action: #selector(toWithdraw), for: .touchUpInside)
        totalRight.configureLayout { (layout) in
            layout.isEnabled = true
        }
        total.addSubview(totalRight)
        
        
        // --------订单相关--------
        let taskAbout = UIView()
        taskAbout.backgroundColor = .white
        taskAbout.layer.cornerRadius = 5
        taskAbout.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.width = YGValue(containerSize.width - 20)
            layout.height = 90
            layout.marginLeft = 10
            layout.marginTop = 30
        }
        body.addSubview(taskAbout)
        allHeight += 120
        var taskList = [[String : String]]()
        if isShow == 1 {
            taskList = [
                [
                    "name": "我的收益",
                    "icon": "mytask-1",
                    "tag": "1"
                ],
                [
                    "name": "订单详情",
                    "icon": "mytask-2",
                    "tag": "2"
                ],
                [
                    "name": "我的粉丝",
                    "icon": "mytask-3",
                    "tag": "3"
                ],
                [
                    "name": "分享好友",
                    "icon": "mytask-4",
                    "tag": "4"
                ],
            ]
        } else {
            taskList = [
                [
                    "name": "我的收益",
                    "icon": "mytask-1",
                    "tag": "1"
                ],
                [
                    "name": "订单详情",
                    "icon": "mytask-2",
                    "tag": "2"
                ]
            ]
        }
        
        for item in taskList {
            let taskItem = UIView()
            taskItem.tag = Int(item["tag"]!)!
            taskItem.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(toDetail(sender:)))
            taskItem.addGestureRecognizer(tap)
            taskItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.flexDirection = .column
                layout.alignItems = .center
                layout.width = YGValue((containerSize.width - 20)/4)
                layout.height = YGValue(60)
            }
            taskAbout.addSubview(taskItem)
            let taskIcon = UIImageView(image: UIImage(named: item["icon"]!))
            taskIcon.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(30)
                layout.height = YGValue(30)
                layout.marginBottom = 10
            }
            taskItem.addSubview(taskIcon)
            let itemName = UILabel()
            itemName.text = item["name"]!
            itemName.font = FontSize(12)
            itemName.configureLayout { (layout) in
                layout.isEnabled = true
            }
            taskItem.addSubview(itemName)
        }
        
        
        // --------轮播图--------
        swiper = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect.init(x: 0, y: 0, width: containerSize.width - 20, height: (containerSize.width - 20) * 0.21), didSelectItemAtIndex: { index in
            let vc = BannerWebViewController()
            vc.webAddress = "https://www.ganjinsheng.com/user/null"
            vc.toUrl = self.bannerList[index].appUrl!
            vc.headerTitle = self.bannerList[index].adTitle!
            self.navigationController?.pushViewController(vc, animated: true)
        })
        swiper!.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(containerSize.width - 20)
            layout.height = YGValue((containerSize.width - 20) * 0.21)
            layout.marginTop = 10
            layout.marginLeft = 10
        }
        
//        let imagesURLStrings = [
//            "https://www.ganjinsheng.com/files/user/slide/88400055909574.png"
//        ];
        
        // 是否自动滚动
        swiper!.autoScroll = true
        // 是否无限循环，此属性修改了就不存在轮播的意义了 😄
        swiper!.infiniteLoop = true
        // 滚动间隔时间(默认为2秒)
        swiper!.autoScrollTimeInterval = 3.0
        // 等待数据状态显示的占位图
        //        bannerDemo.placeHolderImage = #UIImage
        // 如果没有数据的时候，使用的封面图
        //        bannerDemo.coverImage = #UIImage
        // 设置图片显示方式=UIImageView的ContentMode
        swiper!.imageViewContentMode = .scaleToFill
        // 设置滚动方向（ vertical || horizontal ）
        swiper!.scrollDirection = .horizontal
        // 设置当前PageControl的样式 (.none, .system, .fill, .pill, .snake)
        swiper!.customPageControlStyle = .snake
        // 非.system的状态下，设置PageControl的tintColor
        swiper!.customPageControlInActiveTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
        // 设置.system系统的UIPageControl当前显示的颜色
        swiper!.pageControlCurrentPageColor = .clear
        // 非.system的状态下，设置PageControl的间距(默认为8.0)
        swiper!.customPageControlIndicatorPadding = 8.0
        // 设置PageControl的位置 (.left, .right 默认为.center)
        swiper!.pageControlPosition = .center
        // 背景色
        swiper!.backgroundColor = .white
        // 添加到view
        if UserDefaults.getIsShow() == 1{
            body.addSubview(swiper!)
            allHeight += Int((containerSize.width - 20) * 0.21) + 10
        }
        
        
        // --------实用工具--------
        let tool = UIView()
        tool.backgroundColor = .white
        tool.layer.cornerRadius = 5
        tool.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(containerSize.width - 20)
            layout.height = YGValue(120)
            layout.marginTop = 10
            layout.marginLeft = 10
        }
        body.addSubview(tool)
        allHeight += 130
        // 标题
        let toolT = UIView(frame: CGRect(x: 0, y: 0, width: containerSize.width - 20, height: 36))
        toolT.addBorder(side: .bottom, thickness: CGFloat(1), color: klineColor)
        toolT.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.paddingLeft = 15
            layout.paddingRight = 15
            layout.width = YGValue(containerSize.width - 20)
            layout.height = 36
        }
        tool.addSubview(toolT)
        
        let toolTLeft = UIView()
        toolTLeft.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        toolT.addSubview(toolTLeft)
        let toolImg = UIImageView(image: UIImage(named: "tool"))
        toolImg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 18
            layout.height = 18
            layout.marginRight = 5
        }
        toolTLeft.addSubview(toolImg)
        let toolTLabel = UILabel()
        toolTLabel.text = "实用工具"
        toolTLabel.font = FontSize(14)
        toolTLabel.configureLayout { (layout) in
            layout.isEnabled = true
        }
        toolTLeft.addSubview(toolTLabel)
        // 工具列表
        let toolList = UIView()
        toolList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.width = YGValue(containerSize.width - 20)
            layout.height = 84
            layout.padding = 10
        }
        tool.addSubview(toolList)
        var toolData = [[String : String]]()
        if isShow == 1 {
            toolData = [
//                [
//                    "name": "唤醒会员",
//                    "icon": "tool-1",
//                    "tag": "5"
//                ],
                [
                    "name": "找回订单",
                    "icon": "tool-2",
                    "tag": "6"
                ],
                [
                    "name": "个人商城",
                    "icon": "tool-5",
                    "tag": "7"
                ],
                [
                    "name": "新手教程",
                    "icon": "tool-4",
                    "tag": "8"
                ],
            ]
        } else {
            toolData = [
                [
                    "name": "找回订单",
                    "icon": "tool-2",
                    "tag": "6"
                ],
                [
                    "name": "新手教程",
                    "icon": "tool-4",
                    "tag": "8"
                ],
            ]
        }
        
        for item in toolData {
            let taskItem = UIView()
            taskItem.tag = Int(item["tag"]!)!
            let tap = UITapGestureRecognizer(target: self, action: #selector(toDetail(sender:)))
            taskItem.addGestureRecognizer(tap)
            taskItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.flexDirection = .column
                layout.alignItems = .center
                layout.width = YGValue((containerSize.width - 40)/4)
            }
            toolList.addSubview(taskItem)
            let taskIcon = UIImageView(image: UIImage(named: item["icon"]!))
            taskIcon.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(35)
                layout.height = YGValue(31.85)
                layout.marginBottom = 5
            }
            taskItem.addSubview(taskIcon)
            let itemName = UILabel()
            itemName.text = item["name"]!
            itemName.font = FontSize(12)
            itemName.configureLayout { (layout) in
                layout.isEnabled = true
            }
            taskItem.addSubview(itemName)
        }
        
        // --------其他服务--------
        let other = UIView()
        other.backgroundColor = .white
        other.layer.cornerRadius = 5
        other.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(containerSize.width - 20)
            layout.height = YGValue(196)
            layout.marginTop = 10
            layout.marginLeft = 10
        }
        body.addSubview(other)
        allHeight += 206
        // 标题
        let otherT = UIView(frame: CGRect(x: 0, y: 0, width: containerSize.width - 20, height: 36))
        otherT.addBorder(side: .bottom, thickness: CGFloat(1), color: klineColor)
        otherT.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.paddingLeft = 15
            layout.paddingRight = 15
            layout.width = YGValue(containerSize.width - 20)
            layout.height = 36
        }
        other.addSubview(otherT)
        
        let otherTLeft = UIView()
        otherTLeft.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        otherT.addSubview(otherTLeft)
        let otherImg = UIImageView(image: UIImage(named: "other"))
        otherImg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 18
            layout.height = 18
            layout.marginRight = 5
        }
        otherTLeft.addSubview(otherImg)
        let otherTLabel = UILabel()
        otherTLabel.text = "其他服务"
        otherTLabel.font = FontSize(14)
        otherTLabel.configureLayout { (layout) in
            layout.isEnabled = true
        }
        otherTLeft.addSubview(otherTLabel)
        // 服务列表
        let otherList = UIView()
        otherList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.flexWrap = .wrap
            layout.alignItems = .center
            layout.width = YGValue(containerSize.width - 20)
            layout.height = 160
            layout.padding = 10
        }
        other.addSubview(otherList)
        let otherData = [
            [
                "name": "官方公告",
                "icon": "other-1",
                "tag": "9"
            ],
            [
                "name": "我的收藏",
                "icon": "other-2",
                "tag": "10"
            ],
            [
                "name": "专属客服",
                "icon": "other-3",
                "tag": "11"
            ],
            [
                "name": "常见问题",
                "icon": "other-4",
                "tag": "12"
            ],
            [
                "name": "意见反馈",
                "icon": "other-5",
                "tag": "13"
            ],
            [
                "name": "关于",
                "icon": "other-6",
                "tag": "14"
            ],
        ]

        for item in otherData {
            let taskItem = UIView()
            taskItem.tag = Int(item["tag"]!)!
            let tap = UITapGestureRecognizer(target: self, action: #selector(toDetail(sender:)))
            taskItem.addGestureRecognizer(tap)
            taskItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.flexDirection = .column
                layout.alignItems = .center
                layout.justifyContent = .center
                layout.width = YGValue((containerSize.width - 40)/4)
                layout.height = YGValue(70)
            }
            otherList.addSubview(taskItem)
            let taskIcon = UIImageView(image: UIImage(named: item["icon"]!))
            taskIcon.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(26)
                layout.height = YGValue(26)
                layout.marginBottom = 5
            }
            taskItem.addSubview(taskIcon)
            let itemName = UILabel()
            itemName.text = item["name"]!
            itemName.font = FontSize(12)
            itemName.configureLayout { (layout) in
                layout.isEnabled = true
            }
            taskItem.addSubview(itemName)
        }
        
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight + 20), right: CGFloat(0))
        
        body.yoga.applyLayout(preservingOrigin: true)
        
        // 请求数据
        getInfo()
        getBanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isCancel = false
        getUserInfo()
    }
    
    func setNav () {
        let coustomNavView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height:headerHeight))
        coustomNavView.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        coustomNavView.backgroundColor = .white
        self.view.addSubview(coustomNavView)
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight))
//        let backBtn = UIBarButtonItem(image: UIImage(named: "arrow-back"), style: .plain, target: nil, action: #selector(backAction(sender:)))
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        navBar.tintColor = .white
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
//        navItem.setLeftBarButton(backBtn, animated: true)
        navBar.pushItem(navItem, animated: true)
        coustomNavView.addSubview(navBar)
        
        let mesagebtn = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        mesagebtn.addTarget(self, action: #selector(toNews), for: .touchUpInside)
        mesagebtn.setImage(UIImage(named: "news-white"), for: .normal)
        let mesagebtn1 = UIBarButtonItem(customView: mesagebtn)
        
        
        let gearbtn = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        gearbtn.addTarget(self, action: #selector(toSetup), for: .touchUpInside)
        gearbtn.setImage(UIImage(named: "setup"), for: .normal)
        let gearbtn1 = UIBarButtonItem(customView: gearbtn)
        //按钮间的空隙
        let gap = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                  action: nil)
        gap.width = 15
        
        //用于消除右边边空隙，要不然按钮顶不到最边上
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                     action: nil)
        spacer.width = -5
        
        navItem.rightBarButtonItems = [spacer,gearbtn1,gap,mesagebtn1]
    }
    
    // 修改系统状态栏字颜色为白色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func wishSeed(_ sender:UIButton!){
        UIPasteboard.general.string = info["inviteCode"]
        IDToast.id_show(msg: "复制成功", success: .success)
    }
    
    // 跳转消息页面
    @objc func toNews(_ btn:UIButton) {
        navigationController?.pushViewController(NewsView(), animated: true)
    }
    
    // 跳转设置页面
    @objc func toSetup(_ btn:UIButton) {
        navigationController?.pushViewController(SetupView(), animated: true)
    }
    
    // 头像跳转设置
    @objc func avatarToSetup(sender:UITapGestureRecognizer) {
        navigationController?.pushViewController(SetupView(), animated: true)
    }
    
    // 跳转提现
    @objc func toWithdraw(_ btn:UIButton) {
        navigationController?.pushViewController(WithdrawView(), animated: true)
    }
    
    // 跳转页面
    @objc func toDetail(sender:UITapGestureRecognizer) {
        if sender.view?.tag == 1 {
            navigationController?.pushViewController(MyIncomeController(), animated: true)
        }else if sender.view?.tag == 2 {
            navigationController?.pushViewController(OrderListView(), animated: true)
        }else if sender.view?.tag == 3 {
            navigationController?.pushViewController(MyFansView(), animated: true)
        }else if sender.view?.tag == 4 {
            navigationController?.pushViewController(ShareController(), animated: true)
        }else if sender.view?.tag == 5 {
            navigationController?.pushViewController(RouseController(), animated: true)
        }else if sender.view?.tag == 6 {
            navigationController?.pushViewController(RetrieveView(), animated: true)
        }else if sender.view?.tag == 7 {
            navigationController?.pushViewController(PrivateShopView(), animated: true)
        }else if sender.view?.tag == 8 {
            navigationController?.pushViewController(CourseController(), animated: true)
        }else if sender.view?.tag == 9 {
            navigationController?.pushViewController(NoticeView(), animated: true)
        }else if sender.view?.tag == 10 {
            navigationController?.pushViewController(MyCollectionController(), animated: true)
        }else if sender.view?.tag == 11 {
            navigationController?.pushViewController(CustomerServiceView(), animated: true)
        }else if sender.view?.tag == 12 {
            navigationController?.pushViewController(QuesionViewController(), animated: true)
        }else if sender.view?.tag == 14 {
            navigationController?.pushViewController(AboutView(), animated: true)
        }else if sender.view?.tag == 13 {
            navigationController?.pushViewController(AdviceView(), animated: true)
        }
    }
    
    // 获取钱包信息
    func getInfo () {
        AlamofireUtil.post(url:"/user/wallet/getWalletInfo", param: [:],
        success:{(res, data) in
            if self.isCancel {
                return
            }
            let walletInfo = WalletInfo.deserialize(from: data.description)!
            // 数据渲染
            self.nickname.text = self.info["nickName"]!
            let url = URL(string: UrlFilter(self.info["headPortrait"]!))!
            let placeholderImage = UIImage(named: "loading")
            self.avatar.af_setImage(withURL: url, placeholderImage: placeholderImage)
            self.codeValue.text = self.info["inviteCode"]!
            if self.info["memberStatus"] == "1" {
                self.grade.image = self.grade1
            } else if self.info["memberStatus"] == "2" {
                self.grade.image = self.grade2
            } else {
                self.grade.image = self.grade3
            }
            self.numLabelList[0].text = String(format:"%.2f",(walletInfo.wallet!.todayDeal! as NSString).doubleValue)
            self.numLabelList[1].text = String(format:"%.2f",(walletInfo.wallet!.yesterdayDeal! as NSString).doubleValue)
            self.numLabelList[2].text = String(format:"%.2f",(walletInfo.wallet!.thisMouthConsume! as NSString).doubleValue)
            self.moneyValue.text = String(format:"%.2f",(walletInfo.wallet!.totalIncome! as NSString).doubleValue)
        },
        error:{
        },
        failure:{
        })
    }
    // 获取轮播图
    func getBanner () {
        AlamofireUtil.post(url:"/user/public/slideshow/list", param: [
            "pageNo" : "1",
            "pageSize" : "4",
            "specialShowType" : "1"
        ],
        success:{(res, data) in
            self.bannerList = MyBannerList.deserialize(from: data.description)!.list!
            var imgList = [String]()
            for item in self.bannerList {
                let imgUrl = "https://www.ganjinsheng.com" + String(item.img!)
                imgList.append(imgUrl)
            }
            self.swiper!.imagePaths = imgList
        },
        error:{
        },
        failure:{
        })
    }
    
    // 获取用户信息
    func getUserInfo(){
        AlamofireUtil.post(url:"/user/info/getUserInfo", param: [:],
        success:{(res, data) in
            // 获取并将用户信息保存到缓存中
            UserDefaults.setInfo(value: data.dictionary!.compactMapValues({ (data) -> String? in
                data.description
            }))
            self.info = UserDefaults.getInfo() as! [String:String]
            // 数据渲染
            self.nickname.text = self.info["nickName"]!
            let url = URL(string: UrlFilter(self.info["headPortrait"]!))!
            let placeholderImage = UIImage(named: "loading")
            self.avatar.af_setImage(withURL: url, placeholderImage: placeholderImage)
            self.codeValue.text = self.info["inviteCode"]!
            if self.info["memberStatus"] == "1" {
                self.grade.image = self.grade1
            } else if self.info["memberStatus"] == "2" {
                self.grade.image = self.grade2
            } else {
                self.grade.image = self.grade3
            }
        },
        error:{},
        failure:{})
    }
}
