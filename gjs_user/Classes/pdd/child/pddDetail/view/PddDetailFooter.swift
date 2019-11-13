//
//  DetailFooter.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/5.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class PddDetailFooter: UIView {
    
    var detailData : PddDetailData?
    let collectIcon = UIImageView(image: UIImage(named: "collection_1"))
    let collectLabel = UILabel()
    var collectStatus : Bool = false
    var isLoading : Bool = false
    let shareBtn = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.5 - 50, height: 60))
    let getBtn = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.5 - 50, height: 60))
    var navC : UINavigationController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, data: PddDetailData, nav: UINavigationController) {
        self.init(frame: frame)
        self.navC = nav
        let isShow = UserDefaults.getIsShow()
        self.detailData = data
        self.backgroundColor = .white
        self.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.width = YGValue(kScreenW)
            layout.height = 60
        }
        let footerLeft = UIView()
        footerLeft.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.width = 120
            layout.height = 60
        }
        self.addSubview(footerLeft)
        // 回首页
        let homeBtn = UIButton()
        homeBtn.addTarget(self, action: #selector(jumpToMain), for: .touchUpInside)
        homeBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.justifyContent = .center
            layout.width = 60
            layout.height = 60
        }
        footerLeft.addSubview(homeBtn)
        let homeIcon = UIImageView(image: UIImage(named: "detail-home"))
        homeIcon.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 24
            layout.height = 24
            layout.marginBottom = 5
        }
        homeBtn.addSubview(homeIcon)
        let homeLabel = UILabel()
        homeLabel.text = "首页"
        homeLabel.font = FontSize(14)
        homeLabel.textColor = kLowGrayColor
        homeLabel.configureLayout { (layout) in
            layout.isEnabled = true
        }
        homeBtn.addSubview(homeLabel)
        // 收藏
        let collectBtn = UIButton()
        collectBtn.addTarget(self, action: #selector(collectFunc), for: .touchUpInside)
        collectBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.justifyContent = .center
            layout.width = 60
            layout.height = 60
        }
        footerLeft.addSubview(collectBtn)
        collectIcon.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 24
            layout.height = 24
            layout.marginBottom = 5
        }
        collectBtn.addSubview(collectIcon)
        collectLabel.text = "收藏"
        collectLabel.textAlignment = .center
        collectLabel.font = FontSize(14)
        collectLabel.textColor = kLowGrayColor
        collectLabel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 60
        }
        collectBtn.addSubview(collectLabel)
        
        let footerRight = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW - 120, height: 60))
        footerRight.isUserInteractionEnabled = true
        footerRight.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.width = YGValue(kScreenW - 120)
            layout.height = 60
        }
        self.addSubview(footerRight)
        let colors = [
            colorwithRGBA(237, 183, 113, 1).cgColor,
            colorwithRGBA(247, 218, 178, 1).cgColor
        ]
        shareBtn.isUserInteractionEnabled = true
        shareBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), colors)
        shareBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.justifyContent = .center
            layout.width = YGValue(kScreenW * 0.5 - 60)
            layout.height = 60
        }
        if isShow == 1 {
            footerRight.addSubview(shareBtn)
        }
        let newPrice = (Commons.strToDou(data.minGroupPrice!) - Commons.strToDou(data.couponDiscount!))/100.00
        let tkmoney = newPrice * Commons.strToDou(data.promotionRate!)/1000.00
        let commission = tkmoney * Commons.getScale()
        let shareLabel1 = UILabel()
        shareLabel1.text = "分享"
        shareLabel1.font = FontSize(16)
        shareLabel1.textColor = colorwithRGBA(110, 87, 57, 1)
        shareLabel1.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginBottom = 5
        }
        shareBtn.addSubview(shareLabel1)
        let shareLabel2 = UILabel()
        shareLabel2.text = "(收益\(String(format:"%.2f",commission))元)"
        shareLabel2.font = FontSize(12)
        shareLabel2.textColor = colorwithRGBA(110, 87, 57, 1)
        shareLabel2.configureLayout { (layout) in
            layout.isEnabled = true
        }
        shareBtn.addSubview(shareLabel2)
        // 领券按钮
        var btnWidth = kScreenW * 0.5 - 50
        if isShow == 0 {
            btnWidth = kScreenW - 100
        }
        getBtn.frame = CGRect(x: 0, y: 0, width: btnWidth, height: 60)
        getBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        getBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.justifyContent = .center
            layout.width = YGValue(btnWidth)
            layout.height = 60
        }
        footerRight.addSubview(getBtn)
        let allMoney = Commons.strToDou(data.couponDiscount!)/100.00 + commission
        let getLabel1 = UILabel()
        getLabel1.text = "领券购买"
        getLabel1.font = FontSize(16)
        getLabel1.textColor = .white
        getLabel1.configureLayout { (layout) in
            layout.isEnabled = true
        }
        getBtn.addSubview(getLabel1)
        let getLabel2 = UILabel()
        getLabel2.text = "(省\(String(format:"%.2f",allMoney))元)"
        getLabel2.font = FontSize(12)
        getLabel2.textColor = .white
        getLabel2.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginTop = 5
        }
        if isShow == 1 {
            getBtn.addSubview(getLabel2)
        }
        
        
        self.yoga.applyLayout(preservingOrigin: true)
        
        isCollect()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 判断是否已收藏
    func isCollect () {
        if UserDefaults.getInfo()["id"] as! String == "-1" {
            return
        }
        AlamofireUtil.post(url:"/user/myCollect/isCollect", param: [
            "type" : 2,
            "itemId" : detailData?.goodsId! as! String
        ],
        success:{(res,data) in
            self.collectStatus = data.bool!
            if data.bool! {
                self.collectIcon.image = UIImage(named: "collection_2")
                self.collectLabel.text = "已收藏"
            }
        },
        error:{
                            
        },
        failure:{
                            
        })
    }
    // 回首页
    @objc func jumpToMain (_ btn : UIButton) {
        navC?.popToRootViewController(animated: true)
    }
    // 收藏按钮点击触发事件
    @objc func collectFunc (_ btn : UIButton) {
        if isLoading {
            return
        }
        isLoading = true
        if collectStatus {
            cancelCollect()
        } else {
            collect()
        }
    }
    // 收藏
    func collect () {
        var salesTip = ""
        if Int(detailData!.salesTip!) == nil {
            let saleNum = Commons.stringToNum(Str: detailData!.salesTip!)[0] * 10000
            salesTip = String(saleNum)
        } else {
            salesTip = detailData!.salesTip!
        }
        let newPrice = (Commons.strToDou(detailData!.minGroupPrice!) - Commons.strToDou(detailData!.couponDiscount!))/100.00
        let tkmoney = newPrice * Commons.strToDou(detailData!.promotionRate!)/1000.00
        AlamofireUtil.post(url:"/user/myCollect/addCollect", param: [
            "type" : 2,
            "itemId" : detailData?.goodsId! as! String,
            "itemPic" : detailData?.goodsImageUrl! as! String,
            "shopName" : detailData?.mallName! as! String,
            "itemTitle" : detailData?.goodsName! as! String,
            "itemSale" : salesTip,
            "itemPrice" : detailData?.minGroupPrice! as! String,
            "itemEndPrice" : newPrice,
            "couponMoney" : detailData?.couponDiscount! as! String,
            "money" : tkmoney
        ],
        success:{(res,data) in
            self.isLoading = false
            self.collectStatus = true
//            IDToast.id_show(msg: "收藏成功", success: .success)
            self.collectIcon.image = UIImage(named: "collection_2")
            self.collectLabel.text = "已收藏"
        },
        error:{
            self.isLoading = false
        },
        failure:{
            self.isLoading = false
        })
    }
    // 取消收藏
    func cancelCollect () {
        AlamofireUtil.post(url:"/user/myCollect/cancelCollect", param: [
            "type" : 2,
            "itemId" : detailData?.goodsId! as! String
        ],
        success:{(res,data) in
            self.isLoading = false
            self.collectStatus = false
//            IDToast.id_show(msg: "取消成功", success: .success)
            self.collectIcon.image = UIImage(named: "collection_1")
            self.collectLabel.text = "收藏"
        },
        error:{
            self.isLoading = false
        },
        failure:{
            self.isLoading = false
        })
    }
}
