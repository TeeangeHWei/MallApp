//
//  config.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/22.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

let netmanager: SessionManager = {
    let configuration = URLSessionConfiguration.default
    let reachability = NetworkReachabilityManager()
    if (reachability?.isReachable)! {
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    }else
    {
        configuration.requestCachePolicy = .returnCacheDataElseLoad
    }
    return Alamofire.SessionManager(configuration: configuration)
}()
