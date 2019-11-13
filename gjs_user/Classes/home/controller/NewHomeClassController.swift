//
//  NewHomeClassController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/11/6.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit
@available(iOS 11.0, *)
class NewHomeClassController: UIViewController,sortDelegate {
    weak var naviController: UINavigationController?
    var isCancel = false
    // 标题分类id
    var classfiyid : Int?
    fileprivate var goodsitem = [[goodsItem]]()
    fileprivate var newGoodsitem = [goodsItem]()
    let cell_identifier:String = "HomeClassiewCell"
    var minId = 1
    //表格底部用来提示数据加载的视图
    var loadMoreView:UIView?
    var isFinish = false
    //计数器（用来做延时模拟网络加载效果）
    var timer: Timer!
    var istabHeaderRefreshed = false
    
    //用了记录当前是否允许加载新数据（正则加载的时候会将其设为false，放置重复加载）
    var loadMoreEnable = true
    var NewClassTableView: UITableView!
    private var sort = 0
    var ClassTableView = UITableView()
    override func viewWillDisappear(_ animated: Bool) {
           isCancel = true
       }
       override func viewWillAppear(_ animated: Bool) {
           isCancel = false
       }
    override func viewDidLoad() {
        super.viewDidLoad()
        newGoodsitem = Array.init()
        self.view.backgroundColor = .clear
        let screenBar = ScreenBar(frame: CGRect(x: 0, y: kNavigationBarHeight + kNavigationBarHeight, width: kScreenW, height: 40))
        screenBar.delegate = self
        view.addSubview(screenBar)
        // Do any additional setup after loading the view.
        classdata()
        createUI()
        setupInfiniteScrollingView()
        headerRefeash()
    }
    func headerRefeash(){
        
        createUI()
        ClassTableView.gtm_addRefreshHeaderView {
            [weak self] in
            print("开始刷新")
           
            self?.NewHomeTableRefresh()
        }
        ClassTableView.pullDownToRefreshText("下拉刷新")
            .releaseToRefreshText("松开刷新")
            .refreshSuccessText("刷新成功")
            .refreshFailureText("刷新失败")
            .refreshingText("正在努力加载")
        ClassTableView.headerTextColor(kGrayTextColor)
        self.ClassTableView.tableFooterView = self.loadMoreView
    }
    func sortDelegatefuc(backMsg: Int) {
        self.sort = backMsg
        print("backmsg",backMsg)
        istabHeaderRefreshed = false
        minId = 1
//        headerRefeash()
        ClassTableView.clearAll2()
        self.newGoodsitem.removeAll()
        classdata()
//        let newcell = HomeClassiewCell()
//        goodslist = newGoodsitem
//       print("goodslist",goodslist)
        self.ClassTableView.reloadData()
    }
    
    
    @objc func classdata(){
        if istabHeaderRefreshed{
            print("执行了")
            return
        }
       AlamofireUtil.post(url: "/product/public/getProductList",
          param: ["nav":3,
             "sort" : self.sort,
             "back":10,
             "min_id":minId,
             "cid":classfiyid!],
          success: { (res, data) in
        goodslist = goodsItemDataList.deserialize(from: data.description)!.data!
            
            self.minId = data["min_id"].int!
            self.goodsitem = [goodslist]
            self.newGoodsitem += goodslist
            print("sort::",goodslist)
            self.ClassTableView.reloadData()
            self.loadMoreEnable = true
            self.minId = data["min_id"].int!
       }, error: {
           
       }, failure: {
           
       })
    }
}
@available(iOS 11.0, *)
extension NewHomeClassController{
    //MARK:--上拉刷新视图
    private func setupInfiniteScrollingView() {
        self.loadMoreView = UIView(frame: CGRect(x:0, y:self.NewClassTableView.contentSize.height,width:self.NewClassTableView.bounds.size.width, height:50))
        self.loadMoreView!.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        self.loadMoreView!.backgroundColor = .white
        
        //MARK:-- 添加中间的环形进度条
        let activityViewIndicator = UIActivityIndicatorView(style: .white)
        activityViewIndicator.color = UIColor.darkGray
        let indicatorX = self.view.frame.width/2-activityViewIndicator.frame.width/2
        let indicatorY = self.loadMoreView!.frame.size.height/2-activityViewIndicator.frame.height/2
        activityViewIndicator.frame = CGRect(x:indicatorX, y:indicatorY,
                                             width:activityViewIndicator.frame.width,
                                             height:activityViewIndicator.frame.height)
        activityViewIndicator.startAnimating()
        self.loadMoreView!.addSubview(activityViewIndicator)
    }
    func refresh() {
        perform(#selector(endRefresing), with: nil, afterDelay: 3)
    }
    
    @objc func endRefresing() {
        self.NewClassTableView?.endRefreshing(isSuccess: true)
    }
    func loadMore(){
        print("加载新数据！")
        loadMoreEnable = false
        classdata()
        
    }
    // 下拉刷新
    @objc func NewHomeTableRefresh() {
        self.newGoodsitem.removeAll()
        classdata()
        self.NewClassTableView.endRefreshing(isSuccess: true)
        self.NewClassTableView.reloadData()
    }
}


@available(iOS 11.0, *)
extension NewHomeClassController : UITableViewDelegate,UITableViewDataSource{
    func createUI(){
        self.ClassTableView = UITableView.init(frame: CGRect(x: 0, y: kNavigationBarHeight * 3, width: kScreenW, height: kScreenH + 120), style:.plain)
       self.ClassTableView.tableFooterView = UIView.init()
       self.ClassTableView.delegate = self
       self.ClassTableView.dataSource = self
       
       self.ClassTableView.separatorStyle = .none
       self.ClassTableView.rowHeight = UITableView.automaticDimension
       self.ClassTableView.estimatedRowHeight = 0
       self.ClassTableView.estimatedSectionFooterHeight = 0
       self.ClassTableView.estimatedSectionHeaderHeight = 0
       self.ClassTableView.allowsSelection = false
       self.ClassTableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
       self.ClassTableView.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(300), right: CGFloat(0))
       self.view.addSubview(self.ClassTableView)
        self.NewClassTableView = ClassTableView
       self.ClassTableView.register(HomeClassiewCell.classForCoder(), forCellReuseIdentifier: cell_identifier)
   
       }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.goodsitem.count > 0 {
            if indexPath.row == 0 {
                return 130      // 第一张卡片 返回高度
            }
            return 130         // 其余卡片 高度
            
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newGoodsitem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HomeClassiewCell.dequeue(tableView)
        cell.Home_delegate = self
        cell.backgroundColor = colorwithRGBA(241, 241, 241, 1)
        if self.newGoodsitem.count > 0
        {
            if indexPath.row == 0 {
                cell.firstCard = true
                
            }else {
                cell.firstCard = false
            }
            cell.model = self.newGoodsitem[indexPath.row]
            print("modell::",cell.model)
        }
        
        if (loadMoreEnable && indexPath.row == self.newGoodsitem.count-1){
            loadMore()
        }
        
        
        return cell
    }
    
    
}


@available(iOS 11.0, *)
extension NewHomeClassController : HomeClassiewCellDelegate {
    func commentClickDelegate(_ cell: HomeClassiewCell, withModel model: goodsItem) {
        weak var weakSelf = self //避免循环引用
        let vc = DetailController()
        
        print("id : \(String(describing: model.itemid))")
        detailId = Int(model.itemid!)!
        weakSelf!.naviController?.pushViewController(vc, animated: true)
    }
}
@available(iOS 11.0, *)
extension NewHomeClassController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
    func listDidAppear() {
        
    }
    
    func listDidDisappear() {
    }
}
