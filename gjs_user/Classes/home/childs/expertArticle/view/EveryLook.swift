//
//  EveryLook.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/29.
//  Copyright © 2019 大杉网络. All rights reserved.
//


class EveryLook: UIView {
    let typeList = IDSelectView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW - 100, height: 40))
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.configureLayout { (layout) in
            layout.isEnabled = true
            layout.paddingLeft = 15
            layout.paddingRight = 15
            layout.paddingTop = 10
        }
        
        let title = UILabel()
        title.text = "大家都在看"
        title.font = FontSize(16)
        title.textColor = kMainTextColor
        title.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginTop = 20
            layout.marginBottom = 10
        }
        self.addSubview(title)
        
        // 文章分类
        let typeListBox = UIView(frame: CGRect.init(x: 0, y: 0, width: kScreenW - 30, height: 41))
        typeListBox.addBorder(side: .bottom, thickness: 1, color: klineColor)
        typeListBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 30)
            layout.height = 41
        }
        self.addSubview(typeListBox)
        
        typeList.id_indicatorColor = colorwithRGBA(245, 213, 46, 1)
        typeList.id_titleSelectedColor = kMainTextColor
        typeList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 100)
            layout.height = 40
        }
        typeList.id_titles = ["全部", "好物", "潮流", "美食", "生活"]
        typeListBox.addSubview(typeList)
        
        
        
        
        
        
        self.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
