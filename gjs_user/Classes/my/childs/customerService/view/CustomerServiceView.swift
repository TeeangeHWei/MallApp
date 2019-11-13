//
//  CustomerServiceView.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/8/21.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class CustomerServiceView: ViewController, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let navView = customNav(titleStr: "客服专线", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - headerHeight))
        //背景图片
        let bgImage = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
        bgImage.image = UIImage(named: "customerServiceBg")
        bgImage.contentMode = .scaleAspectFill
        
        let img = UIImageView(image: UIImage(named: "customerService"))
        img.frame = CGRect(x: 20, y: 30, width: kScreenW - 40, height: kScreenW)
        img.contentMode = .scaleAspectFit
        
        let box_1 = UIView(frame: CGRect(x: 40, y: kScreenW + 60, width: kScreenW - 80, height: 80))
        box_1.backgroundColor = kHighOrangeColor
        box_1.layer.cornerRadius = 10
        
        let boxImg_1 = UIImageView(image: UIImage(named: "wechat"))
        boxImg_1.frame = CGRect(x: 25, y: 15, width: 50, height: 50)
        
        let boxText = UIView(frame: CGRect(x: 85, y: 10, width: kScreenW - 240, height: 60))
        let boxText_1 = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenW - 240, height: 30))
        boxText_1.text = "专属客服微信"
        boxText_1.font = BoldFontSize(18)
        boxText_1.textColor = .white
        let boxText_2 = UILabel(frame: CGRect(x: 0, y: 30, width: kScreenW - 245, height: 30))
        boxText_2.text = "ganjinsheng-ds"
        boxText_2.font = BoldFontSize(14)
        boxText_2.textColor = .white
        
        boxText.addSubview(boxText_1)
        boxText.addSubview(boxText_2)
        
        let qrImg = UIImageView(image: UIImage(named: "customerServiceQr"))
        qrImg.frame = CGRect(x: kScreenW - 155, y: 15, width: 50, height: 50)
        
        box_1.addSubview(boxImg_1)
        box_1.addSubview(boxText)
        box_1.addSubview(qrImg)
        
        let box_2 = UIButton(frame: CGRect(x: 40, y: kScreenW + 180, width: kScreenW - 80, height: 50))
        box_2.backgroundColor = kHighOrangeColor
        box_2.layer.cornerRadius = 25
        box_2.addTarget(self, action: #selector(copyWechat), for: .touchUpInside)
        let text = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenW - 80, height: 50))
        text.text = "复制客服微信"
        text.font = BoldFontSize(18)
        text.textColor = .white
        text.textAlignment = .center
        
        box_2.addSubview(text)
        
        scrollView.insertSubview(bgImage, at: 0)
        scrollView.addSubview(img)
        scrollView.addSubview(box_1)
        scrollView.addSubview(box_2)
        self.view.addSubview(scrollView)
        scrollView.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(kScreenW+240), right: CGFloat(0))
    }
    
    @objc func copyWechat (_ btn: UIButton) {
        UIPasteboard.general.string = "ganjinsheng-ds"
        IDDialog.id_show(title: nil, msg: "复制成功！是否前往微信？", leftActionTitle: "取消", rightActionTitle: "确定", leftHandler: {
        }) {
            let urlString = "weixin://"
            let url = NSURL(string: urlString)
            UIApplication.shared.openURL(url! as URL)
        }
    }
    
}
