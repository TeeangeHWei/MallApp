//
//  NewRecommendController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/29.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class NewRecommendController: ViewController {
    var minId = 1
    var isLoading = false
    var isCancel = false
    var istabHeaderRefreshed = false
    //表格底部用来提示数据加载的视图
    var loadMoreView:UIView?
    //用了记录当前是否允许加载新数据（正则加载的时候会将其设为false，放置重复加载）
    //计数器（用来做延时模拟网络加载效果）
    var timer: Timer!
    var loadMoreEnable = true
    let loadingView = UIActivityIndicatorView(style: .white)
    fileprivate var iconRecommenditem = [[RecommendItem]]()
    fileprivate var newRecommendsitem = [RecommendItem]()
    var releaseTime = [String]()
    let cell_identifier:String = "SecondRecommendCell"
    var RecommendTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.RecommendTableView.gtm_addRefreshHeaderView {
            [weak self] in
            
            self?.tableRefresh()
        }
        RecommendTableView.pullDownToRefreshText("下拉刷新")
        .releaseToRefreshText("松开刷新")
        .refreshSuccessText("刷新成功")
        .refreshFailureText("刷新失败")
        .refreshingText("正在努力加载中...")
        self.RecommendTableView.headerTextColor(.black)
        self.view.backgroundColor = .white
        
//        shotdata()
        setNav()
        createUI()
        getData ()
        makeData()
//        setLoading ()
        setupInfiniteScrollingView()
        self.RecommendTableView.tableFooterView = self.loadMoreView
        // Do any additional setup after loading the view.
    }
    func setNav(){
        let coustomNavView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height:headerHeight))
        coustomNavView.backgroundColor = .white
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight))
        let navItem = UINavigationItem()
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        navBar.tintColor = kMainTextColor
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.isTranslucent = true
        title.text = "发现"
        title.textAlignment = .center
        title.textColor = .black
        navItem.titleView = title
        navBar.pushItem(navItem, animated: true)
        coustomNavView.addSubview(navBar)
        view.addSubview(coustomNavView)
    }
     lazy var dataArr = {() -> [[String]] in
        var darr = [[String]]()
        
        
        for item in self.newRecommendsitem{
            darr.append(item.itempic!)
        }
        return darr
    }
    func loadMore(){
        print("加载新数据！")
        loadMoreEnable = false
        self.getData()
        
    }
    @objc func getData () {
        isLoading = true
        AlamofireUtil.post(url:"/product/public/friend", param: ["min_id":minId],
        success:{(res,data) in
            Recommendiconlist = RecommendList.deserialize(from: data.description)!.data!
            self.iconRecommenditem = [Recommendiconlist]
            self.newRecommendsitem += Recommendiconlist
            self.loadMoreEnable = true
            self.RecommendTableView.reloadData()
            
            if self.isCancel {
                return
            }
            if self.minId != data["min_id"].int! {
                self.minId = data["min_id"].int!
            }
        },
        error:{
            
        },
        failure:{
                            
        })
    }
    fileprivate func makeData(){
        var menu = [RecommendItem]()
        let img =  Recommendiconlist
        for (_,_) in img.enumerated(){
            let imgModel = RecommendItem.init()
            menu.append(imgModel)
        }
        self.iconRecommenditem = [menu]
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
        self.RecommendTableView.addSubview(loadingView)
    }
    // 下拉刷新
       @objc func tableRefresh() {
           DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1)) {
               self.istabHeaderRefreshed = true
               self.timer = Timer.scheduledTimer(timeInterval: 0, target: self,
                                                 selector: #selector(self.getData), userInfo: nil, repeats: false)
               
               self.RecommendTableView.endRefreshing(isSuccess: true)
           }
           self.RecommendTableView.reloadData()
       }
}

@available(iOS 11.0, *)
extension NewRecommendController : UITableViewDelegate,UITableViewDataSource{
    //MARK:--上拉刷新视图
    private func setupInfiniteScrollingView() {
        self.loadMoreView = UIView(frame: CGRect(x:0, y:self.RecommendTableView.contentSize.height,width:self.RecommendTableView.bounds.size.width, height:20))
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
    
    func createUI(){
        self.RecommendTableView = UITableView.init(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH), style:.plain)
        self.RecommendTableView.tableFooterView = UIView.init()
        self.RecommendTableView.delegate = self
        self.RecommendTableView.dataSource = self
        
        self.RecommendTableView.separatorStyle = .none
        self.RecommendTableView.rowHeight = UITableView.automaticDimension
        self.RecommendTableView.estimatedRowHeight = 0
        self.RecommendTableView.estimatedSectionFooterHeight = 0
        self.RecommendTableView.estimatedSectionHeaderHeight = 0
        self.RecommendTableView.allowsSelection = false
        self.RecommendTableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.RecommendTableView.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(60), right: CGFloat(0))
        self.view.addSubview(self.RecommendTableView)
        self.RecommendTableView.register(SecondRecommendCell.classForCoder(), forCellReuseIdentifier: cell_identifier)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newRecommendsitem.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.dataArr()[indexPath.row].count == 3{
            return 430
        }
        if self.dataArr()[indexPath.row].count == 4{
            return 570
        }
        if self.dataArr()[indexPath.row].count > 4 && self.dataArr()[indexPath.row].count < 7{
            return 580
        }
        if self.dataArr()[indexPath.row].count > 7{
            return 667.5
        }
        self.RecommendTableView.reloadData()
        return 400
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SecondRecommendCell = tableView.dequeueReusableCell(withIdentifier: cell_identifier, for: indexPath) as! SecondRecommendCell
        cell.selectionStyle = .none
        cell.recommendnavi = navigationController
        cell.images = self.dataArr()[indexPath.row]
        cell.backgroundColor = .white
        let data = newRecommendsitem[indexPath.row]
        cell.releaseTime!.text = getDateFromTimeStamp10(timeStamp: data.show_time!).format("yyyy/MM/dd HH:mm:ss")
        cell.shotitemid = data.itemid
        cell.shotitemtitle = data.itemtitle
        cell.shareNum?.text = data.dummy_click_statistics!
        cell.shotitemData = newRecommendsitem[indexPath.row]
        let str = data.copy_content!.replacingOccurrences(of: "&lt;br&gt;", with: "\n")
        cell.copyText = str
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 5
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.paragraphStyle: paraph]
        cell.shareText.attributedText = NSAttributedString(string: data.copy_content!.replacingOccurrences(of: "&lt;br&gt;", with: "\n"), attributes: attributes)
        if (loadMoreEnable && indexPath.row == self.newRecommendsitem.count-1){
            loadMore()
        }
//        
        return cell
    }
    
    
}
