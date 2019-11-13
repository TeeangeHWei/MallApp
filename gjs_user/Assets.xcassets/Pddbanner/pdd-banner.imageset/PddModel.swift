//
//  PddModel.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/11.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

struct PddtitleModel : HandyJSON{
    var optName : String?
    var optId : String?
}

struct themelist : HandyJSON{
    init(){}
    var imageUrl : String?
    var name : String?
    var id : Int?
}

struct shotthemelist : HandyJSON{
    var themeList : [themelist]?
    init() {}
}

struct pddGoodsItem : HandyJSON{
    
    init() {}
    
    var goodsId : String?
    // 商品图片
    var goodsThumbnailUrl : String?
    // 商品名
    var goodsName : String?
    // 商城名
    var mallName : String?
    // 原价
    var minGroupPrice : String?
    // 优惠券金额
    var couponDiscount : String?
    // 佣金比例
    var promotionRate : String?
    // 购买人数
    var salesTip : String?
    
}


struct pddGoodsItemList : HandyJSON {
    
    var list : [pddGoodsItem]?
    var goodsList : [pddGoodsItem]?
    
    
    init() {}
}

