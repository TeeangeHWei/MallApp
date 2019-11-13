//
//  GoodsCardView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/21.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class GoodsCardView: UIView {

    var navC : UINavigationController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, data: goodsItem, nav: UINavigationController) {
        self.init(frame: frame)
        navC = nav
        
        let width = frame.size.width
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.backgroundColor = .white
        self.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(width)
            layout.marginBottom = 10
        }
        // 宝贝图
        let goodsImg = UIImageView()
#warning("强制解包必须判断非空，不然会崩溃")
        let url = URL(string: data.itempic ?? "")
        let placeholderImage = UIImage(named: "loading")
//        goodsImg.af_setImage(withURL: url, placeholderImage: placeholderImage)
        goodsImg.kf.setImage(with: url, placeholder: placeholderImage)
        goodsImg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(width)
            layout.height = YGValue(width)
        }
        self.addSubview(goodsImg)
        // 宝贝信息
        let goodsInfo = UIView()
        goodsInfo.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(width)
            layout.padding = 5
        }
        self.addSubview(goodsInfo)
        // 宝贝标题
        let goodsName = UIView()
        goodsName.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.width = YGValue(width - 10)
            layout.height = YGValue(22)
        }
        goodsInfo.addSubview(goodsName)
        var icon = UIImage()
        let taobao = UIImage(named: "taobao")
        let tianmao = UIImage(named: "tianmao")
        if data.shoptype == "B" {
            icon = tianmao!
        }else{
            icon = taobao!
        }
        let platform = UIImageView(image: icon)
        platform.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(14)
            layout.height = YGValue(14)
            layout.marginRight = 4
        }
        goodsName.addSubview(platform)
        let nameLabel = UILabel()
        nameLabel.text = data.itemtitle
        nameLabel.font = FontSize(14)
        nameLabel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(width - 28)
            layout.height = YGValue(22)
            layout.marginRight = 4
        }
        goodsName.addSubview(nameLabel)
        // 价格
        let priceBox = UIView()
        priceBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .flexEnd
            layout.justifyContent = .spaceBetween
            layout.width = YGValue(width - 10)
            layout.height = YGValue(20)
        }
        goodsInfo.addSubview(priceBox)
        // 优惠价
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
        unit.font = FontSize(10)
        unit.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginRight = 2
            layout.marginBottom = 2
        }
        price.addSubview(unit)
        let num = UILabel()
        num.text = String(format:"%.2f",Commons.strToDou(data.itemendprice!))
        num.textColor = .red
        num.font = FontSize(16)
        num.layer.contents = UIImage(named:"coupon")?.cgImage
        num.configureLayout { (layout) in
            layout.isEnabled = true
        }
        price.addSubview(num)
        // 旧价
        let oldPrice = UILabel()
        oldPrice.font = FontSize(10)
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
            layout.width = 42
            layout.height = 14
        }
        priceBox.addSubview(coupon)
        let couponNum = UILabel()
        couponNum.textColor = .white
        couponNum.textAlignment = .center
        couponNum.font = FontSize(10)
        couponNum.text = "\(data.couponmoney!)元券"
        couponNum.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 42
            layout.height = 14
        }
        coupon.addSubview(couponNum)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
