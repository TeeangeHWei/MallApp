//
//  ArticleBannerModel.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/30.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

// 轮播图
var articelBannerImg = [String]()


// 本周最新
struct NewWeekData : HandyJSON {

    var article : String?
    var article_banner : String?
    var head_img : String?
    var talent_name : String?
    var id : String?
    
    init() {}
}

struct NewWeekDataList : HandyJSON {

    var newdata : [NewWeekData]?

    init() {}
}

var newWeekDataList = [NewWeekData]()


// 大家都在看
struct ArticleItemData : HandyJSON {
    
    var id : String?
    var image : String?
    var article : String?
    var shorttitle : String?
    var itemnum : String?
    var readtimes : String?
    
    init() {}
}

struct ArticleList : HandyJSON {
    
    var clickdata : [ArticleItemData]?
    
    init() {}
}

var articleList = [ArticleItemData]()
