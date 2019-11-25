//
//  jdModel.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/11/22.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation
struct jdTitleModel : HandyJSON {
    init() {}
    var id : String?
    var name : String?
    init (tid:String?, tname:String?) {
        id = tid
        name = tname
    }
}
