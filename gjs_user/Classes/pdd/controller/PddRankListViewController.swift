//
//  PddRankListViewController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/12.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit


class PddRankListViewController: ViewController,UIScrollViewDelegate{
    
    
    let body = UIScrollView()
    weak var naviController: UINavigationController?
    // 标题分类id
    var classfiyid : Int?
    var allHeight = 0
    var offset = 0
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
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(refresh: false)
        self.view.backgroundColor = colorwithRGBA(241,241,241,1)

        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH)
            layout.position = .relative
            layout.marginTop = 40
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
        offset = 0
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
    
    // 获取分类id
    func getData (refresh: Bool) {
        if isFinish {
            return
        }
        self.loadingView.frame = CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 50)
        if !refresh {
            self.loadingView.isHidden = false
        }
        AlamofireUtil.post(url: "/ddk/public/ddkTopGoodsListQuery", param: ["offset":self.offset,
                                                                            "sortType": self.classfiyid! + 1,
                                                                          "limit":10], success: { (res, data) in
            self.offset += 10
            let classifyGoodsList : [pddGoodsItem] = pddGoodsItemList.deserialize(from: data.description)!.list!
            for item in classifyGoodsList {
                if #available(iOS 11.0, *) {
                    let goodsItem = PddGoodsCard(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 100),data: item, nav: self.naviController!)
                    self.body.addSubview(goodsItem)
                    self.allHeight += 130
                } else {
                    // Fallback on earlier versions
                }
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

@available(iOS 10.0, *)
extension PddRankListViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
    func listDidAppear() {
    }
    
    func listDidDisappear() {
    }
}
