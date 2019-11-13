//
//  detailModel.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/5.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

struct DetailData : HandyJSON {
    
    // 商品id
    var itemid : String?
    // 商品图片
    var itempic : String?
    // 店铺类型
    var shoptype : String?
    // 商品标题
    var itemtitle : String?
    // 券后价
    var itemendprice : String?
    // 原价
    var itemprice : String?
    // 销量
    var itemsale : String?
    // 佣金
    var tkmoney : String?
    // 优惠券金额
    var couponmoney : String?
    // 店铺名
    var shopname : String?
    // 店铺ID
    var shopid : String?
    // 多图
    var taobao_image : String?
    // 推荐语
    var itemdesc : String?
    
    
    init() {}
}

struct DetailData2 : HandyJSON {
    
    // 商品详情图
    var detailPics : String?
    // 宝贝描述
    var dsrScore : String?
    // 卖家服务
    var serviceScore : String?
    // 物流服务
    var shipScore : String?
    
    init() {}
}
