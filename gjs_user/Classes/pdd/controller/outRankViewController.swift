//
//  outRankViewController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/12.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class outRankViewController: ViewController,UIScrollViewDelegate {
    let titles = ["实时热销榜","实时收益榜"]
    var navTopView : UIView!
    var segmentedDataSource: JXSegmentedBaseDataSource?
    let segmentedView = JXSegmentedView()
    weak var naviController : UINavigationController?
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    let body = UIScrollView()
    // 标题分类id
    var classfiyid : Int?
    var classfiy = 1
    var allHeight = 0
    var minId = 1
    var isLoading = false
    var isFinish = false
    private var sort = 0
    let loadingView = UIActivityIndicatorView(style: .white)
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        self.view.backgroundColor = colorwithRGBA(241, 241, 241, 1)
        
        //设置标题数据源
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titles = titles
        dataSource.titleNormalColor = .white
        dataSource.titleSelectedStrokeWidth = -2.8
        dataSource.titleNormalFont = UIFont.systemFont(ofSize: 18)
        dataSource.titleSelectedColor = colorwithRGBA(240, 60, 50, 1)
               
        //reloadData(selectedIndex:)一定要调用
        dataSource.reloadData(selectedIndex: 0)
        self.segmentedDataSource = dataSource
        //配置标题指示器
        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorHeight = 25
        indicator.indicatorWidth = 100
        indicator.scrollAnimationDuration = 0.1
        indicator.indicatorColor = .white
        self.segmentedView.indicators = [indicator]
        
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        view.addSubview(segmentedView)
        //MARK:-- 标题滚动页面视图
        segmentedView.contentScrollView = listContainerView.scrollView
        listContainerView.didAppearPercent = 0.01
        view.addSubview(listContainerView)
        
        self.view.addSubview(self.segmentedView)
//        view.addSubview(statusView)
    }
    // 修改系统状态栏字颜色为白色
       override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }
       
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
       }
    
    func setNav(){
        self.navigationController?.isNavigationBarHidden = true
        let navView = customNav(titleStr: "出单排行", titleColor: .white, border: true)
        navView.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        self.view.addSubview(navView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let gradientLayer : CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = kCGGradientColors
        //(这里的起始和终止位置就是按照坐标系,四个角分别是左上(0,0),左下(0,1),右上(1,0),右下(1,1))
        //渲染的起始位置
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        //渲染的终止位置
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        //设置frame和插入view的layer
        segmentedView.frame = CGRect(x: 0, y: headerHeight, width: kScreenW, height: kCateTitleH)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kCateTitleH)
//        segmentedView.backgroundColor = kCGGradientColors
        segmentedView.layer.insertSublayer(gradientLayer, at: 0)
        
        listContainerView.frame = CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH)
        
    }
    
    
    
    @objc func didIndicatorPositionChanged() {
        for indicaotr in (segmentedView.indicators as! [JXSegmentedIndicatorBaseView]) {
            if indicaotr.indicatorPosition == .bottom {
                indicaotr.indicatorPosition = .top
            }else {
                indicaotr.indicatorPosition = .bottom
            }
        }
        segmentedView.reloadData()
    }

}
extension outRankViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
            //先更新数据源的数据
            dotDataSource.dotStates[index] = false
            //再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)
        }
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        //传递didClickSelectedItemAt事件给listContainerView，必须调用！！！
        listContainerView.didClickSelectedItem(at: index)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        //传递scrollingFrom事件给listContainerView，必须调用！！！
        listContainerView.segmentedViewScrolling(from: leftIndex, to: rightIndex, percent: percent, selectedIndex: segmentedView.selectedIndex)
    }
}


@available(iOS 10.0, *)
extension outRankViewController: JXSegmentedListContainerViewDataSource {
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        let PddRankVc = PddRankListViewController()
        PddRankVc.classfiyid = index
        PddRankVc.naviController = navigationController
        return PddRankVc
        
    }
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
        return titleDataSource.dataSource.count
        }
        return 0
    }
}
extension outRankViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
    func listDidAppear() {
    }
    
    func listDidDisappear() {
    }
}
