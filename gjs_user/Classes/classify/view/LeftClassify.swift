//
//  LeftClassify.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/4.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

typealias ClassifyChange = (_ value:Int)->Void

class LeftClassify: UIScrollView {

    var changeOne:ClassifyChange?
    
    private var oldIndex: Int? = 1
    private var leftUIList = [UILabel]()
    
    public func UIPivkerInit(closuer:ClassifyChange?){
        self.changeOne = closuer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, data: [leftItem]) {
        self.init(frame: frame)
        
        // 左  大分类
        let left = self
        left.showsVerticalScrollIndicator = false
        left.addBorder(side: .right, thickness: CGFloat(1), color: klineColor)
        var leftHeight = 0
        for item in data {
            let view = UIView(frame: CGRect(x: 0, y: leftHeight, width: Int(left.bounds.width), height: 50))
            let label = UILabel()
            label.text = item.main_name!
            label.frame = CGRect(x: 15, y: 10, width: Int(left.bounds.width) - 30, height: 30)
            label.textAlignment = .center
            label.tag = Int(item.cid!)!
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelClick(sender:)))
            label.addGestureRecognizer(tap)
            label.layer.cornerRadius = 15
            label.font = FontSize(14)
            leftHeight += 50
            view.addSubview(label)
            if Int(item.cid!)! == 1 {
                label.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
                label.textColor = .white
            }
            leftUIList.append(label)
            left.addSubview(view)
        }
        left.contentSize = CGSize(width: 60, height: 50)
        left.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(leftHeight + 50), right: CGFloat(0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func labelClick(sender:UITapGestureRecognizer) {
        let view = sender.view
        let index = sender.view?.tag
        if index != oldIndex {
            leftUIList[index! - 1].textColor = .white
            view?.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
            if oldIndex != nil {
                leftUIList[oldIndex! - 1].backgroundColor = .white
                leftUIList[oldIndex! - 1].textColor = .black
                oldIndex = index
            }
        }
        changeOne!(index!)
    }

}
