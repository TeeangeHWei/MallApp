//
//  brandModel.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/19.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation


struct brandItem : HandyJSON {
    
    var brand_logo : String?
    var brandcat : String?
    var fq_brand_name : String?
    var id : String?
    var introduce : String?
    var tb_brand_name : String?
    var item : [brandGoodsItem]?
    
    init() {}
}

struct brandGoodsItem : HandyJSON {
    
    var itemtitle : String?
    var itemendprice : String?
    var itemid : String?
    var itemprice : String?
    var itempic : String?
    
    init() {}
}

struct brandList : HandyJSON {
    
    var data : [brandItem]?
    
    init() {}
}
