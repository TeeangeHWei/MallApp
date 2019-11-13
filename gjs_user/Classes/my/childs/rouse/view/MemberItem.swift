//
//  memberItem.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/31.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class MemberItem : UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, data: MemberItemData) {
        self.init(frame: frame)
        
        self.backgroundColor = .white
        self.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = 80
            layout.paddingLeft = 15
        }
        let avatar = UIImageView()
        let url = URL(string: UrlFilter(data.headPortrait!))!
        let placeholderImage = UIImage(named: "loading")
        avatar.af_setImage(withURL: url, placeholderImage: placeholderImage)
        avatar.layer.cornerRadius = 30
        avatar.layer.masksToBounds = true
        avatar.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 60
            layout.height = 60
            layout.marginRight = 10
        }
        self.addSubview(avatar)
        let info = UIView()
        info.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.justifyContent = .spaceBetween
            layout.width = YGValue(kScreenW - 100)
            layout.height = 50
        }
        self.addSubview(info)
        // 昵称和会员等级
        let name = UIView()
        name.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        info.addSubview(name)
        let nameLabel = UILabel()
        nameLabel.text = data.nickName!
        nameLabel.font = FontSize(14)
        nameLabel.textColor = kMainTextColor
        nameLabel.configureLayout { (layout) in
            layout.isEnabled = true
        }
        name.addSubview(nameLabel)
        let vipIcon = UIImageView()
        if data.memberStatus! == "1" {
            vipIcon.image = UIImage(named: "grade-1")
        } else if data.memberStatus! == "2" {
            vipIcon.image = UIImage(named: "grade-2")
        } else {
            vipIcon.image = UIImage(named: "grade-3")
        }
        vipIcon.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 14
            layout.width = 56
            layout.marginLeft = 10
        }
        name.addSubview(vipIcon)
        // 手机号码和日期
        let phone = UIView()
        phone.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        info.addSubview(phone)
        let phoneNum = UILabel()
        phoneNum.text = data.phone!
        phoneNum.font = FontSize(12)
        phoneNum.textColor = kGrayTextColor
        phoneNum.configureLayout { (layout) in
            layout.isEnabled = true
        }
        phone.addSubview(phoneNum)
        let createTime = UILabel()
        let time = getDateFromTimeStamp(timeStamp: data.createTime!)
        createTime.text = time.format("yyyy/MM/dd HH:mm:ss")
        createTime.font = FontSize(12)
        createTime.textColor = kGrayTextColor
        createTime.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginLeft = 10
        }
        phone.addSubview(createTime)
        
        
        self.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
