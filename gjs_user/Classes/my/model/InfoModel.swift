//
//  InfoModel.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/31.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

struct Info : HandyJSON{
    
    var id : String! = ""
    var nickName : String! = ""
    var alipayAccount : String! = ""
    var alipayRealname : String! = ""
    var inviteCode : String! = ""
    var headPortrait : String! = ""
    var memberStatus : String! = ""
    var relationId : String! = ""
    var phone : String! = ""
    var wechatNum : String! = ""
    var wechatQrcode : String! = ""
    
    init() {}
}
