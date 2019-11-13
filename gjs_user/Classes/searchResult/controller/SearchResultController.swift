//
//  SearchResultController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/15.
//  Copyright © 2019 大杉网络. All rights reserved.
//


@available(iOS 11.0, *)
class SearchResultController: ViewController, UIScrollViewDelegate, sortDelegate, UITextFieldDelegate {
    
    var platform = 0
    var isCancel = false
    var isTKL = false
    let inputControl = UITextField(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.65, height: 30))
    var allHeight = 0
    var pageNo = 0
    var sort = 0
    var isLoading = false
    var isFinish = false
    var isError = false
    var navTopView : UIView!
    let loadingView = UIActivityIndicatorView(style: .white)
    let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight + 90, width: kScreenW, height: kScreenH - 88))
    
    // 切换平台类型相关
    private let layer1 = CALayer()
    private var typeArr = [UIButton]()
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 打印当前滚动条实时位置
        let height = allHeight - Int(kScreenH) + Int(headerHeight) + 40
        if Int(scrollView.contentOffset.y) >= height && !isLoading {
//            isLoading = true
            if platform == 0 {
                getData(refresh: false)
            } else if platform == 1 {
                pddSearch(refresh: false)
            }
        }
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isCancel = false
    }

    override func viewDidLoad() {
        isHistory()
        view.backgroundColor = kBGGrayColor
        // 滚动时隐藏键盘
        body.keyboardDismissMode = .onDrag
        
        
        // 平台类型
        let typeList = ["淘宝", "拼多多"]
        let typeBar = UIView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: 46))
        typeBar.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .center
            layout.width = YGValue(kScreenW)
            layout.height = 46
        }
        typeBar.backgroundColor = .white
        typeBar.addBorder(side: .top, thickness: 1, color: klineColor)
        typeBar.addBorder(side: .bottom, thickness: 1, color: klineColor)
        for (index, item) in typeList.enumerated() {
            let width = (kScreenW - 60)/3
            let typeItem = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 46))
            typeItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(width)
                layout.height = 46
                layout.paddingLeft = 30
                layout.paddingRight = 30
            }
            typeItem.setTitle(item, for: .normal)
            if(index == platform){
                typeItem.setTitleColor(kLowOrangeColor, for: .normal)
            }else{
                typeItem.setTitleColor(kGrayTextColor, for: .normal)
            }
            typeItem.addTarget(self, action: #selector(typeChange), for: .touchUpInside)
            typeItem.titleLabel?.font = FontSize(14)
            typeItem.tag = index
            typeArr.append(typeItem)
            typeBar.addSubview(typeItem)
        }
        //下划线
        let width = (kScreenW - 60)/12
        if platform == 0 {
            layer1.frame = CGRect(x: 30 + width * 3.5, y: 42, width: width, height: 4)
        } else {
            let left = ((kScreenW - 60)/3) * CGFloat(self.platform)
            let x = 30 + (kScreenW - 60)/6 + (kScreenW - 60)/8 + left
            layer1.frame = CGRect(x: x, y: 42, width: width, height: 4)
        }
        
        layer1.cornerRadius = 2
        layer1.backgroundColor = kLowOrangeColor.cgColor
        typeBar.layer.addSublayer(layer1)
        typeBar.yoga.applyLayout(preservingOrigin: true)
        self.view.addSubview(typeBar)
        // 筛选栏
        let screenBar = ScreenBar(frame: CGRect(x: 0, y: headerHeight + 46, width: kScreenW, height: 40))
        screenBar.delegate = self
        view.addSubview(screenBar)
        // 宝贝列表
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - 40)
            layout.position = .relative
        }
        view.addSubview(body)
        
        setLoading()
        
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
        
//        getData(refresh: false)
        
        if platform == 0 {
            getTitleByTkl()
        } else if platform == 1 {
            pddSearch(refresh: false)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavC()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isCancel = true
    }
    
    //切换平台
    @objc func typeChange(_ btn: UIButton){
        typeArr[platform].setTitleColor(kGrayTextColor, for: .normal)
        typeArr[btn.tag].setTitleColor(kLowOrangeColor, for: .normal)
        platform = btn.tag
        UIView.animate(withDuration: 0.3) {
            let left = ((kScreenW - 60)/3) * CGFloat(self.platform)
            self.layer1.frame.origin.x = 30 + (kScreenW - 60)/6 + (kScreenW - 60)/8 + left
        }
        refresh()
    }
    
    // 筛选栏回调函数
    func sortDelegatefuc(backMsg: Int) {
        self.sort = backMsg
        isFinish = false
        isLoading = false
        if isTKL {
            body.clearAll3()
        } else {
            body.clearAll()
        }
        setLoading()
        pageNo = 0
        allHeight = 0
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(self.allHeight + 150), right: CGFloat(0))
        if platform == 0 {
            getData(refresh: true)
        } else if platform == 1 {
            pddSearch(refresh: true)
        }
        setLoading()
    }
    // 判断是否搜索的关键词是否已有记录
    func isHistory () {
        var historyList = UserDefaults.getHistory() as! [String]
        if platform == 1 {
            historyList = UserDefaults.getHistoryPdd() as! [String]
        }
        var isHistory = 1 // 0 已有相同历史记录  1 没有相同历史记录  2 没有任何历史记录，即暂无历史
        for item in historyList {
            if item == "暂无历史" {
                isHistory = 2
            } else if item == searchStr! {
                isHistory = 0
            }
        }
        if isHistory == 1 {
            if historyList.count >= 10 {
                historyList.removeFirst()
            }
            historyList.append(searchStr!)
            if platform == 0 {
                UserDefaults.setHistory(value: historyList)
            } else if platform == 1 {
                UserDefaults.setHistoryPdd(value: historyList)
            }
        } else if isHistory == 2 {
            historyList = [String]()
            historyList.append(searchStr!)
            if platform == 0 {
                UserDefaults.setHistory(value: historyList)
            } else if platform == 1 {
                UserDefaults.setHistoryPdd(value: historyList)
            }
        }
    }
    // 设置 navigationController
    func setNavC () {
//        setNav(titleStr: "", titleColor: kMainTextColor, navItem: navigationItem, navController: navigationController)
        navTopView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height:headerHeight))
        navTopView.backgroundColor = .white
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight))
        let navItem = UINavigationItem()
        navBar.backgroundColor = .clear
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.isTranslucent = false
        
        // 设置输入框
        let inputBox = UIView()
        inputBox.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenW * 0.65)
            make.height.equalTo(30)
        }
        
        let input = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.65, height: 30))
        input.backgroundColor = kBGGrayColor
        input.layer.cornerRadius = 15
        inputBox.addSubview(input)
        input.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenW * 0.65)
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(-20)
        }
        
        input.addSubview(inputControl)
        inputControl.text = searchStr!
        inputControl.placeholder = "粘贴宝贝标题，先领券再购买"
        inputControl.clearButtonMode = .whileEditing
        inputControl.keyboardType = .webSearch
        inputControl.delegate = self
        inputControl.becomeFirstResponder()
        inputControl.returnKeyType = UIReturnKeyType.done
        inputControl.resignFirstResponder()
        inputControl.font = FontSize(14)
        inputControl.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenW * 0.65 - 15)
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(12)
        }
            
        input.addSubview(inputControl)
//        inputBox.yoga.applyLayout(preservingOrigin: true)
        navItem.titleView = inputBox
        // 设置右侧搜索按钮
        let rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.15, height: 30))
        rightBtn.addTarget(self, action: #selector(toSearch), for: .touchUpInside)
        rightBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        rightBtn.setTitle("搜索", for: .normal)
        rightBtn.setTitleColor(.white, for: .normal)
        rightBtn.titleLabel?.font = FontSize(14)
        rightBtn.layer.cornerRadius = 15
        rightBtn.layer.masksToBounds = true
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        navTopView.addSubview(navBar)
        self.view.addSubview(navTopView)
        let backBtn = UIBarButtonItem(image: UIImage(named: "arrow-back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: #selector(backAction(sender:)))
        navItem.titleView = inputBox
        navItem.setRightBarButton(UIBarButtonItem(customView: rightBtn), animated: true)
        navItem.setLeftBarButton(backBtn, animated: true)
        navBar.pushItem(navItem, animated: true)
    }
    
    // 下拉刷新
    func refresh () {
        isFinish = false
        isLoading = false
        if isTKL {
            body.clearAll3()
        } else {
            body.clearAll()
        }
        pageNo = 0
        allHeight = 0
        if platform == 0 {
            getData(refresh: true)
        } else {
            print("拼多多下拉刷新")
            pddSearch(refresh: true)
        }
        setLoading()
    }
    
    // 淘口令解析
    func getTitleByTkl () {
        AlamofireUtil.post(url : "/taobao/public/getTitleByTklEnhance", param: [
            "tkl" : searchStr!
        ],
        closeError: true,
        success: {(res, data) in
            self.isTKL = true
            searchStr = data["content"].string!
            self.inputControl.text = data["content"].string!
            let itemId = data["num_iid"].string!
            self.getOneInfo(itemId)
        },
        error: {
            self.getData(refresh: true)
        },
        failure:{
            self.getData(refresh: true)
        })
    }
    
    // 获取单个宝贝信息
    func getOneInfo (_ id : String) {
        AlamofireUtil.post(url:"/product/public/detail", param: ["itemid" : id],
        success:{(res,data) in
            let oneInfo = goodsItem.deserialize(from: data["data"].description)!
            let oneGoods = GoodsItemView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 130), data: oneInfo, nav: self.navigationController!)
            self.allHeight += 130
            self.body.addSubview(oneGoods)
            self.getData(refresh: false)
        },
        error:{
            
        },
        failure:{
            
        })
    }
    
    // 淘宝请求数据
    func getData (refresh: Bool) {
        if isFinish || isError || platform != 0 || isLoading {
            return
        }
        isLoading = true
        pageNo += 1
        self.loadingView.frame = CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 50)
        if !refresh {
            self.loadingView.isHidden = false
        }
        var sortStr = ""
        if sort == 1 {
            sortStr = "price_asc"
        } else if sort == 2 {
            sortStr = "price_des"
        } else if sort == 7 {
            sortStr = "total_sales_asc"
        } else if sort == 4 {
            sortStr = "total_sales_des"
        } else if sort == 8 {
            sortStr = "tk_rate_asc"
        } else if sort == 5 {
            sortStr = "tk_rate_des"
        }
        AlamofireUtil.post(url:"/taobao/public/optional", param: [
            "q" : searchStr!,
            "page_size" : "10",
            "page_no" : pageNo,
            "sort" : sortStr,
            "npx_level" : "2"
        ],
        closeError: true,
        success:{(res,data) in
            print("是否已取消",self.isCancel)
            if self.isCancel {
                return
            }
            if let error = data["error_response"].dictionary {
                return
            }
            for item in data.array! {
                let searchItem = SearchItem.deserialize(from: item.description)!
                let collectionItem = CollectionItem.init(searchItem)
                let goodsInfo = goodsItem.init(collectionItem)
                if let id = goodsInfo.itemid {
                    let goodsItem = GoodsItemView(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 100), data: goodsInfo, nav: self.navigationController!)
                    self.body.addSubview(goodsItem)
                    self.allHeight += 130
                }
            }
            // 没有更多了
            if data.array!.count < 10 {
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
                self.setLoading()
            }
        },
        error:{
            self.isLoading = false
            self.getData(refresh: false)
//            self.isError = true
//            self.loadingView.isHidden = true
//            self.tryAgain()
        },
        failure:{
            self.isLoading = false
            self.getData(refresh: false)
//            self.isError = true
//            self.loadingView.isHidden = true
//            self.tryAgain()
        })
    }
    // 设置loading
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
    // 设置出错按钮
    func tryAgain () {
        let againBtn = UIButton(frame: CGRect(x: 0, y: allHeight, width: Int(kScreenW), height: 50))
        againBtn.backgroundColor = .clear
        againBtn.titleLabel?.font = FontSize(14)
        againBtn.setTitle("出错了，请点击重试", for: .normal)
        againBtn.addTarget(self, action: #selector(againFunc), for: .touchUpInside)
        againBtn.setTitleColor(kLowGrayColor, for: .normal)
        body.addSubview(againBtn)
    }
    // 再试一次
    @objc func againFunc (_ btn : UIButton) {
        if pageNo > 0 {
            pageNo -= 1
        }
        getData(refresh: false)
    }
    // 搜索按钮点击事件
    @objc func toSearch (_ btn : UIButton) {
        isError = false
        isHistory()
        if inputControl.text != "" {
            searchStr = inputControl.text
            refresh()
//            getTitleByTkl()
        } else {
            IDToast.id_show(msg: "请输入要搜索的内容", success: .fail)
        }
    }
    
    // 拼多多搜索
    func pddSearch (refresh: Bool) {
        if isFinish || isError || isLoading || platform != 1 {
            return
        }
        isLoading = true
        pageNo += 1
        var keyword = searchStr!
        if searchStr!.count > 50 {
            keyword = String(searchStr!.prefix(50))
        }
        var sortStr = 0
        if sort == 1 {
            sortStr = 3
        } else if sort == 2 {
            sortStr = 4
        } else if sort == 7 {
            sortStr = 5
        } else if sort == 4 {
            sortStr = 6
        } else if sort == 8 {
            sortStr = 1
        } else if sort == 5 {
            sortStr = 2
        }
        AlamofireUtil.post(url:"/ddk/public/goodsSearch",
        param: [
            "pageNo" : self.pageNo,
            "pageSize" : 10,
            "keyWord" : keyword,
            "sortType" : sortStr
        ],
        success:{(res,data) in
            let goodsList = pddGoodsItemList.deserialize(from: data.description)!.list
            for item in goodsList! {
                let oneGoods = PddGoodsCard(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 130), data: item, nav: self.navigationController!)
                self.allHeight += 130
                self.body.addSubview(oneGoods)
            }
            // 没有更多了
            if goodsList!.count < 10 {
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
                self.setLoading()
            }
        },
        error:{
            self.isLoading = false
        },
        failure:{
            self.isLoading = false
        })
        
    }
    // 键盘搜索点击事件
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if (inputControl.text?.count)! == 0 {
        IDToast.id_show(msg: "请输入要搜索的内容",success:.fail)
        return false

        }
        isError = false
        isHistory()
        if inputControl.text != "" {
            searchStr = inputControl.text
            refresh()
        } else {
            IDToast.id_show(msg: "请输入要搜索的内容", success: .fail)
        }
        self.inputControl.resignFirstResponder()
        return true
    }
    
    
}
