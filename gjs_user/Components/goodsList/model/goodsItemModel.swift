//
//  goodsItemModel.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/3.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

struct goodsItem : HandyJSON{
    
    init() {}
    
    var itemid : String?
    // 商品图片
    var itempic : String?
    // 商品名
    var itemtitle : String?
    // 商城名
    var shopname : String?
    // 优惠价
    var itemendprice : String?
    // 原价
    var itemprice : String?
    // 优惠券金额
    var couponmoney : String?
    // 会员赚
    var tkmoney : String?
    // 购买人数
    var itemsale : String?
    // 淘宝和天猫图标
    var shoptype : String?

    init(_ data : CollectionItem) {
        itemid = data.itemId
        itempic = data.itemPic
        itemtitle = data.itemTitle
        shopname = data.shopName
        itemendprice = data.itemEndPrice
        itemprice = data.itemPrice
        couponmoney = data.couponMoney
        tkmoney = data.money
        itemsale = data.itemSale
        shoptype = data.shopType
    }
}

var goodslist : [goodsItem] = [goodsItem]()

struct goodsItemDataList : HandyJSON {
    
    var data : [goodsItem]?
    
    init() {}
}
