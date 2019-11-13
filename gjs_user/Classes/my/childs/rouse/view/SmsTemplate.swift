//
//  SmsTemplate.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/2.
//  Copyright © 2019 大杉网络. All rights reserved.
//

class SmsTemplate: UIView {

    let templateList = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, nav: UINavigationController?) {
        self.init(frame: frame)
        
        let body = UIView()
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
        }
        self.addSubview(body)
        // 标题
        let title = UILabel()
        title.text = "发送短信模板"
        title.font = FontSize(14)
        title.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 20
            layout.marginTop = 15
            layout.marginBottom = 15
        }
        body.addSubview(title)
        
        // 短信模板轮播
        var allWidth = 0
        
        templateList.showsHorizontalScrollIndicator = false
        templateList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.width = YGValue(kScreenW)
            layout.height = 320
            layout.position = .relative
        }
        body.addSubview(templateList)
        // 指示器列表
        let indicator = UIView()
        indicator.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .center
            layout.alignItems = .center
            layout.paddingLeft = 5
            layout.marginTop = 15
        }
        body.addSubview(indicator)
        for _ in 1...5 {
            let templateItem = setItem()
            templateList.addSubview(templateItem)
            let indicatorItem = setIndicator()
            indicator.addSubview(indicatorItem)
            allWidth += Int(kScreenW)
        }
        
        
        templateList.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allWidth), right: CGFloat(allWidth))
        // 分页滚动
        templateList.isPagingEnabled = true
        // 开启滚动
        templateList.isScrollEnabled = true
        
        // 左右箭头
        setArrow()
        
        let reminder = UILabel()
        reminder.text = "推荐发给所有会员"
        reminder.font = FontSize(14)
        reminder.textColor = kLowOrangeColor
        reminder.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginTop = 15
        }
        body.addSubview(reminder)
        
        
        
        body.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setItem () -> UIView {
        let templateItem = UIView()
        templateItem.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.alignItems = .center
            layout.height = 320
        }
        let bubble = UIView()
        bubble.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.width = YGValue(kScreenW * 0.7)
            layout.height = 320
        }
        templateItem.addSubview(bubble)
        // 内容区域
        let bubbleContent = UIView()
        bubbleContent.backgroundColor = .white
        bubbleContent.layer.cornerRadius = 10
        bubbleContent.layer.masksToBounds = true
        bubbleContent.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.7)
            layout.height = 300
            layout.paddingTop = 15
            layout.paddingBottom = 15
            layout.position = .relative
        }
        bubble.addSubview(bubbleContent)
        for _ in 1...9 {
            let line = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.7, height: 30))
            line.drawDashLine(strokeColor: klineColor, lineWidth: 1, lineLength: 2, lineSpacing: 2, corners: .bottom)
            line.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(kScreenW * 0.7)
                layout.height = 30
            }
            bubbleContent.addSubview(line)
        }
        let content = UILabel()
        let str = "分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案分享文案"
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 13.5
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.paragraphStyle: paraph]
        content.attributedText = NSAttributedString(string: str, attributes: attributes)
        content.numberOfLines = 9
        content.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.7 - 30)
            layout.position = .absolute
            layout.left = 15
            layout.top = 21.75
        }
        bubbleContent.addSubview(content)
        // 三角形
        let triangle = UIImageView(image: UIImage(named: "triangle"))
        triangle.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 33.6
            layout.height = 20
        }
        bubble.addSubview(triangle)
        
        return templateItem
    }
    
    func setIndicator () -> UIView {
        let indicatorItem = UIView()
        indicatorItem.layer.cornerRadius = 5
        indicatorItem.layer.masksToBounds = true
//        indicatorItem.backgroundColor = kGrayTextColor
        indicatorItem.layer.borderWidth = 1
        indicatorItem.layer.borderColor = kGrayTextColor.cgColor
        indicatorItem.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 10
            layout.height = 10
            layout.marginRight = 5
        }
        return indicatorItem
    }
    
    // 左右箭头
    func setArrow () {
        let leftBtn = UIButton()
        leftBtn.tag = 1
        leftBtn.addTarget(self, action: #selector(cutTemplate), for: .touchUpInside)
        leftBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.position = .absolute
            layout.width = 15
            layout.height = 27
            layout.left = 20
            layout.top = 150
        }
        templateList.addSubview(leftBtn)
        let arrowLeft = UIImageView(image: UIImage(named: "arrow-left"))
        arrowLeft.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 15
            layout.height = 27
        }
        leftBtn.addSubview(arrowLeft)
        let rightBtn = UIButton()
        rightBtn.tag = 2
        rightBtn.addTarget(self, action: #selector(cutTemplate), for: .touchUpInside)
        rightBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.position = .absolute
            layout.width = 15
            layout.height = 27
            layout.right = 20
            layout.top = 150
        }
        templateList.addSubview(rightBtn)
        let arrowRight = UIImageView(image: UIImage(named: "arrow-right"))
        arrowRight.isUserInteractionEnabled = false
        arrowRight.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 15
            layout.height = 27
        }
        rightBtn.addSubview(arrowRight)
    }
    
    // 左右切换
    @objc func cutTemplate (_ btn : UIButton) {
        if btn.tag == 1 {
            UIView.animate(withDuration: 0.3) {
                self.templateList.contentOffset = CGPoint(x: kScreenW, y: 0)
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.templateList.contentOffset = CGPoint(x: -kScreenW, y: 0)
            }
        }
    }
}
