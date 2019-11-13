//
//  searchBtn.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/15.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class SearchBtn: UIButton {

    var searchValue : String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, labelS: String) {
        self.init(frame: frame)
        let historyItem = self
        searchValue = labelS
        historyItem.backgroundColor = kBGGrayColor
        historyItem.layer.cornerRadius = 12
        historyItem.layer.masksToBounds = true
        historyItem.configureLayout { (layout) in
            layout.isEnabled = true
            layout.maxWidth = YGValue(kScreenW * 0.25)
            layout.height = 24
            layout.paddingLeft = 10
            layout.paddingRight = 10
            layout.marginBottom = 10
            layout.marginRight = 10
        }
        let itemLabel = UILabel()
        itemLabel.text = labelS
        itemLabel.font = FontSize(12)
        itemLabel.textColor = kMainTextColor
        itemLabel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.maxWidth = YGValue(kScreenW * 0.25 - 20)
            layout.height = 24
        }
        historyItem.addSubview(itemLabel)
        historyItem.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
