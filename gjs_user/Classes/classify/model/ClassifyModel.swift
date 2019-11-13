//
//  ClassifyModel.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/4.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

struct leftItem : HandyJSON{
    
    var cid : String?
    var main_name : String?
    
    init() {}
    
}

struct leftListModel : HandyJSON{
    
    var general_classify : [leftItem]?
    
    init() {}
    
}

struct rightItem : HandyJSON{
    
    var imgurl : String?
    var son_name : String?
    
    init() {}
    
}

struct data : HandyJSON{
    
    var info : [rightItem]?
    var next_name : String?
    
    init() {}
    
}

struct rightItemModel : HandyJSON{
    
    var data : [data]?
    
    init() {}
    
}

struct rightListModel : HandyJSON{
    
    var general_classify : [rightItemModel]?
    
    init() {}
    
}
