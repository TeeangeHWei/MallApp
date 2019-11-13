//
//  CollectionFooterView.swift
//  test
//
//  Created by 大杉网络 on 2019/8/6.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class CollectionFooterView: UICollectionReusableView {
    var view = UIView()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.view = UIView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height:self.frame.size.height ))
        self.addSubview(view)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
