//
//  MyIncomeModel.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/9/9.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

struct MyIncomeModel : HandyJSON {
    var balance:String?
    //today
    var todayPay:String?
    var todayDeal:String?
    var todaySettle:String?
    //yesterday
    var yesterdayPay:String?
    var yesterdayDeal:String?
    var yesterdaySettle:String?
    //mounth
    var thisMouthConsume:String?
    var thisMouthSettle:String?
    var lastMouthConsume:String?
    var lastMouthSettle:String?
    
    init(){}
    
}

struct WalletInfo : HandyJSON {
    
    // 钱包
    var wallet:WalletData?
    // 已提现
    var withdrawal:String?
    // 未结算
    var notSettle:String?
    
    init(){}
    
}

struct WalletData : HandyJSON {
    
    // 余额
    var balance:String?
    // 累计收入
    var totalIncome:String?
    // 本月预估
    var thisMouthConsume : String?
    // 今日收入
    var todayDeal : String?
    // 昨日收入
    var yesterdayDeal : String?
    
    init(){}
    
}

struct OrderIncome : HandyJSON {
    
    // 下单笔数
    var userCount:String?
    // 预估收益
    var userSum:String?
    // 团队下单笔数
    var teamCount:String?
    // 团队预估收益
    var teamSum:String?
    // 结算收入
    var curSettle:String?
    
    init(){}
    
}
