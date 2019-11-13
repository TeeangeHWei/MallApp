//
//  JdViewController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/11.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class JdViewController: ViewController {
    var JdpagingView: JXPagingView!
    var JdsegmentedDataSource: JXSegmentedTitleDataSource!
    var JdPageingHeaderView: JdHeaderView!
    var JdsegmentedView: JXSegmentedView!
    var JdlistContainerView: JXSegmentedListContainerView!
    var JduserHeaderContainerView: UIView!
    fileprivate var navigationView:UIView!
    let kcycleViewHeight :CGFloat = 156
    var JdTableHeaderViewHeight: Int = 150
    var JdheightForHeaderInSection: Int = 50
    var JdsearchPageView : SearchPageView?
    let titles1 = ["精选", "女装", "男装", "内衣", "美妆", "配饰", "鞋品", "箱包", "儿童", "母婴", "居家", "美食", "数码", "家电"]
    override func viewDidLoad() {
        super.viewDidLoad()
        JduserHeaderContainerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(JdTableHeaderViewHeight)))
        JdPageingHeaderView = JdHeaderView(frame: JduserHeaderContainerView.bounds)
        JduserHeaderContainerView.addSubview(JdPageingHeaderView)
        //1、初始化JXSegmentedView
        JdsegmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: CGFloat(JdheightForHeaderInSection)))
        JdsegmentedView.backgroundColor = UIColor.white
        JdsegmentedView.dataSource = JdsegmentedDataSource
        JdsegmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        JdpagingView = JXPagingView(delegate: self)
        //2、配置数据源
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        JdsegmentedDataSource = JXSegmentedTitleDataSource()
        JdsegmentedDataSource.titles = titles1
        JdsegmentedDataSource.titleNormalColor = .gray
        JdsegmentedDataSource.titleSelectedColor = colorwithRGBA(240, 60, 50, 1)
        JdsegmentedDataSource.isTitleColorGradientEnabled = true
        JdsegmentedDataSource.isTitleZoomEnabled = true
        JdsegmentedDataSource.reloadData(selectedIndex: 0)
        JdsegmentedView.dataSource = JdsegmentedDataSource
        
        //3、配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .lengthen
        JdsegmentedView.indicators = [indicator]
        
        //4、配置JXSegmentedView的属性
        JdsegmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        JdsegmentedView.dataSource = JdsegmentedDataSource
        view.addSubview(JdsegmentedView)
        self.view.addSubview(JdpagingView)
        JdsegmentedView.contentScrollView = JdpagingView.listContainerView.collectionView
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigation()
    }
    
    @objc func reloadData() {
        //一定要统一segmentedDataSource、segmentedView、listContainerView的defaultSelectedIndex
        JdsegmentedDataSource.titles = titles1
        //reloadData(selectedIndex:)一定要调用
        JdsegmentedDataSource.reloadData(selectedIndex: 0)
        
        JdsegmentedView.defaultSelectedIndex = 0
        JdsegmentedView.reloadData()
        
        JdlistContainerView.defaultSelectedIndex = 0
        JdlistContainerView.reloadData()
    }
    //MARK:----- 导航栏配置
    func setUpNavigation() {
        
        setNav(titleStr: "", titleColor: kMainTextColor, navItem: navigationItem, navController: navigationController)
        
        
        
        let searchView = PddSearchView()
        searchView.layer.cornerRadius = 15
        searchView.layer.masksToBounds = true
        searchView.backgroundColor = kBGGrayColor
        navigationItem.titleView = searchView
        searchView.navigation = navigationController
        searchView.snp.makeConstraints{ (make) in
            make.center.equalTo((navigationItem.titleView?.snp.center)!)
            make.width.equalTo(AdaptW(310))
            make.height.equalTo(33)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        JdpagingView.frame = self.view.bounds
        
    }
}
@available(iOS 11.0, *)
extension JdViewController: JXPagingViewDelegate{
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return JduserHeaderContainerView
    }
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return JdTableHeaderViewHeight
    }
    
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return JdheightForHeaderInSection
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return JdsegmentedView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return titles1.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        
            let vc = PddBaseListViewController()
//            vc.optId = index
            vc.naviController = navigationController
        
            return vc
    }
    
}
