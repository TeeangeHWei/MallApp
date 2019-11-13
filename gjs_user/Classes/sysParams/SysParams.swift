//
//  File.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/4.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

struct sysParams : HandyJSON{
    
    // 平台收取服务费
    var service : String?
    // 提现开始日
    var beginDay : String?
    // 提现结束日
    var endDay : String?
    // 直接邀请人数
    var directNums : String?
    // 间接邀请人数
    var indirectNums : String?
    // 超级会员分成比例
    var one : String?
    // 团长分成比例
    var two : String?
    // 合作伙伴分成比例
    var three : String?
    
    init() {}
}
