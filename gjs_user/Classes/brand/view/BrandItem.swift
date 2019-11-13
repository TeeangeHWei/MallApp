//
//  BrandList.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/19.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class BrandItem: UIView {

    var navC : UINavigationController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    // (kScreenW - 60) * 0.25 * 0.52 + 72 + (kScreenW - 70)/3
    convenience init(frame: CGRect, data: brandItem, nav: UINavigationController) {
        self.init(frame: frame)
        self.navC = nav
        self.backgroundColor = colorwithRGBA(251, 122, 30, 1)
        self.layer.cornerRadius = 5
//        self.layer.masksToBounds = true
        self.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 30)
            layout.marginLeft = 15
        }
        let titleView = UIView()
        titleView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 30)
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.padding = 10
        }
        self.addSubview(titleView)
        let logo = UIImageView()
        logo.layer.cornerRadius = 5
        logo.layer.masksToBounds = true
        logo.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue((kScreenW - 60) * 0.25)
            layout.height = YGValue((kScreenW - 60) * 0.25 * 0.52)
        }
        var url : URL?
        if let logo = data.brand_logo {
            url = URL(string: logo)!
        }
        let placeholderImage = UIImage(named: "loading")
        logo.af_setImage(withURL: url!, placeholderImage: placeholderImage)
        titleView.addSubview(logo)
        let nameView = UIView()
        nameView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.justifyContent = .center
        }
        titleView.addSubview(nameView)
        let brandName = UILabel()
        brandName.text = data.fq_brand_name!
        brandName.font = FontSize(14)
        brandName.textColor = .white
        brandName.configureLayout { (layout) in
            layout.isEnabled = true
        }
        nameView.addSubview(brandName)
        let explain = UILabel()
        explain.text = "--品牌直销--"
        explain.font = FontSize(14)
        explain.textColor = .white
        explain.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginTop = 5
        }
        nameView.addSubview(explain)
        // 更多
        let moreBtn = UIButton()
        moreBtn.tag = Int(data.id!)!
        moreBtn.addTarget(self, action: #selector(toGoodsList), for: .touchUpInside)
        moreBtn.backgroundColor = .clear
        moreBtn.layer.cornerRadius = 12
        moreBtn.layer.borderColor = UIColor.white.cgColor
        moreBtn.layer.borderWidth = 1
        moreBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .center
            layout.alignItems = .center
            layout.width = 70
            layout.height = 24
        }
        titleView.addSubview(moreBtn)
        let moreLabel = UILabel()
        moreLabel.text = "更多"
        moreLabel.font = FontSize(14)
        moreLabel.textColor = .white
        moreLabel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginRight = 5
        }
        moreBtn.addSubview(moreLabel)
        let mareArrow = UIImageView(image: UIImage(named: "arrow-white"))
        mareArrow.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 14
            layout.width = 7
        }
        moreBtn.addSubview(mareArrow)
        // 品牌商品
        let goodsList = UIView()
        goodsList.backgroundColor = .white
        goodsList.layer.cornerRadius = 5
        goodsList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.width = YGValue(kScreenW - 30)
            layout.padding = 10
            layout.paddingRight = 0
        }
        self.addSubview(goodsList)
        for item in data.item! {
            let goodsItem = UIButton()
            goodsItem.tag = Int(item.itemid!)!
            goodsItem.addTarget(self, action: #selector(toDetail), for: .touchUpInside)
            goodsItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue((kScreenW - 70)/3)
                layout.marginRight = 10
            }
            goodsList.addSubview(goodsItem)
            let goodsImg = UIImageView()
            goodsImg.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue((kScreenW - 70)/3)
                layout.height = YGValue((kScreenW - 70)/3)
                layout.marginBottom = 3
            }
            var url : URL?
            if let imgUrl = item.itempic {
                url = URL(string: imgUrl)!
            }
            let placeholderImage = UIImage(named: "loading")
            goodsImg.af_setImage(withURL: url!, placeholderImage: placeholderImage)
            goodsItem.addSubview(goodsImg)
            let goodsInfo = UIView()
            goodsInfo.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue((kScreenW - 70)/3)
            }
            goodsItem.addSubview(goodsInfo)
            let goodsTitle = UILabel()
            goodsTitle.text = item.itemtitle!
            goodsTitle.font = FontSize(14)
            goodsTitle.textColor = kMainTextColor
            goodsTitle.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue((kScreenW - 70)/3)
            }
            goodsInfo.addSubview(goodsTitle)
            // 价格
            let goodsPrice = UIView()
            goodsPrice.configureLayout { (layout) in
                layout.isEnabled = true
                layout.flexDirection = .row
                layout.justifyContent = .spaceBetween
                layout.width = YGValue((kScreenW - 70)/3)
            }
            goodsInfo.addSubview(goodsPrice)
            // 优惠价
            let nowPrice = UILabel()
            nowPrice.text = "\(item.itemendprice!)元"
            nowPrice.font = FontSize(12)
            nowPrice.textColor = kLowOrangeColor
            nowPrice.configureLayout { (layout) in
                layout.isEnabled = true
            }
            goodsPrice.addSubview(nowPrice)
            // 原价
            let oldPrice = UILabel()
            oldPrice.font = FontSize(12)
            oldPrice.textColor = kLowGrayColor
            oldPrice.configureLayout { (layout) in
                layout.isEnabled = true
            }
            let priceString = NSMutableAttributedString.init(string: "¥\(item.itemprice!)")
            priceString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: priceString.length))
            oldPrice.attributedText = priceString
            goodsPrice.addSubview(oldPrice)
        }
        
        
        
        self.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func toDetail (_ btn : UIButton) {
        detailId = btn.tag
        self.navC!.pushViewController(DetailController(), animated: true)
    }
    
    @objc func toGoodsList (_ btn : UIButton) {
        brandId = btn.tag
        self.navC?.pushViewController(BrandGoodsListController(), animated: true)
    }
    
}
