//
//  DetailView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/5.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import LLCycleScrollView

@available(iOS 11.0, *)
class PddDetailView: UIScrollView {
    weak var navigation : UINavigationController?
    var allHeight = 0
    let coupon = UIButton()
    let allShopBtn = UIButton()
    private let shopAvatar = UIImageView(image: UIImage(named: "avatar-default"))
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, data: PddDetailData) {
        self.init(frame: frame)
        let isShow = UserDefaults.getIsShow()
        self.backgroundColor = colorwithRGBA(241,241,241,1)
        
        let detailbody = self
        detailbody.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - 60)
        }
        
        // --------宝贝图片(轮播)--------
//        let goodsImg = UIImageView()
//        let url = URL(string: data.itempic!)!
//        let placeholderImage = UIImage(named: "loading")
//        goodsImg.af_setImage(withURL: url, placeholderImage: placeholderImage)
//        goodsImg.configureLayout { (layout) in
//            layout.isEnabled = true
//            layout.width = YGValue(kScreenW)
//            layout.height = YGValue(kScreenW)
//        }
//        detailbody.addSubview(goodsImg)
        
        
        // --------轮播图--------
        let swiper = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenW), didSelectItemAtIndex: { index in
            
        })
        swiper.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenW)
        }
        var imagesURLStrings = [String]()
        if let imgArr = data.goodsGalleryUrls {
            for item in imgArr {
                imagesURLStrings.append(item as! String)
            }
//            imagesURLStrings = imgArr.components(separatedBy: ",")
        } else {
            imagesURLStrings = [data.goodsImageUrl!]
        }
        swiper.imagePaths = imagesURLStrings
        // 是否自动滚动
        swiper.autoScroll = false
        // 是否无限循环，此属性修改了就不存在轮播的意义了
        swiper.infiniteLoop = true
        // 滚动间隔时间(默认为2秒)
//        swiper.autoScrollTimeInterval = 3.0
        // 等待数据状态显示的占位图
        swiper.placeHolderImage = UIImage(named: "loading")
        // 如果没有数据的时候，使用的封面图
        swiper.coverImage = UIImage(named: "loading")
        // 设置图片显示方式=UIImageView的ContentMode
        swiper.imageViewContentMode = .scaleToFill
        // 设置滚动方向（ vertical || horizontal ）
        swiper.scrollDirection = .horizontal
        // 设置当前PageControl的样式 (.none, .system, .fill, .pill, .snake)
        swiper.customPageControlStyle = .snake
        // 非.system的状态下，设置PageControl的tintColor
        swiper.customPageControlInActiveTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
        // 设置.system系统的UIPageControl当前显示的颜色
        swiper.pageControlCurrentPageColor = .clear
        // 非.system的状态下，设置PageControl的间距(默认为8.0)
        swiper.customPageControlIndicatorPadding = 8.0
        // 设置PageControl的位置 (.left, .right 默认为.center)
        swiper.pageControlPosition = .center
        // 背景色
        swiper.backgroundColor = .white
        // 添加到view
        detailbody.addSubview(swiper)
        allHeight += Int(kScreenW)
        
        // --------宝贝信息--------
        let goodsInfo = UIView()
        goodsInfo.backgroundColor = .white
        goodsInfo.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.width = YGValue(kScreenW)
            layout.padding = 10
        }
        detailbody.addSubview(goodsInfo)
        allHeight += 20
        // 宝贝标题
        let goodsName =  IDLabel.init()
        goodsName.font = FontSize(16)
        goodsName.text = data.goodsName!
        let titleH = getLabHeigh(labelStr: data.goodsName!, font: FontSize(16), width: kScreenW - 20) + 2
        allHeight += Int(titleH)
        goodsName.numberOfLines = 0
        goodsName.id_canCopy = true
        goodsName.textColor = UIColor.black
        goodsName.id_setupAttbutImage(img: UIImage(named: "pdd-icon")!, index: 0)
        let style=NSMutableParagraphStyle.init()
        style.lineSpacing = 10
        goodsName.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 20)
            layout.height = YGValue(titleH)
        }
        goodsInfo.addSubview(goodsName)
        // 宝贝价格
        let goodsPrice = UIView()
        goodsPrice.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.marginTop = 10
        }
        goodsInfo.addSubview(goodsPrice)
        allHeight += 58
        //  左
        let priceLeft = UIView()
        priceLeft.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
        }
        goodsPrice.addSubview(priceLeft)
        // 价格
        let priceNum = UIView()
        priceNum.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        priceLeft.addSubview(priceNum)
        let priceTag = UILabel()
        priceTag.text = "券后价"
        priceTag.layer.borderColor = colorwithRGBA(247,51,47,1).cgColor
        priceTag.layer.borderWidth = 1
        priceTag.layer.cornerRadius = 3
        priceTag.textColor = colorwithRGBA(247,51,47,1)
        priceTag.font = FontSize(12)
        priceTag.textAlignment = .center
        priceTag.configureLayout { (layout) in
            layout.isEnabled = true
            layout.paddingLeft = 5
            layout.paddingRight = 5
            layout.height = 18
        }
        priceNum.addSubview(priceTag)
        let nowPrice = UILabel()
        let newPrice = (Commons.strToDou(data.minGroupPrice!) - Commons.strToDou(data.couponDiscount!))/100.00
        nowPrice.text = "¥\(newPrice)"
        nowPrice.textColor = colorwithRGBA(247,51,47,1)
        nowPrice.font = FontSize(22)
        nowPrice.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginLeft = 5
            layout.marginRight = 5
        }
        priceNum.addSubview(nowPrice)
        let oldPrice = UILabel()
        oldPrice.font = FontSize(12)
        oldPrice.textColor = colorwithRGBA(150,150,150,1)
        oldPrice.configureLayout { (layout) in
            layout.isEnabled = true
            layout.alignSelf = .flexEnd
            layout.marginBottom = 3
        }
        let priceString = NSMutableAttributedString.init(string: "¥\(Commons.strToDou(data.minGroupPrice!)/100.00)")
        priceString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: priceString.length))
        oldPrice.attributedText = priceString
        priceNum.addSubview(oldPrice)
        // 销量
        let salesBox = UIView()
        salesBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.marginTop = 5
        }
        priceLeft.addSubview(salesBox)
        let sales = UILabel()
        sales.text = "\(data.salesTip!)人已买"
        sales.font = FontSize(12)
        sales.textColor = colorwithRGBA(100,100,100,1)
        sales.configureLayout { (layout) in
            layout.isEnabled = true
        }
        salesBox.addSubview(sales)
//        let addr = UILabel()
//        addr.text = "广东广州"
//        addr.font = FontSize(12)
//        addr.textColor = colorwithRGBA(100,100,100,1)
//        addr.configureLayout { (layout) in
//            layout.isEnabled = true
//            layout.marginLeft = 20
//        }
//        salesBox.addSubview(addr)
        // 右
        let priceRight = UILabel()
        if isShow == 0 {
            priceRight.isHidden = true
        }
        let tkmoney = newPrice * Commons.strToDou(data.promotionRate!)/1000.00
        let commission = tkmoney * Commons.getScale()
        priceRight.text = "预估收益¥\(String(format:"%.2f",commission))"
        priceRight.layer.borderColor = colorwithRGBA(247,51,47,1).cgColor
        priceRight.layer.borderWidth = 1
        priceRight.layer.cornerRadius = 3
        priceRight.textColor = colorwithRGBA(247,51,47,1)
        priceRight.font = FontSize(14)
        priceRight.textAlignment = .center
        priceRight.configureLayout { (layout) in
            layout.isEnabled = true
            layout.paddingLeft = 8
            layout.paddingRight = 8
            layout.height = 24
        }
        goodsPrice.addSubview(priceRight)
        // 升级团长
        let upgrade = UIView()
        if isShow == 0 {
            upgrade.isHidden = true
        }
        upgrade.backgroundColor = colorwithRGBA(247,247,247,1)
        upgrade.layer.cornerRadius = 3
        upgrade.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.width = YGValue(kScreenW - 20)
            layout.height = 26
            layout.paddingLeft = 10
            layout.paddingRight = 10
            layout.marginTop = 10
        }
        var memberStatus = 1
        let info = UserDefaults.getInfo()
        if info["id"] as! String != "" {
            memberStatus = Int(UserDefaults.getInfo()["memberStatus"] as! String)!
        }
        if memberStatus < 3 {
            goodsInfo.addSubview(upgrade)
            allHeight += 36
        }
        let upgradeText = UILabel()
        var member = "团队长"
        if memberStatus == 2 {
            member == "合作伙伴"
        }
        upgradeText.text = "升级\(member)，即可获得更高佣金哦～"
        upgradeText.textColor = colorwithRGBA(230,153,49,1)
        upgradeText.font = FontSize(12)
        upgradeText.configureLayout { (layout) in
            layout.isEnabled = true
        }
        upgrade.addSubview(upgradeText)
        let upgradeBtn = UIView()
        
        upgradeBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        
        upgrade.addSubview(upgradeBtn)
        let upgradeBtnText = UILabel()
        upgradeBtnText.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(pushMember))
        upgradeBtnText.addGestureRecognizer(tap)
        upgradeBtnText.text = "立即升级"
        upgradeBtnText.textColor = colorwithRGBA(230,153,49,1)
        upgradeBtnText.font = FontSize(12)
        upgradeBtnText.configureLayout { (layout) in
            layout.isEnabled = true
        }
        upgradeBtn.addSubview(upgradeBtnText)
        let upgradeBtnImg = UIImageView(image: UIImage(named: "next"))
        upgradeBtnImg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 12
            layout.height = 12
            layout.marginLeft = 5
        }
        upgradeBtn.addSubview(upgradeBtnImg)
        // 优惠券
//        coupon.addTarget(self, action: #selector(getBatteryLevel), for: .touchUpInside)
        coupon.layer.contents = UIImage(named:"detail-coupon")?.cgImage
        coupon.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 20)
            layout.height = YGValue((kScreenW - 20) * 0.22)
            layout.marginTop = 10
        }
        goodsInfo.addSubview(coupon)
        allHeight += Int((kScreenW - 20) * 0.22) + 10
        // 优惠券内容
        let couponContent = UIView()
        couponContent.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.justifyContent = .center
            layout.width = YGValue((kScreenW - 20) * 0.75)
            layout.height = YGValue((kScreenW - 20) * 0.22)
            layout.paddingTop = 10
            layout.paddingBottom = 10
        }
        coupon.addSubview(couponContent)
        // 优惠券金额
        let couponMoney = UIView()
        couponMoney.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .flexEnd
            layout.paddingLeft = 20
            layout.paddingRight = 20
        }
        couponContent.addSubview(couponMoney)
        let moneyNum = UILabel()
        moneyNum.text = String(format:"%.0f",Commons.strToDou(data.couponDiscount!)/100.00)
        moneyNum.textColor = .white
        moneyNum.font = FontSize(22)
        moneyNum.configureLayout { (layout) in
            layout.isEnabled = true
        }
        couponMoney.addSubview(moneyNum)
        let unit = UILabel()
        unit.text = "元券"
        unit.textColor = .white
        unit.font = FontSize(14)
        unit.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginBottom = 3
            layout.marginLeft = 5
        }
        couponMoney.addSubview(unit)
        // 虚线
        let dottedLine = UIView()
        dottedLine.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.width = 1
            layout.height = YGValue((kScreenW - 20) * 0.22 - 20)
            layout.marginTop = YGValue(((kScreenW - 20) * 0.22 - 20)/20)
        }
        if isShow == 1 {
            couponContent.addSubview(dottedLine)
        }
        
        for _ in 1...9 {
            let lineItem = UIView()
            lineItem.backgroundColor = .white
            lineItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = 1
                layout.height = YGValue(((kScreenW - 20) * 0.22 - 20)/20)
                layout.marginBottom = YGValue(((kScreenW - 20) * 0.22 - 20)/20)
            }
            dottedLine.addSubview(lineItem)
        }
        // 分享所得
        let benefit = UIView()
        benefit.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        if isShow == 1 {
            couponContent.addSubview(benefit)
        }
        let shareMoney = UILabel()
        shareMoney.text = "预估收益\(String(format:"%.2f",commission))元"
        shareMoney.textColor = .white
        shareMoney.font = FontSize(14)
        shareMoney.configureLayout { (layout) in
            layout.isEnabled = true
        }
        benefit.addSubview(shareMoney)
        let allMoney = Commons.strToDou(data.couponDiscount!)/100.00 + commission
        let buyMoney = UILabel()
        buyMoney.text = "领券购买省\(String(format:"%.2f",allMoney))元"
        buyMoney.textColor = .white
        buyMoney.font = FontSize(14)
        buyMoney.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginTop = 10
        }
        benefit.addSubview(buyMoney)
        
        
        //-------- 店铺信息 --------
        let shopInfo = UIView()
        shopInfo.backgroundColor = .white
        shopInfo.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.width = YGValue(kScreenW)
            layout.marginTop = 10
        }
        if isShow == 1 {
            detailbody.addSubview(shopInfo)
            allHeight += 120
        }
        // 基本信息
        let shopInfo1 = UIView()
        shopInfo1.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.width = YGValue(kScreenW)
            layout.height = 80
            layout.padding = 10
        }
        shopInfo.addSubview(shopInfo1)
        
        shopAvatar.layer.cornerRadius = 30
        shopAvatar.layer.masksToBounds = true
        shopAvatar.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.width = 60
            layout.height = 60
            layout.marginRight = 10
        }
        shopInfo1.addSubview(shopAvatar)
        let shopInfoR = UIView()
        shopInfoR.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.justifyContent = .center
            layout.width = YGValue(kScreenW - 90)
            layout.height = 60
        }
        shopInfo1.addSubview(shopInfoR)
        let shopNameBox = UIView()
        shopNameBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.justifyContent = .spaceBetween
            layout.width = YGValue(kScreenW - 90)
            layout.height = 30
            layout.marginBottom = 10
        }
        shopInfoR.addSubview(shopNameBox)
        let shopName = UILabel()
        shopName.text = data.mallName!
        shopName.font = FontSize(14)
        shopName.configureLayout { (layout) in
            layout.isEnabled = true
        }
        shopNameBox.addSubview(shopName)
//        allShopBtn.configureLayout { (layout) in
//            layout.isEnabled = true
//            layout.flexDirection = .row
//            layout.alignItems = .center
//        }
//        shopNameBox.addSubview(allShopBtn)
//        let shopBtnLabel = UILabel()
//        shopBtnLabel.text = "全部店铺优惠"
//        shopBtnLabel.font = FontSize(12)
//        shopBtnLabel.textAlignment = .center
//        shopBtnLabel.backgroundColor = colorwithRGBA(247,247,247,1)
//        shopBtnLabel.layer.cornerRadius = 10
//        shopBtnLabel.layer.masksToBounds = true
//        shopBtnLabel.configureLayout { (layout) in
//            layout.isEnabled = true
//            layout.height = 20
//            layout.paddingLeft = 10
//            layout.paddingRight = 10
//        }
//        allShopBtn.addSubview(shopBtnLabel)
//        let shopBtnImg = UIImageView(image: UIImage(named: "arrow-black"))
//        shopBtnImg.configureLayout { (layout) in
//            layout.isEnabled = true
//            layout.height = 14
//            layout.width = 7
//            layout.marginLeft = 5
//        }
//        allShopBtn.addSubview(shopBtnImg)
        // 店铺3项评分
        let grade = UIView()
        grade.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            //            layout.justifyContent = .spaceAround
        }
        shopInfoR.addSubview(grade)
        let gradeList = [
            [
                "name": "宝贝描述",
                "grade": data.descTxt!
            ],
            [
                "name": "卖家服务",
                "grade": data.servTxt!
            ],
            [
                "name": "物流服务",
                "grade": data.lgstTxt!
            ],
        ]
        for item in gradeList {
            let gradeItem = UILabel()
            gradeItem.text = "\(item["name"]!):\(item["grade"]!)"
            gradeItem.font = FontSize(12)
            gradeItem.textColor = colorwithRGBA(100,100,100,1)
            gradeItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.marginRight = 15
            }
            grade.addSubview(gradeItem)
        }
        // shopInfo2
        let shopInfo2 = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 0))
        shopInfo2.addBorder(side: .top, thickness: 0.5, color: colorwithRGBA(230,230,230,1))
        shopInfo2.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.padding = 10
            layout.height = 30
        }
        shopInfo.addSubview(shopInfo2)
        let yesList = ["正品保证", "极速退货", "极速退款", "赠运费险"]
        for item in yesList {
            let yesItem = UIView()
            yesItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.flexDirection = .row
                layout.alignItems = .center
                layout.marginRight = 15
            }
            shopInfo2.addSubview(yesItem)
            let yesImg = UIImageView(image: UIImage(named: "yes"))
            yesImg.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = 12
                layout.height = 12
                layout.marginRight = 5
            }
            yesItem.addSubview(yesImg)
            let yesLabel = UILabel()
            yesLabel.text = item
            yesLabel.font = FontSize(12)
            yesLabel.textColor = colorwithRGBA(100,100,100,1)
            yesLabel.configureLayout { (layout) in
                layout.isEnabled = true
            }
            yesItem.addSubview(yesLabel)
        }
        
        // 推荐语
        let descView = UIView()
        descView.backgroundColor = .white
        descView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginTop = 10
            layout.padding = 15
            layout.flexDirection = .row
            layout.alignItems = .flexStart
        }
        detailbody.addSubview(descView)
        let descKey = UILabel()
        descKey.text = "【推荐语】"
        descKey.font = FontSize(14)
        descKey.textColor = kMainTextColor
        descKey.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 100
        }
        descView.addSubview(descKey)
        let descContent = UILabel()
        descContent.numberOfLines = 0
        descContent.textColor = kGrayTextColor
        descContent.text = data.goodsDesc!
        descContent.font = FontSize(14)
        descContent.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 130)
        }
        descView.addSubview(descContent)
        
        allHeight += Int(getLabHeigh(labelStr: data.goodsDesc!, font: FontSize(14), width: kScreenW - 130)) + 40
        
        
        detailbody.yoga.applyLayout(preservingOrigin: true)
        detailbody.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight), right: CGFloat(0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 渲染店铺头像
    func setShopAvatar (shopAvatarS: String) {
        let url = URL(string: shopAvatarS)!
        let placeholderImage = UIImage(named: "loading")
        self.shopAvatar.af_setImage(withURL: url, placeholderImage: placeholderImage)
    }
    @objc func pushMember(){
        print("触发了")
        navigation?.pushViewController(MemberViewController(), animated: true)
    }
}
