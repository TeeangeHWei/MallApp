//
//  BillModel.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/9/9.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

struct BillModel : HandyJSON {
    var type:String?
    var remark:String?
    var createTime:String?
    var amount:String?
    
    init(){}
}
