//
//  PageOptions.swift
//  test
//
//  Created by 大杉网络 on 2019/7/30.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

public class PageOptions{
    
    /// segment之间的间隔竖线的宽度
    public var verticalDividerWidth: CGFloat = 1.0
    /// 是否需要segment之间的间隔竖线
    public var verticalDividerEnabled = false
    /// segment之间的间隔竖线的颜色
    public var verticalDividerColor = UIColor.black
    
    public var newsTitleHeight: CGFloat = 40
    // 选项宽度
    public var kItemWidth : CGFloat = 40
    // 定义颜色 默认为选中颜色 （rgb）
    public var kNormalColor : (CGFloat,CGFloat,CGFloat) = (99,99,99)
    // 选中后颜色
    public var kSelectColor : (CGFloat,CGFloat,CGFloat) = (200,33,33)
    //label间隔
    public var kMarginW : CGFloat = Adapt(10)
    //是否允许标题滚动
    public var isTitleScrollEnable : Bool = true
    // 底部滚动线的高度
    public var kBotLineHeight : CGFloat = 35
    // 默认字体的font大小
    public var kTitleFontSize : CGFloat = 15
    // 默认字体是否加粗
    public var kIsNormalFontBold : Bool = false
    // 选中文本字体大小
    public var kTitleSelectFontSize : CGFloat? = nil
    // 底部滚动条颜色
    public var kBotLineColor : UIColor = kWhite
    // 是否显示滚动线
    public var isShowBottomLine : Bool = true
    // scrollView 的 背景颜色
    public var kScrollViewBGColor : UIColor = kWhite
    // 是否显示底部分割线
    public var kIsShowBottomBorderLine : Bool = true
    // 底部分割线颜色
    public var kBottomLineColor : UIColor = colorwithRGBA(247, 248, 250, 1)
    
    // scrollView背景渐变色
    public var kGradColors : [CGColor]? = nil
    //  竖线宽度
    public var kIsRightLineWidth : CGFloat = 1.0
    //  是否显示右分割线
    public var kIsShowRightLine : Bool = false
    // 右分割线颜色
    public var kRightLineColor : UIColor = colorwithRGBA(247, 248, 250, 1)
    
    public var kscrollViewBGColor : UIColor = kWhite
}
