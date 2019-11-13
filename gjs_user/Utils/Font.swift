//
//  Font.swift
//  test
//
//  Created by 大杉网络 on 2019/7/29.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

// 常规字体
func FontSize(_ size : CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: AdaptW(size))
}


// 加粗字体
func BoldFontSize(_ size : CGFloat) -> UIFont {
    
    return UIFont.boldSystemFont(ofSize: AdaptW(size))
}
