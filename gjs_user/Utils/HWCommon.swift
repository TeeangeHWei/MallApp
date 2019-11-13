//
//  HWCommon.swift
//  test
//
//  Created by 大杉网络 on 2019/7/29.
//  Copyright © 2019 大杉网络. All rights reserved.
//

// 是否s第一次进入app
var isFirst = true

// 本地服务器地址
let BASE_URL = "https://www.ganjinsheng.com/api/"

let kScreenW = UIScreen.main.bounds.size.width
let kScreenH = UIScreen.main.bounds.size.height

let kWidthRatio = kScreenW / 375.0
let kHeightRatio = kScreenH / 667.0

// 判断是否为 iPhone X
let isIphoneX = kScreenH >= 812 ? true : false
// 状态栏高度
let kStatuHeight : CGFloat = isIphoneX ? 44 : 20
// 导航栏高度
let kNavigationBarHeight :CGFloat = 44
let screenFrame:CGRect = UIScreen.main.bounds
// TabBar高度
let kTabBarHeight : CGFloat = isIphoneX ? 49 + 34 : 49
let CateItemHeight = kScreenW / 4
let kCateTitleH : CGFloat = 42
// 导航栏总高度
let headerHeight = kStatuHeight + kNavigationBarHeight

// 分类页标题
var classifyTitle : String?
// 详情页宝贝id
var detailId : Int?
// 要搜索的字符串
var searchStr : String?


//自适应
func Adapt(_ value : CGFloat) -> CGFloat {
    return AdaptW(value)
}

// 自适应宽度
func AdaptW(_ value : CGFloat) -> CGFloat {
    return ceil(value) * kWidthRatio
}

// 自适应高度
func AdaptH(_ value : CGFloat) -> CGFloat {
    return ceil(value) * kWidthRatio
}

// 时间戳转Date  13位
func getDateFromTimeStamp(timeStamp:String) ->Date {
    let interval:TimeInterval = TimeInterval.init(timeStamp)!/1000.0
    return Date(timeIntervalSince1970: interval)
}

//
func getDateFromTimeStamp10(timeStamp:String) ->Date {
    let interval:TimeInterval = TimeInterval.init(timeStamp)!
    return Date(timeIntervalSince1970: interval)
}
//这里的375我是针对6为标准适配的,如果需要其他标准可以修改
func kWidthScale(_ R:CGFloat) -> CGFloat {
    return ((R)*(kScreenW/375.0))
}
//自定义调试阶段log
func NSLog(filePath: String = #file, rowCount: Int = #line) {
    #if DEBUG
    let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".Swift", with: "")
    print("-----------" + fileName + "/" + "\(rowCount)" + "\n")
    #endif
}

func NSLog<T>(_ message: T, filePath: String = #file, rowCount: Int = #line) {
    #if DEBUG
    let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".Swift", with: "")
    print("-----------" + fileName + "/" + "\(rowCount)" + " \(message)" + "\n")
    #endif
}

//系统版本
let kSystemVersion = UIDevice.current.systemVersion

//系统版本
let IOS9  = (Double(kSystemVersion)! >= 9.0)


//设备
let kDevice_iPhone4          = (kScreenH == 480.0)
let kDevice_iPhone5_SE       = (kScreenH == 568.0)
let kDevice_iPhone6_7_8      = (kScreenH == 667.0)
let kDevice_iPhone6_7_8_Plus = (kScreenH == 736.0)
let kDevice_iPhoneX_Xs       = (kScreenH == 812.0)
let kDevice_iPhoneXR_Max     = (kScreenH == 896.0)
let kDevice_iPhoneX_Series   = kDevice_iPhoneX_Xs || kDevice_iPhoneXR_Max


//设备 系统高度
let kSystemNavigationBarHeight:CGFloat  = (kDevice_iPhoneX_Series ? 88 : 64)
let kSystemTopMargin:CGFloat            = (kDevice_iPhoneX_Series ? 44 : 0)
let kSystemBottomMargin:CGFloat         = (kDevice_iPhoneX_Series ? 34 : 0)
