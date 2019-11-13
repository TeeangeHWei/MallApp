//
//  JdHeaderView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/11.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class JdHeaderView: UIView {
    
 override init(frame: CGRect) {
    super.init(frame: frame)
    let kcycleViewHeight :CGFloat = 156
    let cycleView = ZCycleView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenW * 240/640))
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
        cycleView.setImagesGroup([#imageLiteral(resourceName: "jd-banner"),#imageLiteral(resourceName: "jd-banner"),#imageLiteral(resourceName: "jd-banner"),#imageLiteral(resourceName: "jd-banner")])
    }
    //        cycleView.pageControlItemSize = CGSize(width: 16, height: 4)
    //        cycleView.pageControlItemRadius = 0
    cycleView.pageControlIndictirColor = colorwithRGBA(241, 241, 241, 0.5)
    cycleView.pageControlCurrentIndictirColor = .yellow
    cycleView.pageControlAlignment = .right
    cycleView.didSelectedItem = {
        print("\($0)")
    }
    self.addSubview(cycleView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
