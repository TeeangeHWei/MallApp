//
//  privateShopView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/22.
//  Copyright © 2019 大杉网络. All rights reserved.
//

@available(iOS 11.0, *)
class PrivateShopView: ViewController {
    private var allHeight = 0
    private let link = UILabel()
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
        let navView = customNav(titleStr: "个人商城", titleColor: .white)
        navView.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        self.view.addSubview(navView)
        // 设置IDealist主题色
        IDealistConfig.share.id_setupMainColor(color: .red)
        let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - headerHeight))
        body.backgroundColor = .white
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - headerHeight)
            layout.position = .relative
        }
        self.view.addSubview(body)
        
        // bg
        let barBg = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 100))
        barBg.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        barBg.layer.masksToBounds = true
        barBg.layer.mask = barBg.configRectCorner(view: barBg, corner: [.bottomLeft, .bottomRight], radii: CGSize(width: 10, height: 10))
        barBg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = 100
            layout.position = .absolute
            layout.top = 0
            layout.left = 0
        }
        body.addSubview(barBg)
        
        // 链接
        let shopLink = UIView()
        shopLink.backgroundColor = .white
        shopLink.layer.cornerRadius = 5
        shopLink.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        shopLink.layer.shadowRadius = 8
        shopLink.layer.shadowOffset = CGSize(width: 5, height: 5)
        shopLink.layer.shadowOpacity = 0.1
        shopLink.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .center
            layout.alignItems = .flexStart
            layout.width = YGValue(kScreenW * 0.9)
            layout.padding = 30
            layout.paddingTop = 20
            layout.paddingBottom = 20
            layout.marginTop = 30
            layout.marginBottom = 20
        }
        body.addSubview(shopLink)
        let shopIcon = UIImageView(image: UIImage(named: "shop"))
        shopIcon.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(16)
            layout.height = YGValue(16)
            layout.marginRight = YGValue(10)
        }
        shopLink.addSubview(shopIcon)
        let shopInfo = UIView()
        shopInfo.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.9 - 86)
        }
        shopLink.addSubview(shopInfo)
        let shopName = UILabel()
        shopName.text = "赶紧省内部优惠券商城"
        shopName.font = FontSize(14)
        shopName.textColor = kMainTextColor
        shopName.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginBottom = 3
        }
        shopInfo.addSubview(shopName)
        if let rid = UserDefaults.getInfo()["relationId"] {
            link.text = "https://www.ganjinsheng.com/shop?relationId=\(rid)"
        } else {
            IDDialog.id_show(title: "", msg: "您还未授权，是否现在授权？", leftActionTitle: "取消", rightActionTitle: "确定", leftHandler: {
                print("点击了左边")
            }) {
                print("点击了右边")
            }
        }
        link.font = FontSize(14)
        link.textColor = kGrayTextColor
        link.numberOfLines = 0
        link.configureLayout { (layout) in
            layout.isEnabled = true
        }
        shopInfo.addSubview(link)
        
        // 复制按钮
        let copyBtn = UIButton()
        copyBtn.setTitle("复制链接", for: .normal)
        copyBtn.addTarget(self, action: #selector(copyLink), for: .touchUpInside)
        copyBtn.titleLabel?.font = FontSize(14)
        copyBtn.backgroundColor = kLowOrangeColor
        copyBtn.layer.cornerRadius = 5
        copyBtn.setTitleColor(.white, for: .normal)
        copyBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.6)
            layout.height = YGValue(40)
            layout.marginBottom = 10
        }
        body.addSubview(copyBtn)
        // 分享按钮
        let shareBtn = UIButton()
        shareBtn.setTitle("立即分享商城", for: .normal)
        shareBtn.addTarget(self, action: #selector(shareBox), for: .touchUpInside)
        shareBtn.titleLabel?.font = FontSize(14)
        shareBtn.backgroundColor = .clear
        shareBtn.layer.cornerRadius = 5
        shareBtn.setTitleColor(kLowOrangeColor, for: .normal)
        shareBtn.layer.borderColor = kLowOrangeColor.cgColor
        shareBtn.layer.borderWidth = 1
        shareBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.6)
            layout.height = YGValue(40)
            layout.marginBottom = 10
        }
        body.addSubview(shareBtn)
        // 访问按钮
        let visitBtn = UIButton()
        visitBtn.setTitle("访问个人商城", for: .normal)
        visitBtn.addTarget(self, action: #selector(visitShop), for: .touchUpInside)
        visitBtn.titleLabel?.font = FontSize(14)
        visitBtn.backgroundColor = .clear
        visitBtn.layer.cornerRadius = 5
        visitBtn.setTitleColor(kLowOrangeColor, for: .normal)
        visitBtn.layer.borderColor = kLowOrangeColor.cgColor
        visitBtn.layer.borderWidth = 1
        visitBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.6)
            layout.height = YGValue(40)
            layout.marginBottom = 10
        }
        body.addSubview(visitBtn)
        
        
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight + 80), right: CGFloat(0))
        body.yoga.applyLayout(preservingOrigin: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // 复制链接
    @objc func copyLink (_ btn: UIButton) {
        UIPasteboard.general.string = link.text
        IDToast.id_show(msg: "复制成功", success: .success)
    }

    // 分享弹窗模块
    @objc func shareBox(_ btn : UIButton){
        var type = btn.tag
        var data = ShareSdkModel()
        data.title = "赶紧省"
        data.content = "赶紧省内部优惠券商城"
        data.url = link.text
        data.type = .webPage
        data.image = UIImage(named: "logo")
        let ShareBox = ShareSdkView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH), data: data)
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.addSubview(ShareBox)
    }
    
    // 进入个人商城
    @objc func visitShop (_ btn: UIButton) {
        let vc = ShopH5Controller()
        vc.webAddress = link.text!
        navigationController?.pushViewController(vc, animated: true)
    }
}
