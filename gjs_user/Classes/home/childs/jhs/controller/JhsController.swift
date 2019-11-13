//
//  JhsController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/20.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class JhsController: ViewController, UIScrollViewDelegate, sortDelegate {
    
    var isCancel = false
    private var allHeight = 0
    // 请求相关参数
    private var saleType = 1
    private var minId = 1
    private var cId = 0
    private var sort = 0
    private var isLoading = false
    private var isFinish = false
    
    let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight + 40, width: kScreenW, height: kScreenH - 40))
    let loadingView = UIActivityIndicatorView(style: .white)
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 打印当前滚动条实时位置
        let height = allHeight - Int(kScreenH) + Int(headerHeight) + 40
        if Int(scrollView.contentOffset.y) >= height && !isLoading {
            isLoading = true
            getData()
        }
    }
    
    override func viewDidLoad() {
        getData()
        setLoading()
        let NavView = customNav(titleStr: "好划算", titleColor: kMainTextColor, border: true)
        self.view.addSubview(NavView)
        view.backgroundColor = kBGGrayColor
        let screenBar = ScreenBar(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: 40))
        screenBar.delegate = self
        view.addSubview(screenBar)
        body.delegate = self
        view.addSubview(body)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        isCancel = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }

    // 获取排行列表
    func getData () {
        if isFinish {
            return
        }
        self.loadingView.frame = CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 50)
        self.loadingView.isHidden = false
        AlamofireUtil.post(url: "/product/public/searchProduct", param: [
            "type" : 4,
            "sort" : self.sort,
            "back" : "10",
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
            self.loadingView.isHidden = true
            self.isLoading = false
            self.body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(self.allHeight + 150), right: CGFloat(0))
        },
        error:{
            
        },
        failure:{
            
        })
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
        getData()
    }
    
}
