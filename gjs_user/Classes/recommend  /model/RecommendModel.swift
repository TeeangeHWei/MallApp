//
//  RecommendModel.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/7.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

struct RecommendItem : HandyJSON{
    
    init() {}
    
    // 宝贝id
    var itemid : String?
    // 文案
    var copy_content : String?
    // 券后价
    var itemendprice : String?
    // 宝贝图片
    var itempic : [String]?
    // 发布时间
    var show_time : String?
    // 转发次数
    var dummy_click_statistics : String?
    // 商品标题
    var itemtitle : String?
    // 原价
    var itemprice : String?
    // 优惠券金额
    var couponmoney : String?
    
    init(data : DetailData) {
        itemid = data.itemid
        copy_content = data.itemdesc
        itemendprice = data.itemendprice
        if let imgStr = data.taobao_image {
            itempic = imgStr.components(separatedBy: ",")
        }
        show_time = ""
        dummy_click_statistics = "0"
        itemtitle = data.itemtitle
        itemprice = data.itemprice
        couponmoney = data.couponmoney
    }
}
var Recommendiconlist : [RecommendItem] = [RecommendItem]()
struct RecommendList : HandyJSON{
    
    var data : [RecommendItem]?
    
    init() {}
    
}

var recommendItemData = RecommendItem.init()
