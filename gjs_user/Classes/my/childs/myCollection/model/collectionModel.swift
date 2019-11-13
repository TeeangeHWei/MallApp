//
//  collectionModel.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/11.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

struct CollectionItem : HandyJSON{
    
    init() {}
    
    // 收藏id
    var id : String?
    // 商品id
    var itemId : String?
    // 商品图片
    var itemPic : String?
    // 商品名
    var itemTitle : String?
    // 商城名
    var shopName : String?
    // 优惠价
    var itemEndPrice : String?
    // 原价
    var itemPrice : String?
    // 优惠券金额
    var couponMoney : String?
    // 会员赚
    var money : String?
    // 购买人数
    var itemSale : String?
    // 淘宝和天猫图标
    var shopType : String?
    
    
    init(_ data: SearchItem) {
        itemId = data.itemId
        itemPic = data.pictUrl
        itemTitle = data.shortTitle
        shopName = data.shopTitle
        var zkFinalPrice : Double = 0.00
        var couponAmount : Double = 0.00
        if let zkFinalPrice1 = data.zkFinalPrice {
            zkFinalPrice = Commons.strToDou(zkFinalPrice1)
        }
        if let couponAmount1 = data.couponAmount {
            couponAmount = Commons.strToDou(couponAmount1)
        }
        itemEndPrice = String(zkFinalPrice - couponAmount)
        itemPrice = data.zkFinalPrice
        couponMoney = data.couponAmount ?? "0"
        let tkMoney1 = (zkFinalPrice - couponAmount) * Commons.strToDou(data.commissionRate!) * 0.0001
        money = String(tkMoney1)
        itemSale = data.volume
        shopType = data.userType! == "1" ? "B" : "C"
    }
}

struct CollectionList : HandyJSON {
    
    var list : [CollectionItem]?
    
    init() {}
    
}
