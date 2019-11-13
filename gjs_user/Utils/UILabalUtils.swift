//
//  UILabal-Extension.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/12.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

//根据文字获取高度
func caculateHeight(commemt : String, fontSize : CGFloat, showWidth : CGFloat, spacing: CGFloat) -> CGFloat {
    let font = UIFont.systemFont(ofSize: fontSize)
    let size = commemt.boundingRect(with: CGSize(), options: .usesFontLeading, attributes: [NSAttributedString.Key.font : font], context: nil)
    return (size.height - 2 * size.origin.y + spacing - 3) * (size.width / showWidth)
}

///动态设置行高的方法
///
/// - Parameters:
///   - labelStr: 文本内容
///   - font: 字体大小
///   - width: 宽度
///   - lineSpacing: 行间距
/// - Returns: 动态高度
func getLabHeigh(labelStr:String,font:UIFont,width:CGFloat,lineSpacing:CGFloat=0) -> CGFloat {
    let statusLabelText: NSString = labelStr as NSString
    let size = CGSize(width: width, height: 9999)
    //通过富文本来设置行间距
    let paraph = NSMutableParagraphStyle()
    //行间距设置
    paraph.lineSpacing = lineSpacing
    //样式属性集合
    let attributes = [NSAttributedString.Key.font:font,NSAttributedString.Key.paragraphStyle: paraph]
    //boundingRect函数只有NSString可以用
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
    return strSize.height
}
