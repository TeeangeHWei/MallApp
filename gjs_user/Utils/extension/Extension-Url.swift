//
//  Extension-Url.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/29.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

extension URL {
    public var parametersFromQueryString : [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
        let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
