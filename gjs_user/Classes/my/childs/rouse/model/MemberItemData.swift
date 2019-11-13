//
//  MemberItemData.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/31.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

struct MemberItemData : HandyJSON {
    
    var id : String?
    var headPortrait : String?
    var nickName : String?
    var phone : String?
    var createTime : String?
    var memberStatus : String?
    
    init() {}
}

struct SmsData : HandyJSON {
    
    var smsCost : String?
    var smsBalance : String?
    var userBalance : String?
    
    init() {}
}

// 短信相关数据
var smsData : SmsData?
// 会员个数
var memberNum : Int = 0
