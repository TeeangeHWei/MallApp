//
//  PddViewController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/10.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class PddViewController: ViewController {
    var navTopView : UIView!
    var PddpagingView: JXPagingView!
    var PddsegmentedDataSource: JXSegmentedTitleDataSource!
    var PddHeaderView: pagingTableHeaderView!
    var PddsegmentedView: JXSegmentedView!
    var PddlistContainerView: JXSegmentedListContainerView!
    var PdduserHeaderContainerView: UIView!
    fileprivate var navigationView:UIView!
    let kcycleViewHeight :CGFloat = 156
    var PddTableHeaderViewHeight: Int = Int(kScreenW * 0.85)
    var PddheightForHeaderInSection: Int = 50
    var titles2 = [String]()
    let imgArr = ["pdd-1","pdd-2","pdd-3","pdd-4"]
    var PddTitles = [PddtitleModel]()
    var searchPageView : SearchPageView?
    var isHeaderRefreshed = false
    var isNeedHeader = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        view.backgroundColor = .white
        PddGetData()
        setui()
        
        
    }
    //MARK:-- 添加刷新
    @objc func headerRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
            self.isHeaderRefreshed = true
            self.reloadData()
            self.PddpagingView.mainTableView.mj_header.endRefreshing()
            self.PddpagingView.reloadData()
        }
    }
    
#warning("因为数据是异步的,必须使用生命周期控制pagingView显示")
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
        
        PddpagingView.mainTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        
    }
    //MARK:-- 添加pagingViewUI
    func setui(){
        PdduserHeaderContainerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: CGFloat(PddTableHeaderViewHeight)))
        PddHeaderView = pagingTableHeaderView(frame: PdduserHeaderContainerView.bounds)
        PddHeaderView.PagingnaviController = navigationController
        PdduserHeaderContainerView.addSubview(PddHeaderView)
        //1、初始化JXSegmentedView
        PddsegmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: CGFloat(PddheightForHeaderInSection)))
        PddsegmentedView.backgroundColor = UIColor.white
        PddsegmentedView.dataSource = PddsegmentedDataSource
        PddsegmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        PddsegmentedView.defaultSelectedIndex = 0
        PddsegmentedView.reloadData()
        PddpagingView = JXPagingView(delegate: self)
        //2、配置数据源
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        PddsegmentedDataSource = JXSegmentedTitleDataSource()
//        PddsegmentedDataSource.titles = titles2
        PddsegmentedDataSource.titleNormalColor = .gray
        PddsegmentedDataSource.titleSelectedColor = colorwithRGBA(240, 60, 50, 1)
        PddsegmentedDataSource.isTitleColorGradientEnabled = true
        PddsegmentedDataSource.isTitleZoomEnabled = true
        PddsegmentedDataSource.reloadData(selectedIndex: 0)
        PddsegmentedView.dataSource = PddsegmentedDataSource
               
        //3、配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .lengthen
        PddsegmentedView.indicators = [indicator]
               
        //4、配置JXSegmentedView的属性
        PddsegmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        PddsegmentedView.dataSource = PddsegmentedDataSource
        view.addSubview(PddsegmentedView)
        self.view.addSubview(PddpagingView)
        PddsegmentedView.contentScrollView = PddpagingView.listContainerView.collectionView
        
    }
    //MARK:-- 数据请求
    func PddGetData(){
        AlamofireUtil.post(url: "/ddk/public/goodsOptGet", param: ["parentOptId":"0"], success: { (res, data) in
            var PddTitlesArr = [PddtitleModel].deserialize(from: data.description)! as! [PddtitleModel]
            for title in PddTitlesArr.reversed(){
                self.PddTitles.append(title)
                self.titles2.append(title.optName!)
            }
            if self.titles2.count > 0 {
                self.reload_newdata()
            }
            
            
            print("titles",self.titles2)
            
        }, error: {
            
        }, failure: {
            
        })
    }
    func reload_newdata(){
        self.PddsegmentedDataSource.titles = self.titles2
        self.PddpagingView.frame = CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH)
        reloadData()
    }
    
    //MARK:-- segmentedView刷新事件
    @objc func reloadData() {
        //一定要统一segmentedDataSource、segmentedView、listContainerView的defaultSelectedIndex
        PddsegmentedDataSource.titles = titles2
        //reloadData(selectedIndex:)一定要调用
        PddsegmentedDataSource.reloadData(selectedIndex: 0)
        
        PddsegmentedView.defaultSelectedIndex = 0
        PddsegmentedView.reloadData()
        
    }

    //MARK:----- 导航栏配置

    func setUpNavigation() {
        self.navigationController?.isNavigationBarHidden = true
        navTopView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height:headerHeight))
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight))
        let navItem = UINavigationItem()
        navBar.backgroundColor = .clear
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.isTranslucent = false
        // 设置item的图片时 加上.withRenderingMode(.alwaysOriginal) 表示使用图片原来的颜色
        let backBtn = UIBarButtonItem(image: UIImage(named: "arrow-back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: #selector(backAction(sender:)))

        navItem.setLeftBarButton(backBtn, animated: true)
        navBar.pushItem(navItem, animated: true)
//        navBar.tintColor = .clear
        let searchView = PddSearchView()
        searchView.layer.cornerRadius = 15
        searchView.layer.masksToBounds = true
        searchView.backgroundColor = kBGGrayColor
        navItem.titleView = searchView
        searchView.navigation = navigationController
        searchView.snp.makeConstraints{ (make) in
            make.center.equalTo((navItem.titleView?.snp.center)!)
            make.width.equalTo(AdaptW(310))
            make.height.equalTo(33)
        }
        navTopView.addSubview(navBar)
        self.view.addSubview(navTopView)
    }
}



@available(iOS 11.0, *)
extension PddViewController: JXPagingViewDelegate{
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return PdduserHeaderContainerView
    }
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return PddTableHeaderViewHeight
    }
    
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return PddheightForHeaderInSection
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return PddsegmentedView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        
        return self.titles2.count
    }
    //MARK:-- 此处添加标签页面
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        let vc = PddBaseListViewController()
        vc.optId = PddTitles[index].optId
        vc.naviController = navigationController
        vc.refresh()
        return vc
      
    }
}
