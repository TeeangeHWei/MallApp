//
//  ClassifyGoodsListView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/13.
//  Copyright © 2019 大杉网络. All rights reserved.
//

var listTypeNum = 1
var listType = UIImageView(image: UIImage(named: "listType-1"))

@available(iOS 11.0, *)
class ClassifyGoodsListView: ViewController, UIScrollViewDelegate, sortDelegate {
    
    var isCancel = false
    var allHeight = 0
    var minId = 1
    var sort = 0
    var isLoading = false
    var isFinish = false
    let body = UIScrollView()
    let loadingView = UIActivityIndicatorView(style: .white)
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 打印当前滚动条实时位置
        let height = allHeight - Int(kScreenH) + Int(headerHeight) + 40
        if Int(scrollView.contentOffset.y) >= height && !isLoading {
            isLoading = true
            getData(refresh: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }
    
    override func viewDidLoad() {
        let navView = customNav(titleStr: classifyTitle!, titleColor: kMainTextColor)
        self.view.addSubview(navView)
        getData(refresh: false)
        let scale = Commons.getScale()
        self.view.backgroundColor = colorwithRGBA(241,241,241,1)
        // 筛选栏
        let screenBar = ScreenBar(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: 40))
        screenBar.delegate = self
        view.addSubview(screenBar)
        
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - 40)
            layout.position = .relative
//            layout.marginTop = 40
        }
        self.view.addSubview(body)
        // 将body移到最底层
        self.view.sendSubviewToBack(body)
        
        setLoading()
        body.frame = CGRect(x: 0, y: headerHeight + 40, width: kScreenW, height: kScreenH - 84)
        body.yoga.applyLayout(preservingOrigin: true)
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight + 40), right: CGFloat(0))
        body.delegate = self
        //        self.scrollViewDidScroll(body)
        body.gtm_addRefreshHeaderView {
            [weak self] in
            print("开始刷新")
            self?.refresh()
        }
        body.pullDownToRefreshText("下拉刷新")
            .releaseToRefreshText("松开刷新")
            .refreshSuccessText("刷新成功")
            .refreshFailureText("刷新失败")
            .refreshingText("正在努力加载")
        body.headerTextColor(kGrayTextColor)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isCancel = false
    }
    
    // 下拉刷新
    func refresh () {
        isFinish = false
        isLoading = true
        body.clearAll()
        minId = 1
        allHeight = 0
        getData(refresh: true)
        setLoading()
    }
    
    // 请求数据
    func getData (refresh: Bool) {
        if isFinish {
            return
        }
        self.loadingView.frame = CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 50)
        if !refresh {
            self.loadingView.isHidden = false
        }
        AlamofireUtil.post(url:"/product/public/keywordSearch", param: [
            "keyword" : classifyTitle!,
            "back" : "10",
            "min_id" : minId,
            "sort" : self.sort
        ],
        success:{(res,data) in
            if self.isCancel {
                return
            }
            self.minId = data["min_id"].int!
            let classifyGoodsList : [goodsItem] = goodsItemDataList.deserialize(from: data.description)!.data!
            for item in classifyGoodsList {
                let goodsItem = GoodsItemView(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 100),data: item, nav: self.navigationController!)
                self.body.addSubview(goodsItem)
                self.allHeight += 130
            }
            // 没有更多了
            if classifyGoodsList.count < 10 {
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
            self.body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(self.allHeight + 80), right: CGFloat(0))
            self.isLoading = false
            if refresh {
                self.body.endRefreshing(isSuccess: true)
                self.setLoading()
            }
        },
        error:{
            
        },
        failure:{
            
        })
    }
    
    func setLoading () {
        // 设置loading控件
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
    
    // 筛选栏回调函数
    func sortDelegatefuc(backMsg: Int) {
        self.sort = backMsg
        isFinish = false
        isLoading = true
        body.clearAll2()
        setLoading()
        minId = 1
        allHeight = 0
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(self.allHeight + 150), right: CGFloat(0))
        getData(refresh: true)
    }
}
