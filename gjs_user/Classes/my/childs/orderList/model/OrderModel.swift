//
//  OrderModel.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/9/18.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

struct OrderModel: HandyJSON {
    
    var orderId:String?
    var itemId:String?
    var itemPrice:String?
    var itemTitle:String?
    var status:String?
    var nickName:String?
    var createTime:String?
    var payTime:String?
    var itemLink:String?
    var commission:String?
    var usId:String?
    var parentId:String?
    var earningTime:String?
    var tkPaidTime:String?
    var itemNum:String?
    var sellerShopTitle:String?
    var parentIdTwo:String?
    var parentCommission:String?
    var parentCommissionTwo:String?
    
    init(){}
}
