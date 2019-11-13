//
//  detailModel.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/5.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

struct PddDetailData : HandyJSON {
    
    // 商品id
    var goodsId : String?
    // 商品图片
    var goodsImageUrl : String?
    // 店铺类型
    var shoptype : String?
    // 商品标题
    var goodsName : String?
    // 原价
    var minGroupPrice : String?
    // 销量
    var salesTip : String?
    // 佣金比例
    var promotionRate : String?
    // 优惠券金额
    var couponDiscount : String?
    // 店铺名
    var mallName : String?
    // 店铺ID
    var shopid : String?
    // 多图
    var goodsGalleryUrls : [String]?
    // 推荐语
    var goodsDesc : String?
    // 描述分
    var descTxt : String?
    // 服务分
    var servTxt : String?
    // 物流分
    var lgstTxt : String?
    
    
    init() {}
}

struct PddDetailData2 : HandyJSON {
    
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
