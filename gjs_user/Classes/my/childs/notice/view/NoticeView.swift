//
//  noticeView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/20.
//  Copyright © 2019 大杉网络. All rights reserved.
//

class NoticeView: ViewController, UIScrollViewDelegate {
    private var allHeight = 0
    override func viewDidLoad() {
        let navView = customNav(titleStr: "官方公告", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - headerHeight))
        body.backgroundColor = kBGGrayColor
        body.addBorder(side: .top, thickness: 1, color: klineColor)
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - headerHeight)
            layout.paddingTop = 1
        }
        self.view.addSubview(body)
        
        // 渲染公告
        noticeItem(body)
        
        body.delegate = self
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight + 80), right: CGFloat(0))
        body.yoga.applyLayout(preservingOrigin: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    // 单个公告
    func noticeItem (_ father: UIScrollView) {
        let noticeItem = UIButton()
        noticeItem.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 20)
            layout.marginTop = YGValue(10)
            layout.marginLeft = YGValue(10)
        }
        father.addSubview(noticeItem)
        let noticeImg = UIImageView(image: UIImage(named: "noticeImg"))
        noticeImg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 20)
            layout.height = YGValue((kScreenW - 20) * 0.5)
        }
        noticeItem.addSubview(noticeImg)
    }
    
}
