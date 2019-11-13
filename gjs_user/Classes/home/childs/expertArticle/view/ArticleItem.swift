//
//  ArticleItem.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/29.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class ArticleItem: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(frame: CGRect, data: ArticleItemData) {
//        super.init(frame: frame)
        self.init(frame: frame)
        self.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(120)
            layout.padding = 10
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        // 文章封面
        let cover = UIImageView()
        cover.layer.cornerRadius = 5
        cover.layer.masksToBounds = true
        let url = URL(string: data.image!)!
        let placeholderImage = UIImage(named: "loading")
        cover.af_setImage(withURL: url, placeholderImage: placeholderImage)
        cover.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(100)
            layout.height = YGValue(100)
        }
        self.addSubview(cover)
        // 文章信息
        let info = UIView()
        info.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.justifyContent = .spaceBetween
            layout.width = YGValue(kScreenW - 140)
            layout.marginLeft = 10
            layout.height = YGValue(100)
        }
        self.addSubview(info)
        // 文章标题
        let infoTop = UIView()
        infoTop.configureLayout { (layout) in
            layout.isEnabled = true
        }
        info.addSubview(infoTop)
        let title = UILabel()
        title.text = data.article
        title.font = FontSize(14)
        title.textColor = kMainTextColor
        title.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 140)
        }
        infoTop.addSubview(title)
        let brief = UILabel()
        brief.text = data.shorttitle
        brief.font = FontSize(14)
        brief.textColor = kLowGrayColor
        brief.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 140)
            layout.marginTop = 15
        }
        infoTop.addSubview(brief)
        let infoBottom = UIView()
        infoBottom.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.width = YGValue(kScreenW - 140)
        }
        info.addSubview(infoBottom)
        // 宝贝数
        let goodsNum = UIView()
        goodsNum.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        infoBottom.addSubview(goodsNum)
        let goodsIcon = UIImageView(image: UIImage(named: "goodsNum"))
        goodsIcon.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 14
            layout.height = 11.2
            layout.marginRight = 3
        }
        goodsNum.addSubview(goodsIcon)
        let goodsLabel = UILabel()
        goodsLabel.text = "\(data.itemnum!)件好货源"
        goodsLabel.font = FontSize(12)
        goodsLabel.textColor = kLowGrayColor
        goodsLabel.configureLayout { (layout) in
            layout.isEnabled = true
        }
        goodsNum.addSubview(goodsLabel)
        // 浏览量
        let readNum = UIView()
        readNum.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        infoBottom.addSubview(readNum)
        let readIcon = UIImageView(image: UIImage(named: "readNum"))
        readIcon.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 14
            layout.height = 11.2
            layout.marginRight = 3
        }
        readNum.addSubview(readIcon)
        let readLabel = UILabel()
        readLabel.text = "\(data.readtimes!)人"
        readLabel.font = FontSize(12)
        readLabel.textColor = kLowGrayColor
        readLabel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        readNum.addSubview(readLabel)
        self.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

