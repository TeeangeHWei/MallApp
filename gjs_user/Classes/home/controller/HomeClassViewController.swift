//
//  HomeClassViewController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/20.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class HomeClassViewController: ViewController,UIScrollViewDelegate,sortDelegate {
    
    var isCancel = false
    let body = UIScrollView()
    weak var naviController: UINavigationController?
    // 标题分类id
    var classfiyid : Int?
    var allHeight = 0
    var minId = 1
    var isLoading = false
    var isFinish = false
    private var sort = 0
    let loadingView = UIActivityIndicatorView(style: .white)
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let height = allHeight - Int(kScreenH) + Int(headerHeight) + 40
        if Int(scrollView.contentOffset.y) >= height && !isLoading {
            isLoading = true
            getData(refresh: false)
        }
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }
    override func viewWillAppear(_ animated: Bool) {
        isCancel = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(refresh: false)
        self.view.backgroundColor = colorwithRGBA(241,241,241,1)
        let screenBar = ScreenBar(frame: CGRect(x: 0, y: kNavigationBarHeight + kNavigationBarHeight, width: kScreenW, height: 40))
        screenBar.delegate = self
        view.addSubview(screenBar)
        
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - 170)
            layout.position = .relative
            layout.marginTop = 135
        }
        self.view.addSubview(body)
        // 将body移到最底层
        self.view.sendSubviewToBack(body)
        
        body.yoga.applyLayout(preservingOrigin: true)
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight + 40), right: CGFloat(0))
        body.delegate = self
        
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
    
    func sortDelegatefuc(backMsg: Int) {
        self.sort = backMsg
        isFinish = false
        isLoading = true
        body.clearAll2()
        setLoading()
        minId = 1
        allHeight = 0
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(self.allHeight + 150), right: CGFloat(0))
        getData(refresh: false)
        
    }
    // 获取分类id
    func getData (refresh: Bool) {
        if isFinish {
            return
        }
        self.loadingView.frame = CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 50)
        if !refresh {
            self.loadingView.isHidden = false
        }
        AlamofireUtil.post(url: "/product/public/getProductList",
           param: ["nav":3,
              "sort" : self.sort,
              "back":10,
              "min_id":minId,
              "cid":classfiyid!],
           success: { (res, data) in
            self.minId = data["min_id"].int!
            let classifyGoodsList : [goodsItem] = goodsItemDataList.deserialize(from: data.description)!.data!
            for item in classifyGoodsList {
                let goodsItem = GoodsItemView(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 100),data: item, nav: self.naviController!)
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
                
            }
        }, error: {
            
        }, failure: {
            
        })
    }
}
@available(iOS 11.0, *)
extension HomeClassViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
    func listDidAppear() {
        
    }
    
    func listDidDisappear() {
    }
}
