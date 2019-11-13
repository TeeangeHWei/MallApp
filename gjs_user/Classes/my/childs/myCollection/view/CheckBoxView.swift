//
//  checkBox.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/11.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class CheckBoxView: UIView {

    let checkBtn: checkBox = checkBox(frame: CGRect(x: 0.0, y: 0.0, width: 18.0, height: 18.0))
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.masksToBounds = true
        self.isUserInteractionEnabled = true
        self.configureLayout { (layout) in
            layout.isEnabled = true
            layout.justifyContent = .center
            layout.alignItems = .center
            layout.width = YGValue(frame.size.width)
            layout.height = YGValue(120)
            layout.marginTop = 10
        }
//        checkBtn.tag = Int(item.itemid!)!
        checkBtn.isUserInteractionEnabled = true
        checkBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(18)
            layout.height = YGValue(18)
        }
        self.addSubview(checkBtn)
        
        self.yoga.applyLayout(preservingOrigin: true)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
