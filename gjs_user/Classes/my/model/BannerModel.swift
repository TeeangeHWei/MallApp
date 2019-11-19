//
//  BannerModel.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/5.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

// 轮播图数据模型
struct MyBanner : HandyJSON {
    var img : String?
    var appUrl : String?
    var adTitle : String?
    init(){}
}
struct MyBannerList : HandyJSON {
    var list : [MyBanner]?
    init() {}
    
}


struct notice : HandyJSON{
    var id : String?
    var url : String?
    var img : String?
}
struct noticeList : HandyJSON {
    var list : [notice]?
    init() {}
    
}
