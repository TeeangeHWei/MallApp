//
//  ScreenBarView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/15.
//  Copyright © 2019 大杉网络. All rights reserved.
//

protocol platformDelegate {
    func platformDelegatefuc(backMsg:Int)
}

class PlatformBar: UIView {

    var platform = 0
    var btnList = [UIButton]()
    
    // 定义一个符合改协议的代理对象
    var delegate:platformDelegate?
    func processMethod(platform:Int?){
        if((delegate) != nil){
            delegate?.platformDelegatefuc(backMsg: platform!)
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        
        // 筛选栏
        let platformBar = self
        platformBar.backgroundColor = .white
        platformBar.addBorder(side: .bottom, thickness: 1, color: klineColor)
        platformBar.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceAround
            layout.alignItems = .center
            layout.paddingLeft = 30
            layout.paddingRight = 30
            layout.width = YGValue(kScreenW)
            layout.height = 46
        }
        let platformList = ["淘宝","拼多多"]
        
        for (index, item) in platformList.enumerated() {
            let platformItem = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
            platformItem.tag = index
            platformItem.addTarget(self, action: #selector(platformChange), for: .touchUpInside)
            platformItem.setTitle(item, for: .normal)
            platformItem.titleLabel?.font = FontSize(14)
            platformItem.layer.cornerRadius = 15
            if index == 0 {
                platformItem.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
                platformItem.setTitleColor(.white, for: .normal)
            } else {
                platformItem.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), [UIColor.clear, UIColor.clear])
                platformItem.setTitleColor(kMainTextColor, for: .normal)
            }
            platformItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = 80
                layout.height = 30
            }
            platformBar.addSubview(platformItem)
            btnList.append(platformItem)
        }
        
        
        platformBar.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func platformChange (_ btn : UIButton) {
        var index = btn.tag
        btnList[platform].gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), [UIColor.clear, UIColor.clear])
        btnList[platform].setTitleColor(kMainTextColor, for: .normal)
        btnList[index].gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        btnList[index].setTitleColor(.white, for: .normal)
        platform = index
        // 触发回调函数
        processMethod(platform:platform)
    }
    
}
