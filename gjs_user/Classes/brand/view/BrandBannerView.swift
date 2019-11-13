//
//  brandView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/19.
//  Copyright © 2019 大杉网络. All rights reserved.
//


@available(iOS 11.0, *)
class BrandBannerView: UIScrollView {

    var navC : UINavigationController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, data: [brandItem], nav: UINavigationController) {
        self.init(frame: frame)
        self.navC = nav
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.showsHorizontalScrollIndicator = false
        self.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.width = YGValue(kScreenW - 30)
            layout.height = 160
            layout.marginLeft = 15
            layout.marginTop = 15
        }
        // 第一页
        let brandPage1 = UIView()
        brandPage1.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.flexWrap = .wrap
            layout.width = YGValue(kScreenW - 30)
            layout.height = 160
            layout.padding = 15
        }
        self.addSubview(brandPage1)
        for (index, item) in data.enumerated() {
            setBrandImg(index: index, data: item, father: brandPage1)
        }
//        // 第二页
//        let brandPage2 = UIView()
//        brandPage2.configureLayout { (layout) in
//            layout.isEnabled = true
//            layout.flexDirection = .row
//            layout.flexWrap = .wrap
//            layout.width = YGValue(kScreenW - 30)
//            layout.height = 160
//            layout.padding = 15
//        }
//        self.addSubview(brandPage2)
//        for (index, item) in data.enumerated() {
//            setBrandImg(index: index, data: item, father: brandPage2)
//        }
        
        self.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: 0, right: CGFloat(kScreenW * 2 - 60))
        self.yoga.applyLayout(preservingOrigin: true)
    }
    
    func setBrandImg (index : Int, data : brandItem, father: UIView) {
        let brandImgView = UIButton()
        brandImgView.tag = Int(data.id!)!
        brandImgView.addTarget(self, action: #selector(toGoodsList), for: .touchUpInside)
//        if index != 3 && index != 7 {
//            brandImgView.addBorder(side: .right, thickness: 1, color: klineColor)
//        }
//        if index < 4 {
//            brandImgView.addBorder(side: .bottom, thickness: 1, color: klineColor)
//        }
        brandImgView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.justifyContent = .center
            layout.alignItems = .center
            layout.width = YGValue((kScreenW - 60) * 0.25)
            layout.height = 65
        }
        father.addSubview(brandImgView)
        let brandImg = UIImageView()
        brandImg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue((kScreenW - 60) * 0.25)
            layout.height = YGValue((kScreenW - 60) * 0.25 * 0.52)
        }
        var url : URL?
        if let logo = data.brand_logo {
            url = URL(string: logo)!
        }
        let placeholderImage = UIImage(named: "loading")
//        brandImg.af_setImage(withURL: url!, placeholderImage: placeholderImage)
        brandImg.kf.setImage(with: url, placeholder: placeholderImage)
        brandImgView.addSubview(brandImg)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func toGoodsList (_ btn : UIButton) {
        brandId = btn.tag
        self.navC?.pushViewController(BrandGoodsListController(), animated: true)
    }
}
