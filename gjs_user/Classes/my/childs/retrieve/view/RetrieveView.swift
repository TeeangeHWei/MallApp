//
//  retrieveView.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/8/19.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class RetrieveView: ViewController, UIScrollViewDelegate {

    var inputVal = UITextField();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navView = customNav(titleStr: "找回订单", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - headerHeight))
        self.view.backgroundColor = kBGGrayColor
        let typeBar = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 150))
        typeBar.backgroundColor = .white
        //bg
        let barBg = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 100))
        barBg.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        barBg.layer.masksToBounds = true
        barBg.layer.mask = barBg.configRectCorner(view: barBg, corner: [.bottomLeft, .bottomRight], radii: CGSize(width: 10, height: 10))
        //input
        let inputBox = UIView(frame: CGRect(x: 20, y: 30, width: kScreenW - 40, height: 105))
        inputBox.backgroundColor = .white
        inputBox.layer.cornerRadius = 5
        inputBox.layer.borderColor = kBGGrayColor.cgColor
        inputBox.layer.borderWidth = 1
        inputBox.layer.shadowColor = kBGGrayColor.cgColor
        inputBox.layer.shadowOffset = CGSize(width: 0, height: 2)
        inputBox.layer.shadowOpacity = 1
        
        let inputTip = UILabel(frame:CGRect(x:20, y:8, width:kScreenW - 80, height:50));
        inputTip.font = FontSize(14)
        inputTip.textColor = kMainTextColor
        inputTip.text="未获得佣金的订单需手动找回才可获得佣金"
        
        inputVal.frame = CGRect(x:15, y:55, width:kScreenW - 140, height:32)
        inputVal.placeholder="    输入淘宝订单号"
        inputVal.font = FontSize(14)
        inputVal.layer.cornerRadius = 16
        inputVal.layer.borderWidth = 2
        inputVal.layer.borderColor = kLowOrangeColor.cgColor
        inputVal.clearButtonMode = .whileEditing
        inputVal.setValue(NSNumber(value: 14), forKey: "paddingLeft")
        
        let inputBtn = UIButton(frame: CGRect(x:kScreenW - 120, y:55, width:65, height:32))
        inputBtn.setTitle("找回", for: .normal)
        inputBtn.layer.cornerRadius = 16
        inputBtn.titleLabel?.font = FontSize(14)
        inputBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        inputBtn.addTarget(self, action: #selector(retrieveClick(sender:)), for: .touchUpInside)
        
        inputBox.addSubview(inputBtn)
        inputBox.addSubview(inputTip)
        inputBox.addSubview(inputVal)
        
        //retrieveDemo
        let reBox = UIView(frame: CGRect(x:0,y:160,width: kScreenW, height: 650))
        reBox.backgroundColor = .white
        
        let reTitle = UILabel(frame: CGRect(x:0,y:20,width: kScreenW, height: 10))
        reTitle.font = FontSize(16)
        reTitle.textColor = kMainTextColor
        reTitle.textAlignment = .center
        reTitle.text = "如何获取订单编号？"
        
        //第一部分
        let reFirst = UIView(frame: CGRect(x:20,y:50,width: kScreenW, height: 20))
        self.step(parent: reFirst, numStr: "1", textStr: "打开“手机淘宝”App-我的淘宝-查看我的订单", imgStr: "retrieve-1")
        
        //第二部分
        let reSecond = UIView(frame: CGRect(x:20,y:340,width: kScreenW, height: 20))
        self.step(parent: reSecond, numStr: "2", textStr: "复制订单编号", imgStr: "retrieve-2")
        
        reBox.addSubview(reTitle)
        reBox.addSubview(reFirst)
        reBox.addSubview(reSecond)
        
        typeBar.addSubview(barBg)
        typeBar.addSubview(inputBox)
        
        scrollView.addSubview(typeBar)
        scrollView.addSubview(reBox)
        self.view.addSubview(scrollView)
        scrollView.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(850), right: CGFloat(0))
    }
    
    func step(parent:UIView,numStr:String,textStr:String,imgStr:String){
        let num = UILabel(frame: CGRect(x:0,y:-5,width: 20, height: 20))
        num.font = FontSize(14)
        num.text = numStr
        num.backgroundColor = kLowOrangeColor
        num.textColor = .white
        num.layer.masksToBounds = true
        num.layer.cornerRadius = 10
        num.textAlignment = .center
        
        let text = UILabel(frame: CGRect(x:26,y:0,width: kScreenW-30, height: 10))
        text.font = FontSize(14)
        text.textColor = kMainTextColor
        text.text = textStr
        
        let img = UIImageView(image: UIImage(named: imgStr))
        img.frame = CGRect(x: 0, y: 30, width: kScreenW-40, height: 240)
        img.contentMode = .scaleAspectFit
        
        parent.addSubview(num)
        parent.addSubview(text)
        parent.addSubview(img)
    }
    
    // 点击找回，传递参数
    @objc func retrieveClick(sender:UITapGestureRecognizer){
        if inputVal.text == ""{
            IDToast.id_show(msg: "请输入订单号")
            return
        }
        let vc = RetrieveResultView()
        vc.setParams(valueStr: inputVal.text!)
        navigationController?.pushViewController(vc, animated: true)
    }

}
