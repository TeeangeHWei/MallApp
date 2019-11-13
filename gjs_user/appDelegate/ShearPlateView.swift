//
//  ShearPlateView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/21.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class ShearPlateView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, copyStr: String) {
        self.init(frame: frame)
        self.tag = 110
        self.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH)
            layout.position = .relative
            layout.justifyContent = .center
            layout.alignItems = .center
        }
        // 遮罩
        let shade = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
        shade.addTarget(self, action: #selector(closedAction), for: .touchUpInside)
        shade.backgroundColor = colorwithRGBA(0, 0, 0, 0.5)
        shade.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH)
            layout.position = .absolute
            layout.top = 0
            layout.left = 0
        }
        self.addSubview(shade)
        // 弹窗内容
        let contentBox = UIView()
        contentBox.layer.contents = UIImage(named:"shearPlate")?.cgImage
        contentBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.7)
            layout.height = YGValue(kScreenW * 0.84)
        }
        self.addSubview(contentBox)
        // 复制文案
        let copyText = UILabel()
        copyText.numberOfLines = 4
        copyText.text = copyStr
        copyText.font = FontSize(14)
        copyText.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginTop = YGValue(kScreenW * 0.34)
            layout.marginLeft = YGValue(kScreenW * 0.05)
            layout.width = YGValue(kScreenW * 0.6)
            layout.height = YGValue(kScreenW * 0.26)
        }
        contentBox.addSubview(copyText)
        // 平台按钮
        let btnList = UIView()
        btnList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.7)
            layout.height = YGValue(kScreenW * 0.23)
            layout.flexDirection = .row
            layout.justifyContent = .center
            layout.alignItems = .center
        }
        contentBox.addSubview(btnList)
        let imgList = [
            "shear-tb",
            "shear-pdd"
        ]
        for (index, img) in imgList.enumerated() {
            let btn = UIButton()
            btn.tag = index
            btn.addTarget(self, action: #selector(jumpPage), for: .touchUpInside)
            var marginNum : CGFloat = 0
            if index < imgList.count {
                marginNum = 15
            }
            btn.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(45)
                layout.height = YGValue(45)
                layout.marginRight = YGValue(marginNum)
            }
            btnList.addSubview(btn)
            let btnImg = UIImageView(image: UIImage(named: img))
            btnImg.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(45)
                layout.height = YGValue(45)
            }
            btn.addSubview(btnImg)
        }
        
        
        self.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 关闭弹窗
    @objc func closedAction(_ btn: UIButton) {
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.viewWithTag(110)?.removeFromSuperview()
    }
    
    // 跳转页面
    @objc func jumpPage (_ btn : UIButton) {
        let tab = window!.rootViewController
        let nav = tab!.children[0].children[0].navigationController
        let result = SearchResultController.init()
        result.platform = btn.tag
        result.hidesBottomBarWhenPushed = true
        nav!.pushViewController(result, animated: true)
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.viewWithTag(110)?.removeFromSuperview()
    }
    
}
