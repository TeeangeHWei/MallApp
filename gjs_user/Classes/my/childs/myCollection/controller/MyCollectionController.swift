//
//  MyCollectionController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/26.
//  Copyright © 2019 大杉网络. All rights reserved.
//

@available(iOS 11.0, *)
class MyCollectionController: ViewController, platformDelegate {
    
    var isCancel = false
    var platform = 0 // 0 淘宝  1 拼多多
    private var allHeight = 0
    let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight + 47, width: kScreenW, height: kScreenH - headerHeight - 47))
    let goodsInfoList = UIView()
    let checkBoxList = UIView()
    var checkBoxArr = [checkBox]()
    var checkIndexList = [Int]()
    var idsList = [String]()
    var allData = [CollectionItem]()
    var pageNo : Int = 0
    var isLoading : Bool = false
    var isFinish : Bool = false
    let loadingView = UIActivityIndicatorView(style: .white)
    let nodata = UIView(frame: CGRect(x: 0, y: Int(headerHeight + kNavigationBarHeight), width: Int(kScreenW), height: 200))
    let noMore = UILabel(frame: CGRect(x: 0, y: 0, width: Int(kScreenW), height: 50))
    
    let rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
    let myCollectionFooter = MyCollectionFooter(frame: CGRect(x: 0, y: kScreenH - kTabBarHeight, width: kScreenW, height: kTabBarHeight))
    
    
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNav()
        view.backgroundColor = kBGGrayColor
        
        let platformBar = PlatformBar(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: 46))
        platformBar.delegate = self
        view.addSubview(platformBar)
        
        body.showsVerticalScrollIndicator = false
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - headerHeight - 47)
            layout.paddingTop = 1
            layout.position = .relative
        }
        view.addSubview(body)
        // 选择框列表
        checkBoxList.isUserInteractionEnabled = true
        checkBoxList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.15)
            layout.position = .absolute
            layout.top = 0
            layout.left = 0
        }
        body.addSubview(checkBoxList)
        // 商品信息
        goodsInfoList.configureLayout { (layout) in
            layout.isEnabled = true
        }
        body.addSubview(goodsInfoList)
        
        // 将回调函数传递到myCollectionFooter
        myCollectionFooter.UIPivkerInit(closuer:toCheckAll, closuer1: toRemoveCheck)
        
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight + 80), right: CGFloat(0))
        body.yoga.applyLayout(preservingOrigin: true)
        
        view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
        myCollectionFooter.isHidden = true
        view.addSubview(myCollectionFooter)
        // 没有更多了
        noMore.text = "没有更多了～"
        noMore.isHidden = true
        noMore.textAlignment = .center
        noMore.font = FontSize(14)
        noMore.textColor = kGrayTextColor
        body.addSubview(noMore)
        
        setLoading()
        setNodata()
        getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isCancel = false
    }
    
    // 设置nav
    func setNav () {
        let coustomNavView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height:headerHeight))
        coustomNavView.backgroundColor = .white
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight))
        let navItem = UINavigationItem()
        let backBtn = UIBarButtonItem(image: UIImage(named: "arrow-back"), style: .plain, target: nil, action: #selector(backAction(sender:)))
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        navBar.tintColor = kMainTextColor
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.isTranslucent = true
        navItem.setLeftBarButton(backBtn, animated: true)
        title.text = "我的收藏"
        title.textAlignment = .center
        title.textColor = kMainTextColor
        navItem.titleView = title
        navBar.pushItem(navItem, animated: true)
        coustomNavView.addSubview(navBar)
        rightBtn.tag = 1
        rightBtn.setTitleColor(kMainTextColor, for: .normal)
        rightBtn.setTitle("管理", for: .normal)
        rightBtn.titleLabel?.font = FontSize(14)
        rightBtn.addTarget(self, action: #selector(management), for: .touchUpInside)
        navItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        self.view.addSubview(coustomNavView)
    }
    
    // 平台切换
    func platformDelegatefuc(backMsg: Int) {
        platform = backMsg
        self.allData = [CollectionItem]()
        self.checkIndexList = [Int]()
        self.checkBoxList.clearAll2()
        self.goodsInfoList.clearAll2()
        self.checkBoxArr = [checkBox]()
        self.allHeight = 0
        self.pageNo = 0
        self.noMore.isHidden = true
        self.isFinish = false
        getData()
    }
    
    // 管理/完成
    @objc func management (btn: UIButton) {
        if btn.tag == 1 {
            rightBtn.tag = 2
            rightBtn.setTitle("完成", for: .normal)
            myCollectionFooter.isHidden = false
            UIView.animate(withDuration : 0.3) {
                self.goodsInfoList.frame.origin.x = kScreenW * 0.15 - 10
            }
        } else {
            rightBtn.tag = 1
            rightBtn.setTitle("管理", for: .normal)
            myCollectionFooter.isHidden = true
            UIView.animate(withDuration : 0.3) {
                self.goodsInfoList.frame.origin.x = 0
            }
        }
    }
    // 全选/反选
    func toCheckAll (value:Bool) {
        if value {
            for item in checkBoxArr {
                item.checkValue = true
            }
            self.checkIndexList = [Int]()
            for item in checkBoxArr {
                self.checkIndexList.append(item.tag)
            }
        } else {
            for item in checkBoxArr {
                item.checkValue = false
            }
            self.checkIndexList = [Int]()
        }
    }
    // 删除选中
    func toRemoveCheck () {
        IDLoading.id_showWithWait()
        idsList = [String]()
        print("checkIndexList:",checkIndexList)
        print("allData:",allData)
        for index in checkIndexList {
            
            idsList.append(allData[index].id!)
            print("删除选中list：：",index)
        }
        print("idslist::\(idsList.count)")
        if idsList.count == 0 {
            IDLoading.id_dismissWait()
            IDToast.id_show(msg: "您还没有选择", success: .fail)
            return
        }
        AlamofireUtil.post(url: "/user/myCollect/cancelMutilCollect", param: [
            "type" : self.platform + 1,
            "ids" : Commons.getJSONStringFromArray(array: idsList as NSArray)
        ],
        success: {(res, data) in
            if self.isCancel {
                return
            }
            self.checkIndexList = [Int]()
            self.idsList = [String]()
            self.allData = [CollectionItem]()
            self.checkBoxArr = [checkBox]()
            self.checkBoxList.clearAll2()
            self.goodsInfoList.clearAll2()
            self.allHeight = 0
            self.pageNo = 0
            self.noMore.isHidden = true
            self.isFinish = false
            self.getData()
            self.rightBtn.tag = 1
            self.rightBtn.setTitle("管理", for: .normal)
            self.myCollectionFooter.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.goodsInfoList.frame.origin.x = 0
            }
            self.myCollectionFooter.checkAll.checkValue = false
            
            IDToast.id_show(msg: "删除成功", success: .success)
            IDLoading.id_dismissWait()
        },
        error: {
            IDLoading.id_dismissWait()
        },
        failure:{
            IDLoading.id_dismissWait()
        })
    }
    // 获取数据
    func getData () {
        if isLoading || isFinish {
            return
        }
        isLoading = true
        loadingView.frame = CGRect(x: 0, y: allHeight, width: Int(kScreenW), height: 50)
        loadingView.isHidden = false
        pageNo += 1
        AlamofireUtil.post(url : "/user/myCollect/myCollectList", param: [
            "pageNo" : pageNo,
            "pageSize" : 10,
            "type" : self.platform + 1
        ],
        success: {(res, data) in
            // 转换数据模型
            let collectList = CollectionList.deserialize(from: data.description)!.list!
            // 保存数据
            self.allData += collectList
            // 没有数据
            if self.allData.count == 0 {
                self.isLoading = false
                self.loadingView.isHidden = true
                self.isFinish = true
                self.nodata.isHidden = false
                return
            } else {
                self.nodata.isHidden = true
            }
            // 渲染数据
            for (index, item) in collectList.enumerated() {
                self.checkBoxList.frame.size.height = CGFloat(self.allHeight + 130)
                let goodsItemData = goodsItem.init(item)
                let checkBoxItem = CheckBoxView(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW * 0.15), height: 120))
                checkBoxItem.checkBtn.tag = index
                checkBoxItem.checkBtn.addTarget(self, action: #selector(self.changeOne), for: .touchUpInside)
                self.checkBoxArr.append(checkBoxItem.checkBtn)
                self.checkBoxList.addSubview(checkBoxItem)
                if self.platform == 0 {
                    let goodsItem = GoodsItemView(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 120), data: goodsItemData,  nav: self.navigationController!)
                    self.goodsInfoList.addSubview(goodsItem)
                } else {
                    let goodsItem = GoodsItemView(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 120), data: goodsItemData,  nav: self.navigationController!, platformIndex: 1)
                    self.goodsInfoList.addSubview(goodsItem)
                }
                
                self.allHeight += 130
            }
            self.goodsInfoList.frame.size.height = CGFloat(self.allHeight)
            // 隐藏loading动画
            self.isLoading = false
            self.loadingView.isHidden = true
            // 没有更多了
            if collectList.count < 10 {
                self.isFinish = true
                self.noMore.frame.origin.y = CGFloat(self.allHeight)
                self.noMore.isHidden = false
                self.allHeight += 50
            }
            // 重设滚动高度
            self.body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(self.allHeight + 80), right: CGFloat(0))
        },
        error: {
            
        },
        failure:{
            
        })
    }
    // 选中一个
    @objc func changeOne (_ btn : UIButton) {
        let index = btn.tag
        var hasStatus = false
        for item in checkIndexList {
            if item == index {
                hasStatus = true
            }
        }
        if hasStatus {
            checkIndexList = checkIndexList.filter{$0 != index}
        } else {
            checkIndexList.append(index)
        }
    }
    // 设置loading动画
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
        body.addSubview(loadingView)
    }
    // 没有数据时显示
    func setNodata () {
        nodata.isHidden = true
        nodata.configureLayout { (layout) in
            layout.isEnabled = true
            layout.justifyContent = .center
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = 200
        }
        let nodataIcon = UIImageView(image: UIImage(named: "nodata"))
        nodataIcon.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.4)
            layout.height = YGValue(kScreenW * 0.4 * 0.7)
        }
        nodata.addSubview(nodataIcon)
        nodata.yoga.applyLayout(preservingOrigin: true)
        self.view.addSubview(nodata)
//        allHeight += 200
    }
}
