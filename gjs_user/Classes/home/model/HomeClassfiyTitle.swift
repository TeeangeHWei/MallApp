//
//  HomeClassfiyTitle.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/16.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation
import HandyJSON



var huangweiArr = [HWGeneralModel]()
// 首页数组模型
struct HWGeneralModel : HandyJSON {
    var cid : Int?
    var data : Array<HWDataModel>?
    var main_name : String?
    init(){}
}

struct HWDataModel : HandyJSON {
    var next_name : String?
    var info : Array<HWInfoListModel>?
}

struct HWInfoListModel : HandyJSON {
    var imgurl : String?
    var son_name : String?
}



struct homeiconModel : HandyJSON {
    init() {}
    var iconName : String?
    var iconUrl : String?
    var link : String?
    var type : Int?
}
var homeiconlist : [homeiconModel] = [homeiconModel]()
struct homeIconList : HandyJSON{
    var data : [homeiconModel]?
    init() {}
}

// 秒杀数据模型
struct SpikeModel : HandyJSON{
    init() {}
    var itemid : String?
    var moretitle : String?
    var moreimg : String?
    var itemendprice : String?
//    let OriPrice : String
    var itempic : String?
    var itemprice : String?
    
    init(_ SalePrice: String,_ CommodityImg : String,_ itemprice : String) {
        // 优惠价
        self.itemendprice = SalePrice
        // 商品图片
        self.itempic = CommodityImg
        // 原价
        self.itemprice = itemprice
        
    }
}
var spikelist : [SpikeModel] = [SpikeModel]()
struct spikeDataList : HandyJSON {
    
    var data : [SpikeModel]?
    
    init() {}
}

// 轮播图数据模型
struct cycleScrollModel : HandyJSON {
    init(){}
    var img : String?
    var appUrl : String?
    var adTitle : String?
    var url : String?
}
struct cycleScrollList : HandyJSON{
    var list : [cycleScrollModel]?
    init() {}
    
}



// 跑马灯数据模型
struct pamaModel : HandyJSON{
    init() {}
    var itemid : String?
    var copy_text : String?
}
var pamalist : [String] = [String]()
var pamaid : [String] = [String]()
struct pamaDataList : HandyJSON {
    
    var data : [pamaModel]?
    
    init() {}
}


struct shakeBondData : HandyJSON{
    init() {}
    /*-------- 首页抖券数据---------*/
    // 首页抖券图片
    var first_frame : String?
    // 👆
    var itempic : String?
    // 点赞数
    var dy_video_like_count : String?
    // 标题
    var itemtitle : String?
    // 价格
    var itemprice : String?
    // 优惠券金额
    var couponmoney : String?
    // 预计赚
    var tkmoney : String?
    // 商场类型
    var shoptype : String?
    // 视频
    var dy_video_url : String?
    //itemid
    var itemid : String?
    /*-------- 首页抖券详情更多数据---------*/
}
var shakeBondlist : [shakeBondData] = [shakeBondData]()
struct shakeBondDataList : HandyJSON {
    
    var data : [shakeBondData]?
    
    init() {}
}
