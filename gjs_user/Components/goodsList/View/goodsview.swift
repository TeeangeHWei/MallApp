//
//  goodsview.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/4.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class goodsview: UIView {

    fileprivate var goodsImg : UIImageView!
    fileprivate var goodsName : UILabel!
    fileprivate var shopname : UILabel!
    fileprivate var itemendprice : UILabel!
    fileprivate var itemprice : UILabel!
    fileprivate var couponmoney : UILabel!
    fileprivate var member : UILabel!
    fileprivate var commander : UILabel!
    fileprivate var itemsale : UILabel!
    fileprivate var typeImg = UIImageView()
    fileprivate var typeLabel = UILabel()
    fileprivate var navC : UINavigationController?
    let isShow = UserDefaults.getIsShow()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 单个商品
        let goodsItem = self
        goodsItem.backgroundColor = .white
        goodsItem.layer.cornerRadius = 10
        goodsItem.isUserInteractionEnabled = true
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
        self.goodsImg = goodsImg
        
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
        if isShow == 1 {
            typeImg.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(14)
                layout.height = YGValue(14)
                layout.marginRight = 4
            }
            goodsName.addSubview(typeImg)
        } else {
            typeLabel.textAlignment = .center
            typeLabel.textColor = .white
            typeLabel.font = FontSize(10)
            typeLabel.layer.cornerRadius = 3
            typeLabel.layer.masksToBounds = true
            typeLabel.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(32)
                layout.height = YGValue(16)
                layout.marginRight = 4
            }
            goodsName.addSubview(typeLabel)
        }
        let nameLabel = UILabel()
        //        nameLabel.text = data.itemtitle
        nameLabel.font = FontSize(14)
        nameLabel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(leftW - 18)
            layout.height = YGValue(22)
            layout.marginRight = 4
        }
        goodsName.addSubview(nameLabel)
        self.goodsName = nameLabel
        
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
        //        shopName.text = data.shopname
        shopName.textColor = .gray
        shopName.font = FontSize(12)
        shopName.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(leftW - 100)
            layout.height = YGValue(22)
        }
        shop.addSubview(shopName)
        self.shopname = shopName
        
        let sales = UILabel()
        //        sales.text = data.itemsale
        sales.textColor = .gray
        sales.font = FontSize(12)
        sales.textAlignment = .right
        sales.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(100)
            layout.height = YGValue(22)
        }
        shop.addSubview(sales)
        self.itemsale = sales
        
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
            layout.width = YGValue(100)
            layout.height = YGValue(26)
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
            layout.marginRight = 5
            layout.marginBottom = 2
        }
        // 优惠价
        price.addSubview(unit)
        let num = UILabel()
        //        num.text = data.itemendprice
        num.textColor = .red
        num.font = FontSize(18)
        num.configureLayout { (layout) in
            layout.width = YGValue(80)
            layout.height = YGValue(26)
            layout.top = YGValue(5)
            layout.right = YGValue(5)
            layout.bottom = YGValue(3)
            layout.left = YGValue(3)
            layout.isEnabled = true
        }
        price.addSubview(num)
        self.itemendprice = num
        
        
        // 旧价
        let oldPrice = UILabel()
        oldPrice.font = FontSize(12)
        oldPrice.textColor = colorwithRGBA(150,150,150,1)
        oldPrice.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(80)
            layout.height = YGValue(26)
            layout.marginLeft = 5
            layout.bottom = -4
            
        }
        
        price.addSubview(oldPrice)
        self.itemprice = oldPrice
        
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
        couponNum.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 54
            layout.height = 18
        }
        coupon.addSubview(couponNum)
        self.couponmoney = couponNum
        
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
        
       
       
        // 会员赚
        let member = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        member.layer.cornerRadius = 3
        member.font = FontSize(10)
        member.textColor = .white
        
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
        self.member = member
        // 团长赚
        let commander = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        commander.layer.cornerRadius = 3
        commander.font = FontSize(10)
        commander.textColor = .white
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
        self.commander = commander
        profit.addSubview(commander)
        goodsItem.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 赋值操作
    func getDataToView(_ data: goodsItem){
        // 获取会员等级，获取不到按超级会员算
        self.tag = Int(data.itemid!)!

        var memberStatus = 1
        let info = UserDefaults.getInfo()
        if info["id"] as! String != "" {
            memberStatus = Int(UserDefaults.getInfo()["memberStatus"] as! String)!
        }
        //// 判断会员赚
        if memberStatus == 1 {
            let commission = Commons.strToDou(data.tkmoney!) * Commons.vip1Scale()
            member.text = "会员赚¥\(String(format:"%.2f",commission))"
        } else {
            let commission = Commons.strToDou(data.tkmoney!) * Commons.vip2Scale()
            member.text = "团长赚¥\(String(format:"%.2f",commission))"
        }
        // 判断团长赚
        if memberStatus == 1 {
            let commission = Commons.strToDou(data.tkmoney!) * Commons.vip2Scale()
            commander.text = "团长赚¥\(String(format:"%.2f",commission))"
        } else {
            let commission = Commons.strToDou(data.tkmoney!) * Commons.vip3Scale()
            commander.text = "伙伴赚¥\(String(format:"%.2f",commission))"
        }
        let imgUrl = URL.init(string: data.itempic ?? "")
        self.goodsImg.kf.setImage(with: imgUrl)
        self.goodsName.text = data.itemtitle
        self.shopname.text = data.shopname
        self.itemendprice.text = data.itemendprice
        
        self.couponmoney.text = data.couponmoney! + "元券"
        
        self.itemsale.text = data.itemsale! + "人已买"
        let priceString = NSMutableAttributedString.init(string: data.itemprice!)
        priceString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: priceString.length))
        self.itemprice.attributedText = priceString
        
        var icon = UIImage.init(named: "taobao")
        if data.shoptype == "B" {
            icon = UIImage.init(named: "tianmao")
            typeLabel.text = "天猫"
            typeLabel.backgroundColor = colorwithRGBA(255, 1, 55, 1)
        } else {
            typeLabel.text = "淘宝"
            typeLabel.backgroundColor = colorwithRGBA(255, 80, 0, 1)
        }
        self.typeImg.image = icon
    }
//    @objc func toDetail (sender : UITapGestureRecognizer) {
//        detailId = sender.view?.tag
//        self.navC!.pushViewController(DetailController(), animated: true)
//    }

}
