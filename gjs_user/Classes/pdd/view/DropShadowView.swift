//
//  DropShadowView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/19.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class DropShadowView: UIView {
    var presetCornerRadius : CGFloat = 25.0
    
    /*
     once the bounds of the drop shadow view (container view) is initialized,
     the bounds variable value will be set/updated and the
     setupShadow method will run
     */
    override var bounds: CGRect {
        didSet {
            setupShadowPath()
        }
    }
    
    private func setupShadowPath() {
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: presetCornerRadius).cgPath
        
        // further optimization by rasterizing the container view and its shadow into bitmap instead of dynamically rendering it every time
        // take note that the rasterized bitmap will be saved into memory and it might take quite some memory if you have many cells
        
        // self.layer.shouldRasterize = true
        // self.layer.rasterizationScale = UIScreen.main.scale
    }

}