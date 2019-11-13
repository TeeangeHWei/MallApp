//
//  View-Extension.swift
//  test
//
//  Created by 大杉网络 on 2019/7/31.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    
    /// 快速创建 View 并使用 SnapKit 布局
    ///
    /// - Parameters:
    ///   - bgClor: View 的背景颜色
    ///   - supView: 父视图
    ///   - closure: 约束
    /// - Returns:  View
    class func createView(bgClor : UIColor , supView : UIView? ,closure:(_ make:ConstraintMaker) ->()) -> UIView {
        let view = UIView()
        view.backgroundColor = bgClor
        if supView != nil {
            supView?.addSubview(view)
            view.snp.makeConstraints { (make) in
                closure(make)
            }
        }
        return view
    }
    
    /// 快速创建一个 UIImageView,可以设置 imageName,contentMode,父视图,约束
    ///
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - contentMode: 填充模式
    ///   - supView: 父视图
    ///   - closure: 约束
    /// - Returns:  UIImageView
    class func createImageView(imageName : String? , contentMode : UIView.ContentMode? = nil,supView : UIView? ,closure:(_ make : ConstraintMaker) ->()) -> UIImageView {

        let imageV = UIImageView()

        if imageName != nil {
            imageV.image = UIImage(named: imageName!)
        }

        if contentMode != nil {
            imageV.contentMode = contentMode!
        }

        if supView != nil {
            supView?.addSubview(imageV)
            imageV.snp.makeConstraints { (make) in
                closure(make)
            }
        }
        return imageV
    }
    
    
    /// 快速创建 UIButton,设置标题,图片,父视图,约束
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - titleStatu: 标题状态模式`
    ///   - imageName: 图片名
    ///   - imageStatu: 图片状态模式
    ///   - supView: 父视图
    ///   - closure: 约束
    /// - Returns:  UIButton
    class func createButton(title : String?,titleStatu : UIControl.State?,titleColor: UIColor? = nil,imageName : String?,imageStatu : UIControl.State?, font : UIFont? = FontSize(14),supView : UIView? ,closure:(_ make : ConstraintMaker) ->()) -> UIButton{
        let btn = UIButton()

        if title != nil {
            btn.setTitle(title, for: .normal)
        }

        if title != nil && titleStatu != nil {
            btn.setTitle(title, for: titleStatu!)
        }

        if imageName != nil {
            btn.setImage(UIImage(named: imageName!), for: .normal)
        }

        if imageName != nil && imageStatu != nil {
            btn.setImage(UIImage(named: imageName!), for: imageStatu!)
        }

        if titleColor != nil {
            btn.setTitleColor(titleColor, for: .normal)
        }
        btn.titleLabel?.font = font
        if supView != nil {
            supView?.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                closure(make)
            }
        }
        return btn
    }
    
    
    /// 快速创建 Label,设置文本, 文本颜色,Font,文本位置,父视图,约束
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - textColor: 文本颜色
    ///   - font: 字体大小
    ///   - textAlignment: 文本位置
    ///   - supView: 父视图
    ///   - closure: 越是
    /// - Returns:  UILabel
    class func createLabel(text : String? , textColor : UIColor?, font : UIFont?, textAlignment : NSTextAlignment = .left,supView : UIView? ,closure:(_ make : ConstraintMaker) ->()) -> UILabel {

        let label = UILabel()
        label.text = text
        if (textColor != nil) { label.textColor = textColor }
        if (font != nil) { label.font = font }
        label.textAlignment = textAlignment

        if supView != nil {
            supView?.addSubview(label)
            label.snp.makeConstraints { (make) in
                closure(make)
            }
        }
        return label
    }
    
    
    /// 快速创建 UITextField,设置文本,文本颜色,placeholder,字体大小,文本位置,边框样式, 自动布局
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - textColor: 文本颜色
    ///   - placeholder: placeholder
    ///   - font: 字体大小
    ///   - textAlignment: 文本位置
    ///   - borderStyle: 边框样式
    ///   - supView: 父视图
    ///   - closure:  make
    /// - Returns: UITextField
    
    class func createTextField(text : String? , textColor : UIColor?, placeholder: String, font : UIFont?, textAlignment : NSTextAlignment = .left, borderStyle :UITextField.BorderStyle = .none,supView : UIView? ,closure:(_ make : ConstraintMaker) ->()) -> UITextField {

        let textField = UITextField()
        textField.text = text
        textField.placeholder = placeholder
        textField.borderStyle = borderStyle
        if (textColor != nil) { textField.textColor = textColor }
        if (font != nil) { textField.font = font }

        textField.textAlignment = textAlignment

        if supView != nil {
            supView?.addSubview(textField)
            textField.snp.makeConstraints { (make) in
                closure(make)
            }
        }
        return textField
    }
    
    
    // MARK: 添加渐变色图层
    public func gradientColor(_ startPoint: CGPoint, _ endPoint: CGPoint, _ colors: [Any]) {
        
        guard startPoint.x >= 0, startPoint.x <= 1, startPoint.y >= 0, startPoint.y <= 1, endPoint.x >= 0, endPoint.x <= 1, endPoint.y >= 0, endPoint.y <= 1 else {
            return
        }
        
        // 外界如果改变了self的大小，需要先刷新
        layoutIfNeeded()
        
        var gradientLayer: CAGradientLayer!
        
        removeGradientLayer()
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.layer.bounds
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = colors
        gradientLayer.cornerRadius = self.layer.cornerRadius
        gradientLayer.masksToBounds = true
        // 渐变图层插入到最底层，避免在uibutton上遮盖文字图片
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.backgroundColor = UIColor.clear
        // self如果是UILabel，masksToBounds设为true会导致文字消失
        self.layer.masksToBounds = false
    }
    
    // MARK: 移除渐变图层
    // （当希望只使用backgroundColor的颜色时，需要先移除之前加过的渐变图层）
    public func removeGradientLayer() {
        if let sl = self.layer.sublayers {
            for layer in sl {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    /// 圆角设置
    ///
    /// - Parameters:
    ///   - view: 需要设置的控件
    ///   - corner: 哪些圆角
    ///   - radii: 圆角半径
    /// - Returns: layer图层
    public func configRectCorner(view: UIView, corner: UIRectCorner, radii: CGSize) -> CALayer {
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: radii)
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        return maskLayer
    }
    
    // 删除除了第一个以外所有子view
    func clearAll(){
        if self.subviews.count > 1 {
            for (index,item) in self.subviews.enumerated() {
                if index > 0 {
                    item.removeFromSuperview()
                }
            }
        }
    }
    
    // 删除所有子view
    func clearAll2(){
        for (index,item) in self.subviews.enumerated() {
            item.removeFromSuperview()
        }
    }
    
    // 删除除了第一第二个以外所有子view
    func clearAll3(){
        if self.subviews.count > 2 {
            for (index,item) in self.subviews.enumerated() {
                if index > 1 {
                    item.removeFromSuperview()
                }
            }
        }
    }
    
}

