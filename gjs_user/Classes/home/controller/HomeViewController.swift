//
//  HomeViewController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/10.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit
//import SwiftTheme
import RxSwift
import RxCocoa
import JXSegmentedView
import LLCycleScrollView

// 记录导航栏是否隐藏



//必须设置全局 赋值 grayview
@available(iOS 11.0, *)
class HomeViewController: ViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    let isShow = UserDefaults.getIsShow()
    var navTopView : UIView!
    //MARK: 添加分类按钮
    lazy var addClassBtn : UIButton = {
        let addClassBtn = UIButton(frame:CGRect(x: kScreenW - 40, y: kNavigationBarHeight + kStatuHeight, width: 40, height: 40))
        addClassBtn.setImage(UIImage(named: "6-1"), for: .normal)
        return addClassBtn
    }()
    // 标题数组
    var Classfiytitles = [String]()
    // 图片数组
    var classfiyImg = [String]()
    // 此使用全局变量
    var  collectionView : UICollectionView?
    let Identifier = "channlViewCell"
    let headerIdentifier = "CollectionHeaderView"
    let footIdentifier = "CollectionFooterView"
    
    // 定义全局分类title
    var classfiyTitle = [HWGeneralModel]()
    var classfiyimg = [HWInfoListModel]()
    
    var segmentedDataSource: JXSegmentedBaseDataSource?
    let segmentedView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    fileprivate var grayBKView : UIView!
    //MARK: 标题数组
    var titles = [String]()
    
    let titles1 = ["精选", "女装", "男装", "内衣", "美妆", "配饰", "鞋品", "箱包", "儿童", "母婴", "居家", "美食", "数码", "家电"]
    // MARK:设置灰色背景视图
    func grayView() -> UIView{
        let grayview = UIView()
        grayview.frame = CGRect(x: 0, y: 20, width: ScreenW, height: ScreenH - (kStatuHeight+kNavigationBarHeight))
        grayview.backgroundColor = UIColor(white: 0.1, alpha: 0.2)
        grayview.isHidden = true
        let guesture = UITapGestureRecognizer(target:self,action:#selector(self.singleTap))
        grayview.addGestureRecognizer(guesture)
        // 设置背景视图图层
        self.view.insertSubview(grayview, at: 10)
        return grayview
    }
    
    
    
    
    //MARK: 状态栏
    lazy var statusView : UIView = {
        let view = UIView()
//        view.backgroundColor = kLowOrangeColor;
        view.frame = CGRect(x: 0, y: kNavigationBarHeight, width: kScreenW, height: kStatuHeight)
        // 背景渐变
        let gradientLayer : CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = kCGGradientColors
        //(这里的起始和终止位置就是按照坐标系,四个角分别是左上(0,0),左下(0,1),右上(1,0),右下(1,1))
        //渲染的起始位置
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        //渲染的终止位置
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        //设置frame和插入view的layer
        gradientLayer.frame = CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight)
        view.layer.insertSublayer(gradientLayer, at: 0)
        return view
    }()
    
    var titles_arr = [HWGeneralModel]()
    
    // 修改系统状态栏字颜色为白色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置标题数据源
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titles = titles1
        dataSource.titleNormalColor = .white
        dataSource.titleSelectedStrokeWidth = -2.8
        dataSource.titleNormalFont = UIFont.systemFont(ofSize: 15)
        dataSource.titleSelectedColor = colorwithRGBA(240, 60, 50, 1)
        
        //reloadData(selectedIndex:)一定要调用
        dataSource.reloadData(selectedIndex: 0)
        self.segmentedDataSource = dataSource
        //配置标题指示器
        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorHeight = 25
        indicator.indicatorWidth = 40
        indicator.scrollAnimationDuration = 0.1
        indicator.indicatorColor = .white
        self.segmentedView.indicators = [indicator]
        
        loadHomeClassfiy()
        //MARK: --标题分段控制器
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        view.addSubview(segmentedView)
        //MARK:-- 标题滚动页面视图
        segmentedView.contentScrollView = listContainerView.scrollView
        listContainerView.didAppearPercent = 0.01
        view.addSubview(listContainerView)
        // 赋值
        self.grayBKView = self.grayView()
        // 添加弹出按钮
        self.popchannlview(btn: addClassBtn)
        // 添加顺序不能错。
        setUpAllView()
        
        // 添加分类按钮
        self.view.addSubview(addClassBtn)
        
        // 添加分类视图
        classfiy()
        
        // 添加点击事件
        clickAction()
        
        self.view.addSubview(self.segmentedView)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if isFirst {
            pasteboard()
            isFirst = false
        }
    }
    
    // 识别剪贴板中的内容
    func pasteboard () {
        // 识别剪贴板中的内容
        if let paste = UIPasteboard.general.string {
            if paste == "" {
                return
            }
            searchStr = paste
            shearPlate(str : paste)
            UIPasteboard.general.string = ""
        }
    }
    
    // 剪切板弹窗
    func shearPlate (str : String) {
        let dialog = ShearPlateView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH), copyStr: str)
        self.view.window?.addSubview(dialog)
    }
    
    /// 圆角设置
    ///
    /// - Parameters:
    ///   - view: 需要设置的控件
    ///   - corner: 哪些圆角
    ///   - radii: 圆角半径
    /// - Returns: layer图层
    func configRectCorner(view: UIView, corner: UIRectCorner, radii: CGSize) -> CALayer {
        
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: radii)
        
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        
        return maskLayer
    }
    
    //MARK: 首页分类视图
    public func classfiy(){
        collectionView?.frame = self.view.frame
        collectionView?.isUserInteractionEnabled = true
        let layout = UICollectionViewFlowLayout.init()
        // 屏幕宽
        layout.itemSize = CGSize(width: (kScreenW - 36) / 4, height: 75 )
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 20, right: 10)
        layout.headerReferenceSize = CGSize.init(width: kTabBarHeight, height: 0)
        layout.footerReferenceSize = CGSize.init(width: kScreenW, height: 50)
        
        collectionView = UICollectionView.init(frame: CGRect(x: 0, y: kNavigationBarHeight + kStatuHeight + 40, width: kScreenW, height: kScreenW * 0.93),collectionViewLayout:layout)
        collectionView?.isScrollEnabled = false
        collectionView?.backgroundColor = UIColor.white
        collectionView?.layer.mask = self.configRectCorner(view: collectionView!, corner: [.bottomLeft,.bottomRight], radii: CGSize(width: 15, height: 15))
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.isHidden = true
        collectionView?.tag = 1
        
        
        collectionView?.register(UINib.init(nibName: "channlViewCell", bundle: nil), forCellWithReuseIdentifier: Identifier)
        
        collectionView?.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,withReuseIdentifier: headerIdentifier)
        
        collectionView?.register(CollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,withReuseIdentifier: footIdentifier)
        
        self.view.addSubview(collectionView!)
        
    }
    
    
    
    // 分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // 每个区item个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.classfiyTitle.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : channlViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier, for: indexPath) as! channlViewCell
        
        cell.bgView.backgroundColor = kWhite
        cell.ClassfiyModelTitle = self.classfiyTitle[indexPath.row]
        cell.ClassfiyModelImg = self.classfiyimg[indexPath.row]
        
        
        return cell
        
    }
    //MARK:-----  分类点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        segmentedView.selectItemAt(index: indexPath.row)
        listContainerView.didClickSelectedItem(at: indexPath.row)
        collectionView.isHidden = true
        grayBKView.isHidden = true
        
    }
    
    
    @objc func clickmsg(){
        navigationController?.pushViewController(NewsView(), animated: true)
    }
    //MARK: 分类数据请求及解析
    func loadHomeClassfiy(){
        let url = BASE_URL + "product/public/classify"
        let params = ["":""]
        // 发起请求
        netmanager.request(url,method: .post, parameters: params).responseJSON{ (response) in
            //网络错误提示
            if let Error = response.result.error{
                print(Error)
            }
            // bug jie jue de zen me yang le youdu
            else if let jsonResult = response.result.value{
                let jsondic = JSON(jsonResult)
                
                self.Classfiytitles.removeAll()
                self.classfiyimg.removeAll()
                /// 请求前清空数组
                self.classfiyTitle.removeAll()
                // 转为字典对象
                if let dict = jsondic.dictionaryObject {
                    //转为字典类型
                    if let resultDict = dict["result"] as? NSDictionary {
                        // 数组里包含字典
                        if let genArr = resultDict["general_classify"] as? Array<NSDictionary> {
                            // 添加在数组中首个数组数据
                            var Deathtitle = HWGeneralModel.init()
                            Deathtitle.main_name = "精选"
                            self.classfiyTitle.insert(Deathtitle, at: 0)
                            //遍历数组
                            for genDict in genArr{
                                // 把数据放到模型
                                var genModel = HWGeneralModel.init()
                                // ？！可选 参数不确定时 可用？ 确定参数为某类型可以用！
                                genModel.main_name = genDict["main_name"] as? String
                                
                                self.Classfiytitles.append(genDict["main_name"] as! String)
                                
                                // 数组添加
                                self.classfiyTitle.append(genModel)
                                var dataModel_Arr = [HWDataModel]()
                                if let dataArr = genDict["data"] as? Array<NSDictionary>{
                                    for data in dataArr{
                                        var dataModel = HWDataModel.init()
                                        var infoModel_arr = [HWInfoListModel]()
                                        if let infoArr = data["info"] as? Array<NSDictionary>{
                                            for info in infoArr{
                                                var infoModel = HWInfoListModel.init()
                                                infoModel.imgurl = info["imgurl"] as? String
                                                infoModel_arr.append(infoModel)
                                                
                                            }
                                            
                                            dataModel.info = infoModel_arr
                                        }
                                        
                                        dataModel_Arr.append(dataModel)
                                    }
                                    //一层一层取到想要的数据
                                    let firstData = dataModel_Arr.first
                                    let yy = firstData?.info
                                    //取数组里的第一个元素
                                    self.classfiyimg.append(yy!.first!)
                                    
                                }
                                genModel.data = dataModel_Arr
                            }
                            // 添加分类第一张图片
                            var DeathImg = HWInfoListModel.init()
                            DeathImg.imgurl = "https://www.ganjinsheng.com/user/static/img/classification.66c5dba.jpeg"
                            // 在原有数据数组前添加数据
                            self.classfiyimg.insert(DeathImg, at: 0)
                            
                        }
                        
                        
                    }
                }
                self.collectionView?.reloadData()
            }
        }
    }
    
    //MARK: 添加隐藏分类手势
    @objc func singleTap(){
        collectionView?.isHidden = true
        grayBKView.isHidden = true
    }
    
    //MARK: 弹出分类列表并隐藏显示和隐藏灰色背景
    @objc func popchannlview(btn:UIButton){
        
        if collectionView?.isHidden == true {
            collectionView?.isHidden = false
            self.grayBKView.isHidden = false
        } else {
            collectionView?.isHidden = true
            self.grayBKView.isHidden = true
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setUpNavigation()
        //处于第一个item的时候，才允许屏幕边缘手势返回
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //
        segmentedView.frame = CGRect(x: 0, y: headerHeight, width: kScreenW - 50, height: kCateTitleH)
        listContainerView.frame = CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kScreenH)
        
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
    func clickAction() {
        // 点击事件
        addClassBtn.addTarget(self, action: #selector(popchannlview(btn:)), for: .touchUpInside)
    }
    
}

@available(iOS 11.0, *)
extension HomeViewController{
    //MARK:----- 自定义导航栏配置
    func setUpNavigation() {
        
        self.navigationController?.isNavigationBarHidden = true
        
        navTopView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height:headerHeight))
        
        // 背景渐变
        let gradientLayer : CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = kCGGradientColors
        //(这里的起始和终止位置就是按照坐标系,四个角分别是左上(0,0),左下(0,1),右上(1,0),右下(1,1))
        //渲染的起始位置
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        //渲染的终止位置
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        //设置frame和插入view的layer
        gradientLayer.frame = navTopView.frame
        navTopView.layer.insertSublayer(gradientLayer, at: 0)
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight))
        let navItem = UINavigationItem()
        navBar.backgroundColor = .clear
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.apply(gradient: kGradientColors)
        navBar.isTranslucent = false
        let rightbtn = UIBarButtonItem(image: UIImage(named: "5-3")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.clickmsg))
        navItem.rightBarButtonItem?.tintColor = .white
        navItem.setRightBarButton(rightbtn, animated: true)
        navBar.pushItem(navItem, animated: true)

        
        let searchView = HWHomeSearchView()
        searchView.layer.cornerRadius = 15
        searchView.layer.masksToBounds = true
        searchView.backgroundColor = kSearchBGColor
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
extension HomeViewController{
    func setUpAllView(){
        //添加状态栏到视图
        view.addSubview(statusView)
        // 添加导航栏
        setUpNavigation()
    }
}

@available(iOS 11.0, *)
extension HomeViewController: JXSegmentedViewDelegate {
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

@available(iOS 11.0, *)
extension HomeViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }
    
    //MARK:-- 判断当前标题index 滑动控制器
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0{
            let vc = tableListBaseView()
            vc.naviController = navigationController
            return vc
        }else if index == 1{
            let vc = HomeClassViewController()
            vc.classfiyid = index
            vc.naviController = navigationController
            return vc
        }else if index == 2{
            let vc = HomeClassViewController()
            vc.classfiyid = index
            vc.naviController = navigationController
            return vc
        }else if index == 3{
            let vc = HomeClassViewController()
            vc.classfiyid = index
            vc.naviController = navigationController
            return vc
        }else if index == 4{
            let vc = HomeClassViewController()
            vc.classfiyid = index
            vc.naviController = navigationController
            return vc
        }else if index == 5{
            let vc = HomeClassViewController()
            vc.classfiyid = index
            vc.naviController = navigationController
            return vc
        }else if index == 6{
            let vc = HomeClassViewController()
            vc.classfiyid = index
            vc.naviController = navigationController
            return vc
        }else if index == 7{
            let vc = HomeClassViewController()
            vc.classfiyid = index
            vc.naviController = navigationController
            return vc
        }else if index == 8{
            let vc = HomeClassViewController()
            vc.classfiyid = index
            vc.naviController = navigationController
            return vc
        }else if index == 9{
            let vc = HomeClassViewController()
            vc.classfiyid = index
            vc.naviController = navigationController
            return vc
        }else if index == 10{
            let vc = HomeClassViewController()
            vc.classfiyid = index
            print("参数：：",vc.classfiyid as Any)
            vc.naviController = navigationController
            return vc
        }else if index == 11{
            let vc = HomeClassViewController()
            vc.classfiyid = index
            vc.naviController = navigationController
            return vc
        }else if index == 12{
            let vc = HomeClassViewController()
            vc.classfiyid = index
            vc.naviController = navigationController
            return vc
        }else{
            let vc = HomeClassViewController()
            vc.classfiyid = index
            vc.naviController = navigationController
            return vc
        }
    }
}

