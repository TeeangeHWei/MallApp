//
//  CourseController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/27.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class CourseController: ViewController, UIScrollViewDelegate {
    var allHeight = 0
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
        let navView = customNav(titleStr: "新手教程", titleColor: .white)
        navView.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        self.view.addSubview(navView)
        let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - headerHeight))
        body.backgroundColor = .white
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - headerHeight)
            layout.paddingBottom = 46
            layout.position = .relative
        }
        self.view.addSubview(body)
        
        let course1 = UIImageView(image: UIImage(named: "course-1"))
        course1.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenW * 0.495)
        }
        body.addSubview(course1)
        allHeight += Int(kScreenW * 0.495)
        
        let setpArr = [
            [
                "title": "01省钱第一步",
                "content": "在淘宝中复制宝贝标题，或者点击分享，复制链接"
            ],
            [
                "title": "02省钱第二步",
                "content": "复制宝贝标题或商品链接后，打开赶紧省"
            ],
            [
                "title": "03省钱第三步",
                "content": "点击自动识别出来的宝贝搜索"
            ],
            [
                "title": "04省钱第四步",
                "content": "领券下单省钱，分享更能赚钱"
            ],
        ]
        for (index, item) in setpArr.enumerated() {
            let title = UILabel()
            title.text = item["title"]
            title.font = FontSize(18)
            title.configureLayout { (layout) in
                layout.isEnabled = true
                layout.marginTop = 20
                layout.marginLeft = 15
            }
            body.addSubview(title)
            let content = UILabel()
            content.text = item["content"]
            content.font = FontSize(14)
            content.textColor = kGrayTextColor
            content.configureLayout { (layout) in
                layout.isEnabled = true
                layout.marginTop = 10
                layout.marginLeft = 15
            }
            body.addSubview(content)
            let imgName = "course-\(index + 2)"
            let img = UIImageView(image: UIImage(named: imgName))
            img.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(kScreenW - 30)
                layout.height = YGValue((kScreenW - 30) * 0.44)
                layout.marginTop = 10
                layout.marginLeft = 15
            }
            body.addSubview(img)
            let imgH = Int((kScreenW - 30) * 0.44)
            allHeight += 65 + imgH
        }
        
        body.delegate = self
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight + 80), right: CGFloat(0))
        body.yoga.applyLayout(preservingOrigin: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // 修改系统状态栏字颜色为白色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
//    func setNavigation () {
//        setNav(titleStr: "新手教程", titleColor: UIColor.white, navItem: navigationItem, navController: navigationController)
//        navigationController?.navigationBar.apply(gradient: kGradientColors)
//        navigationController?.navigationBar.tintColor = .white
//    }

}
