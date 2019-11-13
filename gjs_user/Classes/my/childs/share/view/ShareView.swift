//
//  shareView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/27.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class ShareView: UIScrollView {
    var allHeight = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        let body = self
        body.backgroundColor = .white
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - headerHeight)
            layout.position = .relative
        }
        // bg
        let barBg = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 140))
        barBg.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        barBg.layer.masksToBounds = true
        barBg.layer.mask = barBg.configRectCorner(view: barBg, corner: [.bottomLeft, .bottomRight], radii: CGSize(width: 10, height: 10))
        barBg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.justifyContent = .center
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = 140
        }
        body.addSubview(barBg)
        // 邀请码
        let invite = UIView()
        invite.layer.contents = UIImage(named:"share-1")?.cgImage
        invite.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.width = YGValue(kScreenW * 0.7)
            layout.height = YGValue(kScreenW * 0.7 * 0.25)
        }
        barBg.addSubview(invite)
        let inviteCode = UIView()
        inviteCode.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.justifyContent = .center
            layout.width = YGValue(kScreenW * 0.7 * 0.76)
            layout.height = YGValue(kScreenW * 0.7 * 0.25)
        }
        invite.addSubview(inviteCode)
        allHeight += 140
        let codeKey = UILabel()
        codeKey.text = "我的邀请码:"
        codeKey.textColor = kLowOrangeColor
        codeKey.font = FontSize(14)
        codeKey.configureLayout { (layout) in
            layout.isEnabled = true
        }
        inviteCode.addSubview(codeKey)
        let codeValue = UILabel()
        codeValue.text = UserDefaults.getInfo()["inviteCode"] as! String
        codeValue.textColor = kLowOrangeColor
        codeValue.font = FontSize(18)
        codeValue.configureLayout { (layout) in
            layout.isEnabled = true
        }
        inviteCode.addSubview(codeValue)
        // 复制按钮
        let inviteCopy = UIButton()
        inviteCopy.setTitle("复\n制", for: .normal)
        inviteCopy.addTarget(self, action: #selector(copyCode), for: .touchUpInside)
        inviteCopy.setTitleColor(kLowOrangeColor, for: .normal)
        inviteCopy.titleLabel?.numberOfLines = 0
        inviteCopy.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.7 * 0.24)
        }
        invite.addSubview(inviteCopy)
        
        
        
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight + 80), right: CGFloat(0))
        body.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func copyCode(_ sender:UIButton!){
        UIPasteboard.general.string = UserDefaults.getInfo()["inviteCode"] as! String
        IDToast.id_show(msg: "复制成功", success: .success)
    }
    
}
