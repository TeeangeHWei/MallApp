//
//  aboutView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/20.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class AboutView: ViewController {

    override func viewDidLoad() {
        let navView = customNav(titleStr: "关于", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - headerHeight))
        body.backgroundColor = kBGGrayColor
        body.addBorder(side: .top, thickness: 1, color: klineColor)
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - headerHeight)
            layout.paddingTop = 1
        }
        self.view.addSubview(body)
        
        // logo
        let logo = UIImageView(image: UIImage(named: "logo"))
        logo.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(100)
            layout.height = YGValue(100)
            layout.marginTop = YGValue(30)
        }
        body.addSubview(logo)
        
        // 当前版本
        let version = UIView()
        version.backgroundColor = .white
        version.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.paddingLeft = 15
            layout.paddingRight = 15
            layout.height = YGValue(50)
            layout.marginTop = YGValue(30)
        }
        body.addSubview(version)
        let key = UILabel()
        key.text = "当前版本"
        key.font = FontSize(14)
        key.configureLayout { (layout) in
            layout.isEnabled = true
        }
        version.addSubview(key)
        let value = UILabel()
        value.text = "1.0.0"
        value.font = FontSize(14)
        value.configureLayout { (layout) in
            layout.isEnabled = true
        }
        version.addSubview(value)
        
        body.yoga.applyLayout(preservingOrigin: true)
        
        let infoDictionary = Bundle.main.infoDictionary
        if let infoDictionary = infoDictionary {
            let appVersion = infoDictionary["CFBundleShortVersionString"]
            let appBuild = infoDictionary["CFBundleVersion"]
            print("version\(appVersion),build\(appBuild)")
        }
    }

}
