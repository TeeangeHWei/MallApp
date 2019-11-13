//
//  SearchResultModel.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/15.
//  Copyright © 2019 大杉网络. All rights reserved.
//

struct SearchItem : HandyJSON{
    
    init() {}
    
    // 商品id
    var itemId : String?
    // 商品图片
    var pictUrl : String?
    // 商品名
    var shortTitle : String?
    // 商城名
    var shopTitle : String?
    // 原价
    var zkFinalPrice : String?
    // 优惠券金额
    var couponAmount : String?
    // 佣金比例
    var commissionRate : String?
    // 购买人数
    var volume : String?
    // 淘宝和天猫图标
    var userType : String?
    
}



//var goodslist : [goodsItem] = [goodsItem]()
//
//struct SearchList : HandyJSON {
//
//    var data : [goodsItem]?
//    init() {}
//
//}
