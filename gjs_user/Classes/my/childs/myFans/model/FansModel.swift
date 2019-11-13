//
//  FansModel.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/9/10.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

struct FansModel : HandyJSON {
    var id:String?
    var userInfo:FansInfo?
    var wallet:FansWallet?
    
    init(){}
}

struct FansInfo : HandyJSON{
    var id:String?
    var headPortrait:String?
    var nickName:String?
    var memberStatus:String?
    var fansNums:String?
    var createTime:String?
    var phone:String?
    var wechatNum:String?
    
    init(){}
}

struct FansWallet : HandyJSON {
    var balance:String?
    var lastMouthConsume:String?
    
    init(){}
}
