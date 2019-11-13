//
//  ClassifyButton.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/4.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class ClassifyButton: UIButton {
    
    var tagStr : String?
    let itemW = (kScreenW * 0.75 - 30)/3
    private var nav : UINavigationController?
    lazy var icon = UIImageView()
    //    let itemH = 34 + itemW * 0.8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, data: rightItem, navC: UINavigationController?) {
        self.init(frame: frame)
        self.nav = navC
        self.tagStr = data.son_name!
        self.addTarget(self, action: #selector(toGoodsList), for: .touchUpInside)
        self.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.width = YGValue(self.itemW)
            layout.paddingTop = 10
        }
        
        icon.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(self.itemW * 0.8)
            layout.height = YGValue(self.itemW * 0.8)
        }
        ADPhotoLoader.share.loadImage(url: data.imgurl!, complete: {[weak self](data: Data?, url: String) in
//            guard let data1 = data else {
//                return
//            }
//            // 处理图片
//            self!.icon.image = UIImage(data: data1)
            if let data1 = data {
                // 处理图片
                self!.icon.image = UIImage(data: data1)
            }
        })
        self.addSubview(icon)
        let name = UILabel()
        name.text = data.son_name!
        name.font = FontSize(14)
        name.textAlignment = .center
        name.textColor = kMainTextColor
        name.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(self.itemW)
            layout.height = 24
        }
        self.addSubview(name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func toGoodsList (_ btn: ClassifyButton) {
        var name = btn.tagStr!
        classifyTitle = name
        self.nav!.pushViewController(ClassifyGoodsListView(), animated: true)
    }
}
