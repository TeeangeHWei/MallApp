//
//  cardSwiper.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/28.
//  Copyright © 2019 大杉网络. All rights reserved.
//


class CardSwiper: UIScrollView {

    var allWidth = 0
    var imgArr = [UIImageView]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func transform1 (_ btn: UIButton) {
        imgArr[3].transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
}
