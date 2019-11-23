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
    var navTopView : UIView!
    var JdpagingView: JXPagingView!
    var JdsegmentedDataSource: JXSegmentedTitleDataSource!
    var JdPageingHeaderView: JdHeaderView!
    var JdsegmentedView: JXSegmentedView!
    var JdlistContainerView: JXSegmentedListContainerView!
    var JduserHeaderContainerView: UIView!
    fileprivate var navigationView:UIView!
    let kcycleViewHeight :CGFloat = 156
    var JdTableHeaderViewHeight: Int = Int(kScreenW * 0.85)
    var JdheightForHeaderInSection: Int = 50
    var jdTitles = [String]()
    var jdTitlesModel = [jdTitleModel]()
    var jdCycleModel = [cycleScrollModel]()
    var imglist = [String]()
    var JdsearchPageView : SearchPageView?
    let titles1 = ["精选", "女装", "男装", "内衣", "美妆", "配饰", "鞋品", "箱包", "儿童", "母婴", "居家", "美食", "数码", "家电"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigation()
        jdTitleData()
        jdCycleScroll()
        self.view.backgroundColor = .white
        setui()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    #warning("因为数据是异步的,必须使用生命周期控制pagingView显示")
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
        
//        PddpagingView.mainTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        
    }
    func setui(){
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
//               JdsegmentedDataSource.titles = jdTitles
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
    
    @objc func reloadData() {
        //一定要统一segmentedDataSource、segmentedView、listContainerView的defaultSelectedIndex
        JdsegmentedDataSource.titles = jdTitles
        //reloadData(selectedIndex:)一定要调用
        JdsegmentedDataSource.reloadData(selectedIndex: 0)
        JdsegmentedView.defaultSelectedIndex = 0
//        JdlistContainerView.defaultSelectedIndex = 0
//        JdlistContainerView.reloadData()

        JdsegmentedView.reloadData()
    }
    //MARK:-- 数据请求
    func jdTitleData(){
        AlamofireUtil.post(url: "/jd/public/categoryGoodsGet", param: ["parentId":0, "grade":0], success: { (res, data) in
            print("data:::",res)
            var titleArr = [jdTitleModel].deserialize(from: data.description)! as! [jdTitleModel]
            let inserArr = jdTitleModel.init(tid:"22",tname:"精选")
            titleArr.insert(inserArr, at: 0)
            for title in titleArr{
                self.jdTitlesModel.append(title)
                self.jdTitles.append(title.name ?? "")
            }
            print("titlearr::",titleArr)
            if self.jdTitles.count > 0 {
                self.reload_newdata()
            }
            
        }, error: {
            
        }, failure: {
            
        })
    }
    //MARK: --  轮播图请求
     func jdCycleScroll(){
        AlamofireUtil.post(url: "/user/public/slideshow/list", param: ["pageNo": 1,"pageSize": 10,"specialShowType":4], success: { (res, data) in
            if UserDefaults.getIsShow() == 1{
                self.jdCycleModel = cycleScrollList.deserialize(from: data.description)!.list!
                
                for item in self.jdCycleModel{
                    self.imglist.append("https://www.ganjinsheng.com\(item.img!)")
                }
                print("pddCycleModel:",self.imglist)
                self.JdPageingHeaderView.cycleView.setUrlsGroup(self.imglist)
                self.JdpagingView.mainTableView.reloadData()
            }
        }, error: {
            
        }, failure: {
            
        })
    }
    func reload_newdata(){
        print("self.title",self.jdTitles)
        self.JdpagingView.frame = CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH)
        self.JdsegmentedDataSource.titles = self.jdTitles
        
        reloadData()
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
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        JdpagingView.frame = CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH)
//
//    }
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
        return jdTitles.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        
            let vc = jdTestBaseView()
        if index == 0 {
            vc.dataSource = ["橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮", "橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮"]
        }else if index == 1 {
            vc.dataSource = ["吃烤肉", "吃鸡腿肉", "吃牛肉", "各种肉"]
        }else {
            vc.dataSource = ["【剑士】罗罗诺亚·索隆", "【航海士】娜美", "【狙击手】乌索普", "【厨师】香吉士", "【船医】托尼托尼·乔巴", "【船匠】 弗兰奇", "【音乐家】布鲁克", "【考古学家】妮可·罗宾"]
        }
        vc.beginFirstRefresh()
//            vc.optId = index
//            vc.naviController = navigationController
        
            return vc
    }
    
}
