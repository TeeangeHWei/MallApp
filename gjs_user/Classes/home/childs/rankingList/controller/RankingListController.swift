//
//  rankingListController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/20.
//  Copyright © 2019 大杉网络. All rights reserved.
//


@available(iOS 11.0, *)
class RankingListController: ViewController, UIScrollViewDelegate {

    var isCancel = false
    private var allHeight = 0
    var classifyLabelArr = [UIButton]()
    // 请求相关参数
    private var saleType = 1
    private var minId = 1
    private var cId = 0
    private var isLoading = false
    private var isFinish = false
    
    let realTime = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.5, height: 40))
    let todayList = UIButton(frame: CGRect(x: kScreenW * 0.5, y: 0, width: kScreenW * 0.5, height: 40))
    let shortLine = UIView(frame: CGRect(x: 5, y: 0, width: 40, height: 4))
    let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight + 80, width: kScreenW, height: kScreenH - 80))
    let loadingView = UIActivityIndicatorView(style: .white)
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 打印当前滚动条实时位置
        let height = allHeight - Int(kScreenH) + Int(headerHeight) + 40
        if Int(scrollView.contentOffset.y) >= height && !isLoading {
            isLoading = true
            getData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }
    
    override func viewDidLoad() {
        let NavView = customNav(titleStr: "爆款排行", titleColor: kMainTextColor, border: false)
        self.view.addSubview(NavView)
        getData()
        setLoading()
        view.backgroundColor = kBGGrayColor
        // 排行榜类型
        let typeList = UIView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: 40))
        typeList.addBorder(side: .bottom, thickness: 1, color: klineColor)
        typeList.backgroundColor = .white
        view.addSubview(typeList)
        realTime.tag = 1
        realTime.addTarget(self, action: #selector(typeChange), for: .touchUpInside)
        realTime.setTitle("实时排行", for: .normal)
        realTime.setTitleColor(kLowOrangeColor, for: .normal)
        realTime.titleLabel?.font = FontSize(14)
        typeList.addSubview(realTime)
        todayList.tag = 2
        todayList.addTarget(self, action: #selector(typeChange), for: .touchUpInside)
        todayList.setTitle("今日排行", for: .normal)
        todayList.setTitleColor(kGrayTextColor, for: .normal)
        todayList.titleLabel?.font = FontSize(14)
        typeList.addSubview(todayList)
        // 商品分类
        let classifyArr = ["全部", "女装", "男装", "内衣", "美妆", "配饰", "鞋品", "箱包", "儿童", "母婴", "居家", "美食", "数码", "家电"]
        let classifyBox = UIScrollView(frame: CGRect(x: 0, y: headerHeight + 40, width: kScreenW, height: 40))
        classifyBox.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(0), right: CGFloat(700))
        classifyBox.backgroundColor = .white
        classifyBox.showsHorizontalScrollIndicator = false
        view.addSubview(classifyBox)
        // 分类列表视图
        let classifyList = UIView(frame: CGRect(x: 0, y: 0, width: 700, height: 40))
        classifyBox.addSubview(classifyList)
        // 分类线
        let longLine = UIView(frame: CGRect(x: 0, y: 36, width: 700, height: 4))
        classifyList.addSubview(longLine)
        shortLine.backgroundColor = kLowOrangeColor
        shortLine.layer.cornerRadius = 2
        longLine.addSubview(shortLine)
        // 分类个体
        for (index, item) in classifyArr.enumerated() {
            let classifyItem = UIButton(frame: CGRect(x: index * 50, y: 0, width: 50, height: 40))
            classifyItem.tag = index
            classifyItem.addTarget(self, action: #selector(ClassifyChange), for: .touchUpInside)
            classifyItem.setTitle(item, for: .normal)
            if index == 0 {
                classifyItem.setTitleColor(kLowOrangeColor, for: .normal)
            } else {
                classifyItem.setTitleColor(kGrayTextColor, for: .normal)
            }
            classifyItem.titleLabel?.font = FontSize(14)
            classifyList.addSubview(classifyItem)
            classifyLabelArr.append(classifyItem)
        }
        // 宝贝列表
        body.delegate = self
        view.addSubview(body)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isCancel = false
    }
    
    // 下拉刷新
    func refresh () {
        minId = 1
        isLoading = true
        allHeight = 0
        body.clearAll()
        getData()
    }
    
    // 获取排行列表
    func getData () {
        if isFinish {
            return
        }
        self.loadingView.frame = CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 50)
        self.loadingView.isHidden = false
        AlamofireUtil.post(url: "/product/public/ranking", param: [
            "sale_type" : self.saleType,
            "cid" : self.cId,
            "back" : "20",
            "min_id" : self.minId
        ],
        success:{(res, data) in
            if self.isCancel {
                return
            }
            self.minId = data["min_id"].int!
            let goodsListData = goodsItemDataList.deserialize(from: data.description)!.data!
            for item in goodsListData {
                let goodsItem = GoodsItemView(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW - 20), height: 130), data: item, nav: self.navigationController!)
                self.body.addSubview(goodsItem)
                self.allHeight += 130
            }
            // 没有更多了
            if goodsListData.count < 10 {
                self.isFinish = true
                let noMore = UILabel(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 50))
                noMore.text = "没有更多了～"
                noMore.textAlignment = .center
                noMore.font = FontSize(14)
                noMore.textColor = kGrayTextColor
                self.body.addSubview(noMore)
                self.allHeight += 50
            }
            self.loadingView.isHidden = true
            self.isLoading = false
            self.body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(self.allHeight + 100), right: CGFloat(0))
        },
        error:{
            
        },
        failure:{
            
        })
    }
    
    // 点击排行榜类型
    @objc func typeChange (_ btn : UIButton) {
        let index = btn.tag
        saleType = index
        if index == 1 {
            realTime.setTitleColor(kLowOrangeColor, for: .normal)
            todayList.setTitleColor(kGrayTextColor, for: .normal)
            refresh()
        } else {
            realTime.setTitleColor(kGrayTextColor, for: .normal)
            todayList.setTitleColor(kLowOrangeColor, for: .normal)
            refresh()
        }
    }
    
    // 点击商品分类
    @objc func ClassifyChange (_ btn: UIButton) {
        let index = btn.tag
        classifyLabelArr[cId].setTitleColor(kGrayTextColor, for: .normal)
        classifyLabelArr[index].setTitleColor(kLowOrangeColor, for: .normal)
        cId = index
        UIView.animate(withDuration: 0.3, animations: {
            self.shortLine.frame.origin.x = CGFloat(index * 50 + 5)
        })
        refresh()
    }
    
    // 设置loading控件
    func setLoading () {
        loadingView.isHidden = true
        loadingView.color = .darkGray
        loadingView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 50)
        loadingView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = 50
        }
        loadingView.startAnimating()
        body.addSubview(loadingView)
    }

}
