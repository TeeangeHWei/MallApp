
//
//  CollectionHeaderView.swift
//  test
//
//  Created by 大杉网络 on 2019/7/31.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
    var view = UIView()
    var label = UILabel()
    
    
    lazy var titleLab = UILabel()
    lazy var topLine : UIView = UIView()
    lazy var botLine : UIView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        backgroundColor = kBlack
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension CollectionHeaderView{
    private func setUpView(){
        topLine = UIView.createView(bgClor: klineColor, supView: self, closure: { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(0.6)
        })
        titleLab = UILabel.createLabel(text: "", textColor: kMainTextColor, font: BoldFontSize(16), supView: self, closure: { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(AdaptW(15))
        })
        botLine = UIView.createView(bgClor: klineColor, supView: self, closure: { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.6)
        })
    }
}
