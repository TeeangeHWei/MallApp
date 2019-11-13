//
//  CodeView.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/9/3.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

class PhoneCodeView: UIView, UITextFieldDelegate {
    private class TextField: UITextField {
        override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            //print(action)
            //print(value(forKey: "_floatingContentView") ?? "_floatingContentView = nil")
            return false
        }
    }
    private var _baiscTag = 6666
    private var _maxLen: Int = 0
    private var _width: CGFloat = 0.0
    private var _height: CGFloat = 0.0
    private var _pore: CGFloat = 0.0
    private var _tf: TextField!
    /// 输入完成
    var inputFinish: ((_ text: String) -> Void)?
    var maxLen: Int {
        return _maxLen
    }
    var text: String? {
        return _tf.text
    }
    var font: UIFont {
        set {
            for i in 0..<_maxLen {
                let l = viewWithTag(_baiscTag+i+1) as! UILabel
                l.font = newValue
            }
        } get {
            let l = viewWithTag(_baiscTag+1) as! UILabel
            return l.font
        }
    }
    var textColor: UIColor {
        set {
            for i in 0..<_maxLen {
                let l = viewWithTag(_baiscTag+i+1) as! UILabel
                l.textColor = newValue
            }
        } get {
            let l = viewWithTag(_baiscTag+1) as! UILabel
            return l.textColor
        }
    }
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - width: 单个输入框宽度
    ///   - height: 单个高度
    ///   - pore: 边距
    ///   - num: 个数
    convenience init(x:CGFloat, y:CGFloat, width: CGFloat, height: CGFloat, pore: CGFloat, num: UInt) {
        let w = width * CGFloat(num) + pore * CGFloat(num-1)
        self.init(frame: CGRect(x: x, y: y, width: w, height: height))
        _maxLen = Int(num)
        _width = width
        _height = height
        _pore = pore
        setupSubviews()
    }
    func updateOriginPoint(_ op: CGPoint) {
        var f = frame
        f.origin = op
        frame = f
    }
    func setupSubviews() {
        for i in 0..<_maxLen {
            let frame = CGRect(x: CGFloat(i) * (_width+_pore), y: 0, width: _width, height: _height)
            let label = UILabel(frame: frame)
            label.textColor = kMainTextColor
            addSubview(label)
            let layerBottom = CALayer()
            layerBottom.frame = CGRect(x: 0, y: _height, width: _width, height: 1)
            layerBottom.backgroundColor = klineColor.cgColor
            label.layer.addSublayer(layerBottom)
            label.tag = _baiscTag + i + 1
            label.textAlignment = .center
        }
        
        _tf = TextField(frame: bounds)
        addSubview(_tf)
        _tf.autocorrectionType = .no // 禁止键盘联想 or 禁止键盘推荐
        _tf.tintColor = .clear
        _tf.setValue(UIColor.clear, forKeyPath: "textInputTraits.insertionPointColor")
        _tf.backgroundColor = .clear
        _tf.textColor = .clear
        _tf.frame = bounds
        _tf.delegate = self
        _tf.tag = _baiscTag
        _tf.keyboardType = .numberPad //输入数字
        _tf.textInputView.backgroundColor = .clear
        _tf.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
    }
    @objc func textFieldTextChanged() {
        if let _ = _tf.markedTextRange {
            // 支持中文输入
            return
        }
        var txt = _tf.text ?? ""
        var str = txt.map(String.init)
        if str.count > _maxLen {
            str = str[0..<_maxLen].map { $0 }
        }
        txt = str.joined(separator: "")
        _tf.text = txt
        for i in 0..<_maxLen {
            let l = viewWithTag(_baiscTag+i+1) as! UILabel
            if (i < txt.count) {
                let startIndex = txt.index(txt.startIndex, offsetBy: i)
                l.text = String(txt[startIndex])
            } else {
                l.text = ""
            }
        }
        if(_tf.text!.count == 6){
            // 结束编辑
            inputFinish?(_tf.text!)
            return
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
