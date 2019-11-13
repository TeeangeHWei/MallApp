//
//  billView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/16.
//  Copyright © 2019 大杉网络. All rights reserved.
//

class billView: ViewController, UIScrollViewDelegate {
    private var allHeight = 0
    private var body = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - headerHeight))
    private let loading = UIActivityIndicatorView(style: .white)
    private let endStr = UILabel()
    
    private var pageNo = 1
    private var pages = 2
    private var pageSize = 10
    private var dataList:[BillModel] = [BillModel]()
    
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
        let navView = customNav(titleStr: "账单详情", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        body.backgroundColor = .white
        body.addBorder(side: .top, thickness: 1, color: klineColor)
        self.view.addSubview(body)
        
        body.delegate = self
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight), right: CGFloat(0))
        loadData()
    }
    
    // 设置单条记录
    func setItem (_ data: BillModel) {
        let billItem = UIView(frame: CGRect(x: 0, y: allHeight, width: Int(kScreenW), height: 80))
        billItem.addBorder(side: .bottom, thickness: 1, color: klineColor)
        body.addSubview(billItem)
        let itemLeft = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW - 100, height: 80))
        billItem.addSubview(itemLeft)
        let title = UILabel(frame: CGRect(x: 10, y: 10, width: Int(kScreenW - 120), height: 40))
        title.text = data.remark
        title.font = FontSize(14)
        itemLeft.addSubview(title)
        let time = UILabel(frame: CGRect(x: 10, y: 50, width: Int(kScreenW - 120), height: 20))
        let createTime = getDateFromTimeStamp(timeStamp: data.createTime!)
        time.text = createTime.format("yyyy/MM/dd HH:mm:ss")
        time.font = FontSize(14)
        time.textColor = kGrayTextColor
        itemLeft.addSubview(time)
        let itemRight = UILabel(frame: CGRect(x: (kScreenW - 110), y: 0, width: 90, height: 80))
        var money = ""
        var isPositive = false
        if data.amount!.contains("-") {
            money = data.amount!
            isPositive = false
        } else {
            money = "+" + data.amount!
            isPositive = true
        }
        itemRight.text = money + "元"
        itemRight.font = FontSize(16)
        itemRight.textAlignment = .right
        if isPositive {
            itemRight.textColor = colorwithRGBA(100,193,253, 1)
        } else {
            itemRight.textColor = kLowOrangeColor
        }
        billItem.addSubview(itemRight)
        allHeight += 80
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
    
    //没有更多信息
    func noMore(){
        endStr.text = "没有更多了～"
        endStr.textColor = kGrayTextColor
        endStr.font = FontSize(14)
        endStr.textAlignment = .center
        endStr.frame = CGRect(x: 0, y: allHeight + 10, width: Int(kScreenW), height: 30)
        body.contentInset = UIEdgeInsets(top: 0, left: CGFloat(0), bottom: CGFloat(self.allHeight + 30), right: CGFloat(0))
        body.addSubview(endStr)
    }
    
    func loadData() {
        if(pageNo > pages){
            return
        }
        setLoading()
        AlamofireUtil.post(url: "/user/withdrawal/selectWalletFlowList",
        param: [
            "pageNo": pageNo,
            "pageSize": pageSize
        ],
        success: { (res,data) in
            self.loading.stopAnimating()
            self.pages = Int(data["pages"].description)!
            self.dataList = [BillModel].deserialize(from: data["list"].description)! as! [BillModel]
            if(self.dataList.count > 0){
                for item in self.dataList {
                    self.setItem(item)
                }
                self.body.contentInset = UIEdgeInsets(top: 0, left: CGFloat(0), bottom: CGFloat(self.allHeight), right: CGFloat(0))
            }
            if(Int(data["total"].description)! <= 0){
                self.pageNo = self.pages
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
