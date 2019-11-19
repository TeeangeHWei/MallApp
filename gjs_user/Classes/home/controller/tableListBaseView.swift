//
//  tableListBaseView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/18.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit
import LLCycleScrollView
@available(iOS 11.0, *)
class tableListBaseView: ViewController {
    
    var tableView: UITableView!
    weak var naviController: UINavigationController?
    fileprivate var homeicondataSource = [[homeiconModel]]()
    fileprivate var spikedataSource = [[SpikeModel]]()
    fileprivate var goodsitem = [[goodsItem]]()
    fileprivate var newGoodsitem = [goodsItem]()
    fileprivate var copytext = [pamaModel]()
    fileprivate var shakeDataSource = [[shakeBondData]]()
    fileprivate var newShakeDataSource = [shakeBondData]()
    var istabHeaderRefreshed = false
    var swiper : LLCycleScrollView?
    var cycscroll = [cycleScrollModel]()
    let savemoney = saveMoneyTableViewCell()
    var zeroimg = String()
    var appurlStr = String()
    var adTitle = String()
    var menuiconwidth = Int()
    
    
    var tableViewhome : UITableView!
    
    var minid = 1
    //表格底部用来提示数据加载的视图
    var loadMoreView:UIView?
    
    //计数器（用来做延时模拟网络加载效果）
    var timer: Timer!
    
    //用了记录当前是否允许加载新数据（正则加载的时候会将其设为false，放置重复加载）
    var loadMoreEnable = true
    // 状态栏时间颜色
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HomeTableView()

        
//        tableViewhome.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(tableRefresh))
        self.tableView.gtm_addRefreshHeaderView {
            [weak self] in
            
            self?.tableRefresh()
        }
       
        newGoodsitem = Array.init()
        cycleScroll()
        homeicon()
        // 添加秒杀网络数据
        spikedata()
        // 省钱快报
        savedata()
        //抖券
        shakeData()
        shakebondData()
        // 添加好券数据
        goodsitem1()
        // 将数据添加到视图
        spikeData()
        // 菜单数据
        makeData()
        
        zeroimgdata()
        self.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        // 添加上拉视图
        self.setupInfiniteScrollingView()
        
        //添加底部视图
        self.tableView?.tableFooterView = self.loadMoreView
        
        self.tableViewhome.gtm_addRefreshHeaderView {
             [weak self] in
            self?.tableRefresh()
        }
        tableViewhome.pullDownToRefreshText("下拉刷新")
        .releaseToRefreshText("松开刷新")
        .refreshSuccessText("刷新成功")
        .refreshFailureText("刷新失败")
        .refreshingText("正在努力加载中...")
        self.tableView.headerTextColor(.black)
        
    }
    // 下拉刷新
    @objc func tableRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1)) {
            self.istabHeaderRefreshed = true
            self.timer = Timer.scheduledTimer(timeInterval: 0, target: self,
                                              selector: #selector(self.spikedata), userInfo: nil, repeats: false)
            self.goodsitem1()
            self.cycleScroll()
            self.homeicon()
            self.shakeData()
            self.tableView.endRefreshing(isSuccess: true)
        }
        self.tableView.reloadData()
    }
    
    func HomeTableView(){
        //轮播图
        let xx = UIView.init(frame: CGRect(x: 0, y: 15, width: ScreenW , height: UIScreen.main.bounds.width * 0.393 + 20))
        swiper = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect.init(x: 20, y: 15, width: ScreenW - 35, height: UIScreen.main.bounds.width * 0.393), didSelectItemAtIndex: { index in
            if UserDefaults.getIsShow() == 1{
                let vc = BannerWebViewController()
                vc.webAddress = "https://www.ganjinsheng.com/user/null"
                vc.toUrl = "\(self.cycscroll[index].appUrl ?? "")123"
                print("toUrl:::::::::::::::::::","\(self.cycscroll[index].appUrl ?? "")123")
                vc.headerTitle = self.cycscroll[index].adTitle!
                self.naviController?.pushViewController(vc, animated: true)
            }
        })
        let bgimg = UIImageView.init(frame: CGRect(x: 0, y: 0,   width: ScreenW, height: ScreenW * 0.35))
        bgimg.image = UIImage(named: "WechatIMG30")
        xx.addSubview(bgimg)
        xx.addSubview(swiper!)
        // 是否自动滚动
        swiper?.autoScroll = true
        // 是否无限循环，此属性修改了就不存在轮播的意义了 😄
        swiper?.infiniteLoop = true
        // 滚动间隔时间(默认为2秒)
        swiper?.autoScrollTimeInterval = 3.0
        // 等待数据状态显示的占位图
        //        bannerDemo.placeHolderImage = #UIImage
        // 如果没有数据的时候，使用的封面图
        //        bannerDemo.coverImage = #UIImage
        // 设置图片显示方式=UIImageView的ContentMode
        swiper?.imageViewContentMode = .scaleToFill
        // 设置滚动方向（ vertical || horizontal ）
        swiper?.scrollDirection = .horizontal
        // 设置当前PageControl的样式 (.none, .system, .fill, .pill, .snake)
        swiper?.customPageControlStyle = .snake
        // 非.system的状态下，设置PageControl的tintColor
        swiper?.customPageControlInActiveTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
        // 设置.system系统的UIPageControl当前显示的颜色
        swiper?.pageControlCurrentPageColor = UIColor.white
        // 非.system的状态下，设置PageControl的间距(默认为8.0)
        swiper?.customPageControlIndicatorPadding = 8.0
        // 设置PageControl的位置 (.left, .right 默认为.center)
        swiper?.pageControlPosition = .center
        // 背景色
        swiper?.backgroundColor = .white
        //        self.view.addSubview(swiper)
        // MARK: 添加首页tableview
        tableViewhome = UITableView(frame:CGRect(x: 0, y: kNavigationBarHeight + kCateTitleH, width: kScreenW, height: kScreenH - 170), style: .plain)
        tableViewhome.backgroundColor = UIColor.gray
        tableViewhome.separatorStyle = .none
        // 设置tableview 右滚动线
        tableViewhome.showsVerticalScrollIndicator = false
        // 添加tableview头视图
        tableViewhome.isUserInteractionEnabled = true
        tableViewhome.tableHeaderView = xx
        tableViewhome.backgroundColor = UIColor.clear;
        tableViewhome.rowHeight = 70
        tableViewhome.tableFooterView = UIView.init(frame: CGRect.zero)
        // 防止UITableview刷新时界面“乱跑”现象
        tableViewhome.estimatedRowHeight = 0
        tableViewhome.estimatedSectionFooterHeight = 0
        tableViewhome.estimatedSectionHeaderHeight = 0
        tableViewhome.allowsSelection = false
        tableViewhome.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableViewhome.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(0), right: CGFloat(0))
        swiper?.layer.cornerRadius = 5
        swiper?.layer.masksToBounds = true
        view.addSubview(tableViewhome)
        self.tableView = tableViewhome
        tableViewhome.dataSource = self
        tableViewhome.delegate = self
        
        
    }
    
}

@available(iOS 11.0, *)
//MARK:-- 网络请求
extension tableListBaseView{
    //MARK: --  抖券请求
    @objc func shakeData(){
        AlamofireUtil.post(url: "/product/public/trill", param: ["cat_id":0,"back":10], success: { (res, data) in
            shakeBondlist = shakeBondDataList.deserialize(from: data.description)!.data!
            self.shakeDataSource = [shakeBondlist]
            
            self.tableViewhome.reloadData()
        }, error: {
            
        }, failure: {
            
        })
    }
    
    //MARK: --  轮播图请求
    @objc func cycleScroll(){
        AlamofireUtil.post(url: "/user/public/slideshow/list", param: ["pageNo": 1,"pageSize": 10,"specialShowType":0], success: { (res, data) in
            if UserDefaults.getIsShow() == 1{
                self.cycscroll = cycleScrollList.deserialize(from: data.description)!.list!
                var imglist = [String]()
                for item in self.cycscroll{
                    imglist.append("https://www.ganjinsheng.com\(item.img!)")
                }
                self.swiper?.imagePaths = imglist
                self.tableViewhome.reloadData()
            }else{
                let cycscrollList = cycleScrollList.deserialize(from: data.description)!.list!
                for item in cycscrollList {
                    if item.adTitle == "拉新活动" {
                        self.cycscroll = [item]
                    }
                }
                var imglist = [String]()
                imglist.append("https://www.ganjinsheng.com/files/user/slide/20191115092309.png")
                self.swiper?.imagePaths = imglist
                self.tableViewhome.reloadData()
            }
            
        }, error: {
            
        }, failure: {
            
        })
    }
    
    // 活动图片请求
    @objc func zeroimgdata(){
        AlamofireUtil.post(url: "/user/public/slideshow/list", param: ["pageNo": 1,"pageSize": 1,"specialShowType":5], success: { (res, data) in
            let cycscroll = cycleScrollList.deserialize(from: data.description)!.list!
            
            for item in cycscroll{
                self.zeroimg.append( AlamofireUtil.BASE_IMG_URL + "\(item.img!)")
                let appUrl = item.url
                self.appurlStr = appUrl!
                let adTitle = item.adTitle
                self.adTitle = adTitle!
            }
            self.tableView.reloadData()
        }, error: {
                   
        }, failure: {
                   
        })
    }
    
    //MARK: -- 省钱快报
    @objc func savedata(){
        
        AlamofireUtil.post(url: "/product/public/excellent", param: ["min_id":1,"back":10], success: { (res, data) in
            let pamadata = pamaDataList.deserialize(from: data.description)!.data!
            for item in pamadata{
                pamalist.append(item.copy_text! )
                pamaid.append(item.itemid!)
                self.tableView.reloadData()
            }
            
        }, error: {
            
        }, failure: {
            
        })
    }
    
    //MARK: -- 秒杀
    @objc func spikedata(){
        AlamofireUtil.post(url: "/product/public/searchProduct", param: ["type":1,"back":10,"min_id":1], success: { (res, data) in
            spikelist = spikeDataList.deserialize(from: data.description)!.data!
            self.spikedataSource = [spikelist]
            self.tableView.reloadData()
            
            
        }, error: {
            
        }, failure: {
            
        })
    }
    
    //MARK: -- 推荐好券数据
    @objc func goodsitem1(){
        AlamofireUtil.post(url: "/product/public/getProductList", param: ["nav":3,"back":10,"min_id":self.minid],
                           success: { (res, data) in
                            goodslist = goodsItemDataList.deserialize(from: data.description)!.data!
                            self.goodsitem = [goodslist]
                            self.newGoodsitem += goodslist
                            self.tableView.reloadData()
                            self.loadMoreEnable = true
                            self.minid = data["min_id"].int!
        }, error: {
            
        }, failure: {
            
        })
        
    }
    //MARK: -- 首页icon图标
    @objc func homeicon(){
        AlamofireUtil.post(url: "/comm/public/getIcon", param: ["type":1], success: { (res, data) in
            homeiconlist = homeIconList.deserialize(from: data.description)!.data!
            self.homeicondataSource = [homeiconlist]
            let appicon = homeiconlist.count
            print("appicon:::",appicon)
            self.menuiconwidth = appicon
            self.tableView.reloadData()
        }, error: {
            
        }, failure: {
            
        })
    }
}

@available(iOS 11.0, *)
extension tableListBaseView{
    // MARK: Test
    //MARK: -- 需要时可以添加此下拉刷新
    func refresh() {
        perform(#selector(endRefresing), with: nil, afterDelay: 3)
    }
    
    @objc func endRefresing() {
        self.tableView?.endRefreshing(isSuccess: true)
    }
    func loadMore(){
        print("加载新数据！")
        loadMoreEnable = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                     selector: #selector(goodsitem1), userInfo: nil, repeats: false)
        
    }
    // MARK:-- 伪造分类数据
    fileprivate func makeData(){
        var menu = [homeiconModel]()
        let iconimg = homeiconlist
        for(_,_) in iconimg.enumerated(){
            let iconmodel = homeiconModel.init()
            menu.append(iconmodel)
        }
        self.homeicondataSource = [menu]
        self.tableView.reloadData()
    }
    //MARK: -- 秒杀数据
    fileprivate func spikeData(){
        var spikeArr = [SpikeModel]()
        let spikeimg = spikelist
        
        for(_,_) in spikeimg.enumerated(){
            let spikeModel = SpikeModel.init()
            spikeArr.append(spikeModel)
        }
        self.spikedataSource = [spikeArr]
        self.tableView.reloadData()
    }
    // 需要遍历此方法将shakeDataSource 附上值
    fileprivate func shakebondData(){
        var shakeArr = [shakeBondData]()
        let shakeimg = shakeBondlist
        
        for(_,_) in shakeimg.enumerated(){
            let shakeModel = shakeBondData.init()
            shakeArr.append(shakeModel)
        }
        self.shakeDataSource = [shakeArr]
        self.tableView.reloadData()
    }
    
}
@available(iOS 11.0, *)
extension tableListBaseView : UITableViewDelegate,UITableViewDataSource{
    //MARK:--上拉刷新视图
    private func setupInfiniteScrollingView() {
        self.loadMoreView = UIView(frame: CGRect(x:0, y:self.tableView.contentSize.height,width:self.tableView.bounds.size.width, height:100))
        self.loadMoreView!.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        self.loadMoreView!.backgroundColor = colorwithRGBA(241, 241, 241, 1)
        
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 返回 三组
        return 7     // 也可是 return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 1
        }else if section == 2{
            return 1
        }else if section == 3{
            return 1
        }else if section == 4{
            return 1
        }else if section == 5{
            if UserDefaults.getIsShow() == 1{
                return 0
            }else{
                return 0
            }
        }else{
            return self.newGoodsitem.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 判断当前tableviewcell高度
        if indexPath.section == 0 {
            return 210
        }else if indexPath.section == 1{
            return 195
        }else if indexPath.section == 2{
            return 38
        }else if indexPath.section == 4{
            return 185
            
        }else if indexPath.section == 3{
            if UserDefaults.getIsShow() == 1{
                return 120
            }else{
                return 0
            }
            
        }else if indexPath.section == 5{
            return 270
            
        }else{
            if self.goodsitem.count > 0 {
                if indexPath.row == 0 {
                    return 187      // 第一张卡片 返回高度
                }
                return 130         // 其余卡片 高度
                
            }
            return 0.01
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = MenuTableViewCell.dequeue(tableView)
            cell.naviController = naviController
            print("iconArr",indexPath.row)
            cell.iconArr = self.homeicondataSource[indexPath.row]
            cell.iconwidth = menuiconwidth
            cell.backgroundColor = UIColor.clear
            return cell
        }else if indexPath.section == 1{
            let cell = SpikeTableViewCell.dequeue(tableView)
            cell.naviController = naviController
            cell.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            cell.layer.shadowColor = UIColor.init(hexString: "999999").cgColor
            cell.layer.shadowRadius = 13
            cell.layer.shadowOffset = CGSize(width: 3, height: -5)
            cell.layer.shadowOpacity = 0.2
            cell.layer.cornerRadius = 12
            cell.backgroundColor = UIColor.white
            cell.dataArr = self.spikedataSource[indexPath.row]
            cell.backgroundColor = UIColor.clear
            cell.frame = CGRect(x: -10, y: -20, width: kScreenW - 20, height: kScreenH - 20)
            return cell
            
        }else if indexPath.section == 2{
            let cell = saveMoneyTableViewCell.dequeue(tableView)
            cell.naviController = naviController
            cell.modelArr = pamalist
            cell.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            cell.layer.shadowColor = UIColor.init(hexString: "999999").cgColor
            cell.layer.shadowRadius = 3
            cell.layer.shadowOffset = CGSize(width: 1, height: 2)
            cell.layer.shadowOpacity = 0.15
            cell.layer.cornerRadius = 12
            cell.backgroundColor = UIColor.clear
            return cell
            
        }else if indexPath.section == 3{
            let cell = officialTableViewCell.dequeue(tableView)
           
            cell.navC = naviController
//            let urlimg = URL.init(string: zeroimg)?.absoluteString
            
            cell.buyStr = appurlStr
            cell.zeroadtitle = adTitle
//            cell.officialbtn.kf.setBackgroundImage(with: urlimg, for: .normal)
            cell.cycleView.setUrlsGroup([zeroimg])
            print("zeroimg::",[zeroimg])
            cell.backgroundColor = UIColor.clear
            return cell
            
        }else if indexPath.section == 4{
            let cell = zeroTableViewCell.dequeue(tableView)
            
            cell.naviController = naviController
            cell.backgroundColor = UIColor.clear
            
            return cell
        }else if indexPath.section == 5{
            let cell = shakebondTableViewCell.dequeue(tableView)
            cell.naviController = naviController
            cell.backgroundColor = colorwithRGBA(241, 241, 241, 1)
            cell.shakebondModel = self.shakeDataSource[indexPath.row]
            return cell
            
        }else{
            let cell = recommendTableViewCell.dequeue(tableView)
            cell.hw_delegate = self
            cell.backgroundColor = colorwithRGBA(241, 241, 241, 1)
            if self.newGoodsitem.count > 0
            {
                if indexPath.row == 0 {
                    cell.firstCard = true
                    
                }else {
                    cell.firstCard = false
                }
                cell.model = self.newGoodsitem[indexPath.row]
                
            }
            if (loadMoreEnable && indexPath.row == self.newGoodsitem.count-1){
                loadMore()
            }
            
            
            return cell
            
        }
    }
}


@available(iOS 11.0, *)
extension tableListBaseView : recommendTableViewCellDelegate {
    func commentClickDelegate(_ cell: recommendTableViewCell, withModel model: goodsItem) {
        let vc = DetailController()
        print("id : \(String(describing: model.itemid))")
        detailId = Int(model.itemid!)!
        naviController?.pushViewController(vc, animated: true)
    }
}

@available(iOS 11.0, *)
extension tableListBaseView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
    func listDidAppear() {
        print("listDidAppear")
    }
    
    func listDidDisappear() {
        print("listDidDisappear")
    }
}
