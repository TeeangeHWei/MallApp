//
//  newThisWeek.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/29.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class NewThisWeek: UIView {
    
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
        title.text = "本周最新"
        title.font = FontSize(16)
        title.textColor = kMainTextColor
        title.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginBottom = 10
        }
        self.addSubview(title)
        
        var swiperHeight = 0
        let swiper = UIScrollView()
        swiper.showsHorizontalScrollIndicator = false
        swiper.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.width = YGValue(kScreenW)
            layout.height = YGValue((kScreenW * 0.7)/3 + 48)
        }
        self.addSubview(swiper)
        for item in newWeekDataList {
            let swiperItem : UIView = UIView()
            swiperItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(kScreenW * 0.7)
                layout.height = YGValue((kScreenW * 0.7)/3 + 48)
                layout.marginRight = 10
            }
            swiper.addSubview(swiperItem)
            let itemImg : UIImageView = UIImageView()
            itemImg.layer.cornerRadius = 3
            itemImg.layer.masksToBounds = true
            let url = URL(string: item.article_banner!)!
            let placeholderImage = UIImage(named: "loading")
            itemImg.af_setImage(withURL: url, placeholderImage: placeholderImage)
            itemImg.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(kScreenW * 0.7)
                layout.height = YGValue((kScreenW * 0.7)/3)
            }
            swiperItem.addSubview(itemImg)
            let itemTitle : UILabel = UILabel()
            itemTitle.text = item.article
            itemTitle.font = FontSize(14)
            itemTitle.textColor = kMainTextColor
            itemTitle.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(kScreenW * 0.7)
                layout.height = 28
            }
            swiperItem.addSubview(itemTitle)
            // 作者信息
            let author : UIView = UIView()
            author.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(kScreenW * 0.7)
                layout.flexDirection = .row
                layout.justifyContent = .spaceBetween
                layout.alignItems = .center
            }
            swiperItem.addSubview(author)
            // 头像姓名
            let authorLeft = UIView()
            authorLeft.configureLayout { (layout) in
                layout.isEnabled = true
                layout.flexDirection = .row
                layout.alignItems = .center
            }
            author.addSubview(authorLeft)
            let authorAvatar = UIImageView()
            authorAvatar.layer.cornerRadius = 10
            authorAvatar.layer.masksToBounds = true
            let url1 = URL(string: item.head_img!)!
            authorAvatar.af_setImage(withURL: url1, placeholderImage: placeholderImage)
            authorAvatar.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = 20
                layout.height = 20
                layout.marginRight = 5
            }
            authorLeft.addSubview(authorAvatar)
            let authorName = UILabel()
            authorName.text = item.talent_name
            authorName.font = FontSize(12)
            authorName.configureLayout { (layout) in
                layout.isEnabled = true
            }
            authorLeft.addSubview(authorName)
            // 查看详情
            let more = UILabel()
            more.text = "查看详情"
            more.font = FontSize(12)
            more.textColor = kLowGrayColor
            more.configureLayout { (layout) in
                layout.isEnabled = true
            }
            author.addSubview(more)
            
            
            swiperHeight += Int(kScreenW * 0.7) + 10
        }
        swiper.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(0), right: CGFloat(swiperHeight + 20))
        
        
        self.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
