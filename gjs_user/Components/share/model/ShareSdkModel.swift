//
//  shareSdkModel.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/10/6.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

struct ShareSdkModel: HandyJSON{
    // 标题
    var title : String?
    // 内容
    var content : String?
    // URL跳转地址
    var url : String?
    // 分享图片
    var image : UIImage?
    // 分享类型
    var type:SSDKContentType?
    
    init(){}
}
