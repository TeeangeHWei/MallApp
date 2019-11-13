//
//  goodsItemView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/13.
//  Copyright © 2019 大杉网络. All rights reserved.
//


@available(iOS 11.0, *)
class GoodsItemView: UIView {
    
    var platformIndex = 0
    var navC : UINavigationController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, data: goodsItem, nav: UINavigationController, platformIndex : Int = 0) {
        self.init(frame: frame)
        self.platformIndex = platformIndex
        navC = nav
        let isShow = UserDefaults.getIsShow()
        // 单个商品
        let goodsItem = self
        goodsItem.tag = Int(data.itemid!)!
        goodsItem.backgroundColor = .white
        goodsItem.layer.cornerRadius = 10
        goodsItem.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.toDetail(sender:)))
        goodsItem.addGestureRecognizer(tap)
        goodsItem.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.width = YGValue(kScreenW - 20)
            layout.height = YGValue(120)
            layout.marginLeft = 10
            layout.marginTop = 10
        }
        // 商品图
        let goodsImg = UIImageView()
        let url = URL.init(string: data.itempic ?? "")
        let placeholderImage = UIImage(named: "loading")
        goodsImg.kf.setImage(with: url, placeholder: placeholderImage)
        goodsImg.layer.cornerRadius = 5
        goodsImg.layer.masksToBounds = true
        goodsImg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(100)
            layout.height = YGValue(100)
            layout.marginLeft = 10
            layout.marginTop = 10
        }
        goodsItem.addSubview(goodsImg)
        // 商品信息
        let leftW = kScreenW - 150
        let goodsInfo = UIView()
        goodsInfo.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.justifyContent = .spaceBetween
            layout.width = YGValue(leftW)
            layout.height = YGValue(100)
            layout.marginLeft = 10
            layout.marginTop = 10
        }
        goodsItem.addSubview(goodsInfo)
        // 商品信息top
        let infoTop = UIView()
        infoTop.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(leftW)
        }
        goodsInfo.addSubview(infoTop)
        // 标题
        let goodsName = UIView()
        goodsName.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.width = YGValue(leftW)
            layout.height = YGValue(22)
        }
        infoTop.addSubview(goodsName)
        // 平台标志
        if isShow == 1 {
            var icon = UIImage()
            let taobao = UIImage(named: "taobao")
            let tianmao = UIImage(named: "tianmao")
            let pdd = UIImage(named: "pdd-icon")
            if platformIndex == 0 {
                if data.shoptype == "B" {
                    icon = tianmao!
                }else{
                    icon = taobao!
                }
            } else {
                icon = pdd!
            }
            let platform = UIImageView(image: icon)
            platform.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(14)
                layout.height = YGValue(14)
                layout.marginRight = 4
            }
            goodsName.addSubview(platform)
        } else {
            let platform = UILabel()
            platform.textColor = .white
            platform.textAlignment = .center
            platform.font = FontSize(10)
            platform.layer.cornerRadius = 3
            platform.layer.masksToBounds = true
            platform.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(32)
                layout.height = YGValue(16)
                layout.marginRight = 4
            }
            if platformIndex == 0 {
                if data.shoptype == "B" {
                    platform.text = "天猫"
                    platform.backgroundColor = colorwithRGBA(255, 1, 55, 1)
                }else{
                    platform.text = "淘宝"
                    platform.backgroundColor = colorwithRGBA(255, 80, 0, 1)
                }
            } else if platformIndex == 1 {
                platform.text = "拼多多"
                platform.backgroundColor = colorwithRGBA(225, 46, 36, 1)
            }
            goodsName.addSubview(platform)
        }
        let nameLabel = UILabel()
        nameLabel.text = data.itemtitle
        nameLabel.font = FontSize(14)
        nameLabel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(leftW - 18)
            layout.height = YGValue(22)
            layout.marginRight = 4
        }
        goodsName.addSubview(nameLabel)
        // 店铺
        let shop = UIView()
        shop.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.justifyContent = .spaceBetween
            layout.width = YGValue(leftW)
            layout.height = YGValue(22)
        }
        infoTop.addSubview(shop)
        let shopName = UILabel()
        shopName.text = data.shopname
        shopName.textColor = .gray
        shopName.font = FontSize(12)
        shopName.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = YGValue(22)
        }
        shop.addSubview(shopName)
        let sales = UILabel()
        sales.textAlignment = .right
        sales.text = "\(data.itemsale!)人已买"
        sales.textColor = .gray
        sales.font = FontSize(12)
        sales.configureLayout { (layout) in
            layout.isEnabled = true
//            layout.minWidth = 60
            layout.height = YGValue(22)
        }
        shop.addSubview(sales)
        // 价格
        let priceBox = UIView()
        priceBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .flexEnd
            layout.justifyContent = .spaceBetween
            layout.width = YGValue(leftW)
            layout.height = YGValue(26)
        }
        infoTop.addSubview(priceBox)
        let price = UIView()
        price.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .flexEnd
        }
        priceBox.addSubview(price)
        let unit = UILabel()
        unit.text = "¥"
        unit.textColor = .red
        unit.font = FontSize(12)
        unit.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginRight = 2
            layout.marginBottom = 2
        }
        // 优惠价
        price.addSubview(unit)
        let num = UILabel()
        num.text = String(format:"%.2f",Commons.strToDou(data.itemendprice!))
        num.textColor = .red
        num.font = FontSize(18)
        num.layer.contents = UIImage(named:"coupon")?.cgImage
        num.configureLayout { (layout) in
            layout.isEnabled = true
        }
        price.addSubview(num)
        // 旧价
        let oldPrice = UILabel()
        oldPrice.font = FontSize(12)
        oldPrice.textColor = colorwithRGBA(150,150,150,1)
        oldPrice.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginLeft = 5
            layout.marginBottom = 3
        }
        let priceString = NSMutableAttributedString.init(string: "¥\(data.itemprice!)")
        priceString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: priceString.length))
        oldPrice.attributedText = priceString
        price.addSubview(oldPrice)
        
        // 优惠券
        let coupon = UIView()
        coupon.layer.contents = UIImage(named:"coupon")?.cgImage
        coupon.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 54
            layout.height = 18
        }
        priceBox.addSubview(coupon)
        let couponNum = UILabel()
        couponNum.textColor = .white
        couponNum.textAlignment = .center
        couponNum.font = FontSize(10)
        couponNum.text = "\(data.couponmoney!)元券"
        couponNum.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 54
            layout.height = 18
        }
        coupon.addSubview(couponNum)
        // 商品信息bottom
        let profit = UIView()
        if isShow == 0 {
            profit.isHidden = true
        }
        profit.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
        }
        goodsInfo.addSubview(profit)
        // 获取会员等级，获取不到按超级会员算
        var memberStatus = 1
        let info = UserDefaults.getInfo()
        if info["id"] as! String != "" {
            memberStatus = Int(UserDefaults.getInfo()["memberStatus"] as! String)!
        }
        // 会员赚
        let member = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        member.layer.cornerRadius = 3
        member.font = FontSize(10)
        member.textColor = .white
        if memberStatus == 1 {
            let commission = Commons.strToDou(data.tkmoney!) * Commons.vip1Scale()
            member.text = "会员赚¥\(String(format:"%.2f",commission))"
        } else {
            let commission = Commons.strToDou(data.tkmoney!) * Commons.vip2Scale()
            member.text = "团长赚¥\(String(format:"%.2f",commission))"
        }
        member.textAlignment = .center
        let memberColors = [colorwithRGBA(250,60,147,1).cgColor,colorwithRGBA(253,133,92,1).cgColor]
        member.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), memberColors)
        member.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.width = 80
            layout.height = 20
            layout.padding = 5
        }
        profit.addSubview(member)
        // 团长赚
        let commander = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        commander.layer.cornerRadius = 3
        commander.font = FontSize(10)
        commander.textColor = .white
        if memberStatus == 1 {
            let commission = Commons.strToDou(data.tkmoney!) * Commons.vip2Scale()
            commander.text = "团长赚¥\(String(format:"%.2f",commission))"
        } else {
            let commission = Commons.strToDou(data.tkmoney!) * Commons.vip3Scale()
            commander.text = "伙伴赚¥\(String(format:"%.2f",commission))"
        }
        commander.textAlignment = .center
        let commanderColors = [colorwithRGBA(83,54,240,1).cgColor,colorwithRGBA(169,103,239,1).cgColor]
        commander.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), commanderColors)
        commander.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.width = 80
            layout.height = 20
            layout.padding = 5
            layout.marginLeft = 5
        }
        profit.addSubview(commander)
        goodsItem.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func toDetail (sender : UITapGestureRecognizer) {
        detailId = sender.view?.tag
        self.navC!.pushViewController(DetailController(), animated: true)
    }
    
}
