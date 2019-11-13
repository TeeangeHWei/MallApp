//
//  MyCollectionFooter.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/26.
//  Copyright © 2019 大杉网络. All rights reserved.
//

typealias sendValueClosure = (_ value:Bool)->Void
typealias removeCheck = ()->Void
class MyCollectionFooter: UIView {
    let checkAll = checkBox(frame: CGRect(x: 0.0, y: 0.0, width: 24.0, height: 24.0))
    // 全选
    var checkAllChange:sendValueClosure?
    // 删除
    var removeGoods:removeCheck?
    public func UIPivkerInit(closuer:sendValueClosure?, closuer1:removeCheck?){
        self.checkAllChange = closuer
        self.removeGoods = closuer1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // footer
        let footerBox = self
        footerBox.addBorder(side: .top, thickness: 1, color: klineColor)
        footerBox.backgroundColor = .white
        let myCollectionFooter = UIView()
        myCollectionFooter.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(frame.size.width)
            layout.height = YGValue(50)
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        footerBox.addSubview(myCollectionFooter)
        let footerLeft = UIView()
        footerLeft.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        myCollectionFooter.addSubview(footerLeft)
        
        checkAll.checkValue = false
        checkAll.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(24)
            layout.height = YGValue(24)
        }
        checkAll.addTarget(self, action: #selector(checkAllClick), for: .touchUpInside)
        footerLeft.addSubview(checkAll)
        let checkAllText = UILabel()
        checkAllText.text = "全选"
        checkAllText.font = FontSize(14)
        checkAllText.textColor = kGrayTextColor
        checkAllText.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginLeft = 10
        }
        footerLeft.addSubview(checkAllText)
        // 右
        let footerRight = UIButton()
        footerRight.backgroundColor = kLowOrangeColor
        footerRight.setTitle("删除", for: .normal)
        footerRight.titleLabel?.font = FontSize(14)
        footerRight.layer.cornerRadius = 13
        footerRight.layer.masksToBounds = true
        footerRight.addTarget(self, action: #selector(toRemove), for: .touchUpInside)
        footerRight.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 70
            layout.height = 26
        }
        myCollectionFooter.addSubview(footerRight)
        
        myCollectionFooter.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func checkAllClick (_ btn: UIButton) {
        let value = checkAll.checkValue
        checkAllChange!(value)
    }
    
    @objc func toRemove (_ btn: UIButton) {
        removeGoods!()
    }
}
