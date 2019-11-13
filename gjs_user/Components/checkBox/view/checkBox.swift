//
//  checkBox.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/24.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class checkBox: UIButton {
    
    let checkNo = UIImageView(image: UIImage(named: "check-no"))
    let checkYes = UIImageView(image: UIImage(named: "check-yes"))
    var checkValue : Bool = false {
        willSet {
            
        }
        didSet {
            checkNo.isHidden = checkValue
            checkYes.isHidden = !checkValue
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        checkNo.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        checkNo.isUserInteractionEnabled = false
        self.addSubview(checkNo)
        checkYes.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        checkNo.isUserInteractionEnabled = false
        self.addSubview(checkYes)
        checkNo.isHidden = checkValue
        checkYes.isHidden = !checkValue
        self.addTarget(self, action: #selector(checkChange), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func checkChange (_ btn: UIButton) {
        checkValue = !checkValue
        self.checkNo.isHidden = checkValue
        self.checkYes.isHidden = !checkValue
    }
    
}
