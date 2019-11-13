//
//  BrandGoodsListModel.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/20.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

var brandId : Int?


struct oneBrandModel : HandyJSON {
    
    var brand_logo : String?
    var brandcat : String?
    var fq_brand_name : String?
    var id : String?
    var introduce : String?
    var tb_brand_name : String?
    var items : [goodsItem]?
    
    init() {}
}
