//
//  TextView.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/9/6.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

class TextView: UITextView {
    /// setNeedsDisplay调用drawRect
    var placeholder: String = ""{
        didSet{
            self.setNeedsDisplay()
        }
    }
    var placeholderColor: UIColor = UIColor.gray{
        didSet{
            self.setNeedsDisplay()
        }
    }
    override var font: UIFont?{
        didSet{
            self.setNeedsDisplay()
        }
    }
    override var text: String!{
        didSet{
            self.setNeedsDisplay()
        }
    }
    override var attributedText: NSAttributedString!{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        /// default字号
        self.font = UIFont.systemFont(ofSize: 14)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChanged(noti:)), name: UITextView.textDidChangeNotification, object: self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func textDidChanged(noti: NSNotification)  {
        self.setNeedsDisplay()
    }
    override func draw(_ rect: CGRect) {
        if self.hasText {
            return
        }
        var newRect = CGRect()
        newRect.origin.x = 5
        newRect.origin.y = 7
        let size = getStringSize(text: self.placeholder,rectSize: rect.size, font: self.font ?? UIFont.systemFont(ofSize: 14))
        newRect.size.width = size.width
        newRect.size.height = size.height
        /// 将placeholder画在textView上
        (self.placeholder as NSString).draw(in: newRect, withAttributes: [NSAttributedString.Key.font: self.font ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: self.placeholderColor])
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
    }
    
    /// 计算字符串的尺寸
    ///
    /// - Parameters:
    ///   - text: 字符串
    ///   - rectSize: 容器的尺寸
    ///   - fontSize: 字体
    /// - Returns: 尺寸
    ///
    public func getStringSize(text: String,rectSize: CGSize,font: UIFont) -> CGSize {
        let str: NSString = text as NSString
        let rect = str.boundingRect(with: rectSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return CGSize(width: ceil(rect.width), height: ceil(rect.height))
    }
    
}
