//
//  Color.swift
//  test
//
//  Created by 大杉网络 on 2019/7/29.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

let kWhite       = UIColor.white
let kRed         = UIColor.red
let kOrange      = UIColor.orange
let kBlack       = UIColor.black
let kGreen       = UIColor.green
let kPurple      = UIColor.purple
let kBlue        = UIColor.blue



// low  r: 239 130 62
// high r: 237 105 57
let kLowOrangeColor = UIColor(red: colorValue(246), green:colorValue(50), blue: colorValue(46), alpha: 1.0)
let kHighOrangeColor = UIColor(red: colorValue(249), green:colorValue(153), blue: colorValue(10), alpha: 1.0)
// 渐变色色组
let kGradientColors: [UIColor] = [kLowOrangeColor, kHighOrangeColor]
let kCGGradientColors: [CGColor] = [kLowOrangeColor.cgColor, kHighOrangeColor.cgColor]
let kGradientColorA = UIColor.init(cgColor: kGradientColors as! CGColor)


// 渐变色色组
let kWhiteColors: [CGColor] = [kWhite.cgColor, kRed.cgColor]

// 搜索框背景颜色 e
let kSearchBGColor = UIColor(red: colorValue(247), green:colorValue(248), blue: colorValue(250), alpha: 1.0)

// 背景灰色
let kBGGrayColor : UIColor = colorwithRGBA(246,246,246,1.0)
// 分割线颜色
let klineColor : UIColor = colorwithRGBA(230, 230, 230, 1.0)
// 文字颜色 默认黑色
let kMainTextColor : UIColor = colorwithRGBA(33, 33, 33, 1.0)
// 文字颜色 深灰色
let kGrayTextColor : UIColor = colorwithRGBA(99, 99, 99, 1.0)
// 文字颜色 浅灰色
let kLowGrayColor : UIColor = colorwithRGBA(150, 150, 150, 1.0)
// 浅红背景
let kBGRedColor : UIColor = colorwithRGBA(246, 50, 46, 0.2)
// 操作成功颜色
let kBGGreenColor : UIColor = colorwithRGBA(50,205,50,1)

// 按钮背景灰色
let kGrayBtnColor : UIColor = colorwithRGBA(231, 231, 231, 1)

// function
// 背景灰色

func colorValue(_ value : CGFloat) -> CGFloat {
    return value / 255.0
}

func colorwithRGBA(_ red : CGFloat, _ green : CGFloat, _ blue : CGFloat , _ alpha : CGFloat) -> UIColor {
    return UIColor(red: colorValue(red), green: colorValue(green), blue: colorValue(blue), alpha: alpha)
    
}
