//
//  newsView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/17.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class NewsView: ViewController, UIScrollViewDelegate {
    
    private var allHeight = 0
    private let body = UIScrollView()
    private let endStr = UILabel()
    private let noMessage = UIView()
    private let loading = UIActivityIndicatorView(style: .white)
    
    // 切换消息类型相关
    private let layer = CALayer()
    private var typeArr = [UIButton]()
    private var type = 0
    
    //页数信息
    private var pageNo = 1
    private let pageSize = 10
    private var pages = 2
    private var dataList:[NewsModel] = [NewsModel]()
    
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
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        let navView = customNav(titleStr: "消息", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        let typeList = ["系统消息", "收益消息", "粉丝消息"]
        let typeBar = UIView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: 46))
        typeBar.backgroundColor = .white
        typeBar.addBorder(side: .top, thickness: 1, color: klineColor)
        typeBar.addBorder(side: .bottom, thickness: 1, color: klineColor)
        for (index, item) in typeList.enumerated() {
            let width = (kScreenW - 60)/3
            let x = 30 + CGFloat(index) * width
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
        let width = (kScreenW - 60)/6
        layer.frame = CGRect(x: 30 + width/2, y: 42, width: width, height: 4)
        layer.cornerRadius = 2
        layer.backgroundColor = kLowOrangeColor.cgColor
        typeBar.layer.addSublayer(layer)
        
        body.frame = CGRect(x: 0, y: headerHeight + 46, width: kScreenW, height: kScreenH - 46 - headerHeight)
        body.backgroundColor = kBGGrayColor
        body.delegate = self
        
        self.view.addSubview(typeBar)
        self.view.addSubview(body)
        loadData()
    }
    
    //切换类型
    @objc func typeChange(_ btn: UIButton){
        typeArr[type].setTitleColor(kGrayTextColor, for: .normal)
        typeArr[btn.tag].setTitleColor(kLowOrangeColor, for: .normal)
        type = btn.tag
        UIView.animate(withDuration: 0.3) {
            let left = ((kScreenW - 60)/3) * CGFloat(self.type)
            self.layer.frame.origin.x = 30 + (kScreenW - 60)/12 + left
        }
        //刷新列表信息
        body.subviews.forEach{$0.removeFromSuperview()}
        allHeight = 0
        pages = 2
        pageNo = 1
        loadData()
    }
    
    //添加单条消息的方法
    func setItem(data: NewsModel){
        var height = 120
        if(type == 0){
            height = 100
        }
        let item = UIView(frame: CGRect(x: 10, y: allHeight + 10, width: Int(kScreenW - 20), height: height))
        item.backgroundColor = .white
        item.layer.cornerRadius = 3
        
        let content = UILabel(frame: CGRect(x: 10, y: 10, width: Int(kScreenW - 40), height: height - 40))
        content.numberOfLines = 10
        
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 5
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                          NSAttributedString.Key.paragraphStyle: paraph]
        content.attributedText = NSAttributedString(string: "【" + data.title! + "】" + data.content!, attributes: attributes)
        item.addSubview(content)
        
        let time = UILabel(frame: CGRect(x: 10, y: height - 30, width: Int(kScreenW - 20), height: 30))
        let createTime = getDateFromTimeStamp(timeStamp: data.createTime!)
        time.text = createTime.format("yyyy/MM/dd HH:mm:ss")
        time.font = FontSize(14)
        time.textColor = kGrayTextColor
        time.configureLayout { (layout) in
            layout.isEnabled = true
        }
        item.addSubview(time)
        body.addSubview(item)
        allHeight += height + 10
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
    
    //没有消息
    func setNoMessage(){
        noMessage.frame = CGRect(x: 0, y: 40, width: kScreenW, height: kScreenH * 0.6)
        let noMessageImg = UIImageView(image: UIImage(named: "noNews"))
        noMessageImg.frame = CGRect(x: (kScreenW - 100)/2, y: 1, width: 100, height: 100)
        noMessageImg.contentMode = .scaleAspectFit
        noMessage.addSubview(noMessageImg)
        body.addSubview(noMessage)
        pageNo = pages
    }
    
    func loadData() {
        if(pageNo > pages){
            return
        }
        setLoading()
        AlamofireUtil.post(url: "/user/message/getMessage",
        param: [
            "type": type+1,
            "pageNo": pageNo,
            "pageSize": pageSize
        ],
        success: { (res, data) in
            self.loading.stopAnimating()
            self.pages = Int(data["pages"].description)!
            self.dataList = [NewsModel].deserialize(from: data["list"].description)! as! [NewsModel]
            if(self.dataList.count > 0){
                for item in self.dataList {
                    self.setItem(data: item)
                }
                self.body.contentInset = UIEdgeInsets(top: 0, left: CGFloat(0), bottom: CGFloat(self.allHeight), right: CGFloat(0))
            }
            if(Int(data["total"].description)! <= 0){
                self.setNoMessage()
                return
            }else if(Int(data["total"].description)! < self.pageSize){
                self.noMore()
            }
            self.pageNo += 1
        },
        error: {},
        failure: {})
    }
}
