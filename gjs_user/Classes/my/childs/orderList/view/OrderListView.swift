//
//  orderListView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/15.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class OrderListView: ViewController, UIScrollViewDelegate, platformDelegate {
    
    var isCancel = false
    var platform = 0 // 0 淘宝  1 拼多多
    private var allHeight = 0
    private let body = UIScrollView()
    private let endStr = UILabel()
    private let noMessage = UIView()
    private let loading = UIActivityIndicatorView(style: .white)
    private var isFinish = false
    
    // 切换消息类型相关
    private let layer = CALayer()
    private var typeArr = [UIButton]()
    private var type = -1
    
    //页数信息
    private var pageNo = 1
    private let pageSize = 10
    private var pages = 2
    private var dataList:[OrderModel] = [OrderModel]()
    
    // MARK: - 动画结束时调用
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(CGFloat(allHeight) <= scrollView.contentOffset.y + scrollView.frame.height){
            if(pageNo <= pages){
                loadData()
            }else{
                noMore()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isCancel = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }
    
    override func viewDidLoad() {
        
        let navView = customNav(titleStr: "订单详情", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        
        let platformBar = PlatformBar(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: 46))
        platformBar.delegate = self
        view.addSubview(platformBar)
        
        let typeList = ["全部","已付款","已收货","已到账","已失效"]
        let typeBar = UIView(frame: CGRect(x: 0, y: headerHeight + 46, width: kScreenW, height: 46))
        typeBar.backgroundColor = .white
        typeBar.addBorder(side: .top, thickness: 1, color: klineColor)
        typeBar.addBorder(side: .bottom, thickness: 1, color: klineColor)
        for (index, item) in typeList.enumerated() {
            let width = kScreenW*0.2
            let x = CGFloat(index) * width
            let typeItem = UIButton(frame: CGRect(x: x, y: 0, width: width, height: 46))
            typeItem.setTitle(item, for: .normal)
            if(index == 0){
                typeItem.setTitleColor(kLowOrangeColor, for: .normal)
            }else{
                typeItem.setTitleColor(kGrayTextColor, for: .normal)
            }
            typeItem.addTarget(self, action: #selector(typeChange), for: .touchUpInside)
            typeItem.titleLabel?.font = FontSize(14)
            typeItem.tag = index
            typeArr.append(typeItem)
            typeBar.addSubview(typeItem)
        }
        //下划线
        let width = (kScreenW/5)-40
        layer.frame = CGRect(x: 20, y: 42, width: width, height: 4)
        layer.cornerRadius = 2
        layer.backgroundColor = kLowOrangeColor.cgColor
        typeBar.layer.addSublayer(layer)
        
        body.frame = CGRect(x: 0, y: headerHeight + 92, width: kScreenW, height: kScreenH - 92 - headerHeight)
        body.backgroundColor = kBGGrayColor
        body.delegate = self
        
        self.view.addSubview(typeBar)
        self.view.addSubview(body)
        setNoMessage()
        loadData()
    }
    
    //切换类型
    @objc func typeChange(_ btn: UIButton){
        let tag = btn.tag
        for item in typeArr {
            item.setTitleColor(kGrayTextColor, for: .normal)
        }
        btn.setTitleColor(kLowOrangeColor, for: .normal)
        switch tag {
        case 0:
            type = -1
            break
        case 1:
            type = 12
            break
        case 2:
            type = 0
            break
        case 3:
            type = 100
            break
        case 4:
            type = 13
            break
        default:
            break
        }
        UIView.animate(withDuration: 0.3) {
            let left = (kScreenW/5)*CGFloat(tag)
            self.layer.frame.origin.x = 20 + left
        }
        //刷新列表信息
        body.subviews.forEach{$0.removeFromSuperview()}
        allHeight = 0
        pages = 2
        pageNo = 1
        isFinish = false
        loadData()
    }
    
    func setItem(data:OrderModel){
        let orderItem = UIView()
        body.addSubview(orderItem)
        
        let orderNumBox = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW - 40, height: 36))
        let orderNum = UILabel()
        let orderType = UILabel()
        orderNumBox.addSubview(orderNum)
        orderNumBox.addSubview(orderType)
        orderItem.addSubview(orderNumBox)
        
        orderItem.backgroundColor = .white
        orderItem.layer.cornerRadius = 5
        orderItem.snp.makeConstraints { (make) in
            make.top.equalTo(allHeight+10)
            make.left.equalTo(10)
            make.width.equalTo(kScreenW - 20)
            make.height.equalTo(172)
        }
        // 订单号与状态
        orderNumBox.addBorder(side: .bottom, thickness: 1, color: klineColor)
        orderNumBox.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(36)
        }
        orderNum.text = "订单号：" + data.orderId!
        orderNum.font = FontSize(14)
        orderNum.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.height.equalToSuperview()
        }
        
        typeValue(data: data, label: orderType)
        orderType.font = FontSize(14)
        orderType.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.height.equalToSuperview()
        }
        
        // 订单内容
        let orderInfo = UIView()
        let goodsImg = UIImageView()
        let goodsName = UILabel()
        let goodsPrice = UILabel()
        let bonus = UILabel()
        orderInfo.addSubview(goodsImg)
        orderInfo.addSubview(goodsName)
        orderInfo.addSubview(goodsPrice)
        orderInfo.addSubview(bonus)
        orderItem.addSubview(orderInfo)
        
        orderInfo.tag = Int(data.itemId!)!
        orderInfo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toDetail(sender:))))
        orderInfo.snp.makeConstraints { (make) in
            make.top.equalTo(orderNumBox.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(80)
        }
        if (data.itemLink!) != nil && (data.itemLink!) != "" {
            var url = URL(string: data.itemLink!)!
            if platform == 0 {
                url = URL(string: "http://"+data.itemLink!.id_subString(from: 2))!
            }
            let placeholderImage = UIImage(named: "loading")
            goodsImg.af_setImage(withURL: url, placeholderImage: placeholderImage)
        } else {
            goodsImg.image = UIImage(named: "logo")
        }
        goodsImg.layer.masksToBounds = true
        goodsImg.layer.cornerRadius = 2
        goodsImg.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        goodsName.text = data.itemTitle!
        goodsName.font = FontSize(14)
        goodsName.snp.makeConstraints { (make) in
            make.left.equalTo(goodsImg.snp.right).offset(10)
            make.width.equalToSuperview().offset(-90)
        }
        
        goodsPrice.text = "¥" + ((data.itemPrice == nil) ? "0.00" : data.itemPrice!)
        goodsPrice.font = FontSize(16)
        goodsPrice.textColor = kLowOrangeColor
        goodsPrice.snp.makeConstraints { (make) in
            make.left.equalTo(goodsImg.snp.right).offset(10)
            make.bottom.equalTo(goodsImg.snp.bottom).offset(0)
        }
        bonusValue(data: data,label:bonus)
        bonus.textColor = kLowOrangeColor
        bonus.backgroundColor = kBGRedColor
        bonus.textAlignment = .center
        bonus.font = FontSize(12)
        bonus.layer.cornerRadius = 3
        bonus.layer.masksToBounds = true
        bonus.snp.makeConstraints { (make) in
            make.bottom.equalTo(goodsImg.snp.bottom).offset(0)
            make.right.equalTo(0)
        }
        
        // 底部时间
        let time = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenW - 40, height: 36))
        orderItem.addSubview(time)
        
        let createTime = getDateFromTimeStamp(timeStamp: data.createTime!)
        time.text = "创建时间："+createTime.format("yyyy/MM/dd HH:mm:ss")
        time.font = FontSize(14)
        time.textColor = kGrayTextColor
        time.addBorder(side: .top, thickness: 1, color: klineColor)
        time.snp.makeConstraints { (make) in
            make.top.equalTo(orderInfo.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(36)
        }
        allHeight += 10 + 172
    }
    
    // 平台切换
    func platformDelegatefuc(backMsg: Int) {
        body.clearAll()
        platform = backMsg
        allHeight = 0
        pageNo = 1
        isFinish = false
        loadData()
    }
    
    // 订单状态
    func typeValue(data:OrderModel, label:UILabel){
        switch Int(data.status!) {
        case -1:
            label.text = "已失效"
            label.textColor = kLowOrangeColor
        case 1:
            label.text = "已付款"
            label.textColor = kBGGreenColor
        case 2:
            label.text = "已收货"
            label.textColor = kBGGreenColor
        case 3:
            label.text = "已到账"
            label.textColor = kBGGreenColor
        default:
            label.text = "未知状态"
            label.textColor = kLowOrangeColor
            break
        }
    }
    
    // 获取佣金值
    func bonusValue(data:OrderModel,label:UILabel){
        var bonus = "-1"
        let usId:String = UserDefaults.getInfo()["id"] as! String
        if(usId == data.usId!){
            bonus = data.commission!
        }else if(usId == data.parentId!){
            bonus = data.parentCommission!
        }else if(usId == data.parentIdTwo!){
            bonus = data.parentCommissionTwo!
        }
        // 失效状态加中间划线
        if(data.status! == "13"){
            let typeStr = NSMutableAttributedString.init(string: "佣金"+bonus+"元")
            typeStr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: typeStr.length))
            label.attributedText = typeStr
        }else{
            label.text = "佣金"+bonus+"元"
        }
    }
    
    //没有更多信息
    func noMore(){
        endStr.text = "没有更多了～"
        endStr.textColor = kGrayTextColor
        endStr.font = FontSize(14)
        endStr.textAlignment = .center
        endStr.frame = CGRect(x: 0, y: allHeight, width: Int(kScreenW), height: 50)
        body.contentInset = UIEdgeInsets(top: 0, left: CGFloat(0), bottom: CGFloat(self.allHeight + 50), right: CGFloat(0))
        body.addSubview(endStr)
    }
    
    //加载中
    func setLoading(){
        loading.frame = CGRect(x: 0, y: allHeight, width: Int(kScreenW), height: 50)
        loading.isHidden = false
        loading.color = .darkGray
        loading.hidesWhenStopped = true
        loading.startAnimating()
        body.addSubview(loading)
        body.contentInset = UIEdgeInsets(top: 0, left: CGFloat(0), bottom: CGFloat(self.allHeight + 50), right: CGFloat(0))
    }
    
    //没有订单
    func setNoMessage(){
        noMessage.frame = CGRect(x: 0, y: 40, width: kScreenW, height: kScreenH * 0.6)
        let noMessageImg = UIImageView(image: UIImage(named: "nodata"))
        noMessageImg.frame = CGRect(x: (kScreenW - 200)/2, y: 1, width: 200, height: 200)
        noMessageImg.contentMode = .scaleAspectFit
        noMessage.addSubview(noMessageImg)
        body.addSubview(noMessage)
//        pageNo = pages
    }
    
    // 获取数据
    func loadData(){
        if isFinish {
            return
        }
        setLoading()
        AlamofireUtil.post(url: "/user/order/getOrderList2",
        param: [
            "type": self.platform + 1,
            "status": ((type == -1) ? "" : type),
            "pageNo": pageNo,
            "pageSize": pageSize
        ],
        success:{ (res,data) in
            if self.isCancel {
                return
            }
            self.loading.stopAnimating()
            self.pages = Int(data["pages"].description)!
            self.dataList = [OrderModel].deserialize(from: data["list"].description)! as! [OrderModel]
            if(self.dataList.count > 0){
                for item in self.dataList {
                    self.setItem(data: item)
                }
                self.body.contentInset = UIEdgeInsets(top: 0, left: CGFloat(0), bottom: CGFloat(self.allHeight), right: CGFloat(0))
            }
            if(Int(data["total"].description)! <= 0){
                self.setNoMessage()
                self.noMessage.isHidden = false
                return
            }else if self.dataList.count < self.pageSize {
                self.isFinish = true
                self.noMore()
            }else {
                self.noMessage.isHidden = true
            }
            self.pageNo += 1
        },
        error: {},
        failure: {})
    }
    
    @objc func toDetail(sender : UITapGestureRecognizer){
        if platform == 0 {
            detailId = sender.view?.tag
            self.navigationController!.pushViewController(DetailController(), animated: true)
        } else if platform == 1 {
            let vc = PddDetailController()
            goodsId = sender.view!.tag
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
}
