//
//  NewsModel.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/9/7.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

struct NewsList : HandyJSON{
    var list: [NewsModel]?
    
    init() {}
}

struct NewsModel : HandyJSON {
    var type: String?
    var title: String?
    var content: String?
    var createTime: String?
    var status: String?
    
    init() {}
}
