//
//  successView.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/8/20.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class RetrieveResultView: ViewController {

    private let mainView = UIView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - headerHeight))
    private var value:String = ""
    private let loading = UIActivityIndicatorView(style: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navView = customNav(titleStr: "找回结果", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        mainView.backgroundColor = kBGGrayColor
        self.view.addSubview(mainView)
        loadData()
    }
    
    func errorBox(parent:UIView) {
        mainView.subviews.forEach{$0.removeFromSuperview()}
        let tip = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 130))
        tip.backgroundColor = .white
        
        let img = UIImageView(image: UIImage(named: "close-danger"))
        img.frame = CGRect(x:0,y: 10,width: kScreenW,height: 55)
        img.contentMode = .scaleAspectFit
        
        let text = UILabel(frame: CGRect(x:0,y: 65,width: kScreenW, height: 50))
        text.text = "未查询到该订单"
        text.font = BoldFontSize(16)
        text.textColor = kLowOrangeColor
        text.textAlignment = .center
        
        tip.addSubview(img)
        tip.addSubview(text)
        
        let info = UIView(frame: CGRect(x:0,y:140,width: kScreenW,height: kScreenH-130))
        info.backgroundColor = .white
        let infoTitle = UILabel(frame: CGRect(x:25,y:15,width: kScreenW,height: 20))
        infoTitle.font = BoldFontSize(16)
        infoTitle.textColor = kMainTextColor
        infoTitle.text = "未查询到订单的可能原因："
        
        self.errorInfo(parent: info, infoStr: "1、订单号错误，请核对之后输入", rect: CGRect(x:28,y:40,width: kScreenW,height: 20))
        self.errorInfo(parent: info, infoStr: "2、订单有延迟，建议下单15分钟后查询", rect: CGRect(x:28,y:60,width: kScreenW,height: 20))
        self.errorInfo(parent: info, infoStr: "3、订单本身无佣金", rect: CGRect(x:28,y:80,width: kScreenW,height: 20))
        self.errorInfo(parent: info, infoStr: "4、下单超过15天无法找回", rect: CGRect(x:28,y:100,width: kScreenW,height: 20))
        
        info.addSubview(infoTitle)
        
        parent.addSubview(tip)
        parent.addSubview(info)
    }
    
    func errorInfo(parent:UIView,infoStr:String,rect:CGRect) {
        let info = UILabel(frame: rect)
        info.text = infoStr
        info.textColor = kMainTextColor
        info.font = FontSize(14)
        parent.addSubview(info)
    }
    
    func succBox(parent:UIView,data:OrderModel) {
        mainView.subviews.forEach{$0.removeFromSuperview()}
        let tip = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 75))
        tip.backgroundColor = .white
        
        let text = UILabel(frame: CGRect(x:25,y: 15,width: kScreenW - 45, height: 50))
        text.text = "找回成功！您可在“我的订单“中查看订单"
        text.textColor = kBGGreenColor
        text.font = BoldFontSize(16)
        text.lineBreakMode =  NSLineBreakMode.byWordWrapping
        text.numberOfLines = 0
        
        tip.addSubview(text)
        
        let info = UIView(frame: CGRect(x: 0, y: 85, width: kScreenW, height: kScreenH))
        info.backgroundColor = .white
        
        let infoTitle = UILabel(frame: CGRect(x: 0, y: 15, width: kScreenW, height: 20))
        infoTitle.text = "---------- 宝贝详情 ----------"
        infoTitle.textAlignment = .center
        
        //info_1
        let info_1 = UIView(frame: CGRect(x: 20, y: 45, width: kScreenW, height: 20))
        let img_1 = UIImageView(image: UIImage(named: "house"))
        img_1.frame = CGRect(x:0,y: -2,width: 18,height: 18)
        img_1.contentMode = .scaleAspectFit
        
        let text_1 = UILabel(frame: CGRect(x:23,y:0,width: kScreenW-25,height: 18))
        text_1.text = data.sellerShopTitle!
        text_1.font = FontSize(14)
        
        info_1.addSubview(img_1)
        info_1.addSubview(text_1)
        
        //info_2
        let info_2 = UIView(frame: CGRect(x: 20, y: 75, width: kScreenW, height: 80))
        let img_2 = UIImageView(frame: CGRect(x:0,y: -2,width: 80,height: 80))
        let url = URL(string: ("http://" + data.itemLink!.id_subString(from: 2)))!
        let placeholderImage = UIImage(named: "loading")
        img_2.af_setImage(withURL: url, placeholderImage: placeholderImage)
        img_2.contentMode = .scaleAspectFit
        img_2.layer.masksToBounds = true
        img_2.layer.cornerRadius = 2
        
        let 	textView_1 = UIView(frame: CGRect(x: 90, y: 0, width: kScreenW-90, height: 50))
        let textView_1_1 = UILabel()
        textView_1_1.font = FontSize(12)
        textView_1_1.textColor = kGrayTextColor
        if(data.itemTitle!.count < 20){
            textView_1_1.text = data.itemTitle!
        }else{
            textView_1_1.text = data.itemTitle!.id_subString(from: 0, offSet: 20) + "..."
        }
        textView_1_1.lineBreakMode =  NSLineBreakMode.byWordWrapping
        textView_1_1.numberOfLines = 5
        //动态获取行高
        let height_1_1 = getLabHeigh(labelStr: textView_1_1.text!, font: FontSize(12), width: kScreenW-180)
        textView_1_1.frame = CGRect(x: 0, y: 0, width: kScreenW-180, height: height_1_1)
        
        let textView_1_2 = UILabel(frame: CGRect(x: kScreenW-170, y: 0, width: 60, height: 50))
        textView_1_2.font = FontSize(16)
        textView_1_2.textColor = kMainTextColor
        textView_1_2.text = "¥ " + Commons.strToDoubleStr(str:data.itemPrice!)
        
        textView_1.addSubview(textView_1_1)
        textView_1.addSubview(textView_1_2)
        
        let textView_2 = UIView(frame: CGRect(x: 90, y: 50, width: kScreenW-90, height: 30))
        //底部边框
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 40, width: kScreenW-125, height: 1)
        layer.backgroundColor = klineColor.cgColor
        textView_2.layer.addSublayer(layer)
        let textView_2_1 = UILabel(frame: CGRect(x: 0, y: 0, width: 66, height: 40))
        textView_2_1.font = FontSize(16)
        textView_2_1.textColor = kMainTextColor
        textView_2_1.text = "成交价："
        let textView_2_2 = UILabel(frame: CGRect(x: 66, y: 0, width: 60, height: 40))
        textView_2_2.font = FontSize(16)
        textView_2_2.textColor = kLowOrangeColor
        textView_2_2.text = "¥ " + Commons.strToDoubleStr(str:data.itemPrice!)
        let textView_2_3 = UILabel(frame: CGRect(x: kScreenW-145, y: 0, width: 40, height: 40))
        textView_2_3.font = FontSize(16)
        textView_2_3.textColor = kMainTextColor
        textView_2_3.text = "x " + data.itemNum!
        
        textView_2.addSubview(textView_2_1)
        textView_2.addSubview(textView_2_2)
        textView_2.addSubview(textView_2_3)
        
        info_2.addSubview(img_2)
        info_2.addSubview(textView_1)
        info_2.addSubview(textView_2)
        
        self.timeText(parent: info, yVaule: 185, key: "创建时间", value: data.createTime!)
        self.timeText(parent: info, yVaule: 205, key: "付款时间", value: data.tkPaidTime!)
        self.timeText(parent: info, yVaule: 225, key: "结算时间", value: data.earningTime!)
        
        info.addSubview(infoTitle)
        info.addSubview(info_1)
        info.addSubview(info_2)
        
        parent.addSubview(tip)
        parent.addSubview(info)
    }

    //计算不同时间
    func timeText(parent:UIView,yVaule:Int,key:String,value:String){
        let timeView = UIView(frame:CGRect(x: 20, y: yVaule, width: Int(kScreenW - 40), height: 20))
        let timeLabel = UILabel(frame:CGRect(x: 0, y: 0, width: timeView.frame.width, height: 20))
        let createTime = getDateFromTimeStamp(timeStamp: value)
        timeLabel.text = key + "：" + createTime.format("yyyy-MM-dd HH:mm:ss")
        timeLabel.textColor = kMainTextColor
        timeLabel.font = FontSize(14)
        timeView.addSubview(timeLabel)
        parent.addSubview(timeView)
    }
    
    func setParams(valueStr:String){
        self.value = valueStr
    }
    
    //加载中
    func setLoading(){
        loading.frame = CGRect(x: 0, y: 0, width: Int(kScreenW), height: 50)
        loading.isHidden = false
        loading.color = .darkGray
        loading.hidesWhenStopped = true
        loading.startAnimating()
        mainView.addSubview(loading)
    }
    
    func loadData(){
        setLoading()
        AlamofireUtil.post(url: "/user/order/findOrder",
        param: ["tradeId":value],
        success: { (res, data) in
            self.loading.stopAnimating()
            let order:OrderModel = OrderModel.deserialize(from: data.description)!
            self.succBox(parent: self.mainView,data:order)
        },
        error: {
            self.loading.stopAnimating()
            self.errorBox(parent: self.mainView)
        },
        failure: {
            self.navigationController?.popViewController(animated: true)
        })
    }
}
