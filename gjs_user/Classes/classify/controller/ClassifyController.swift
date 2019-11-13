//
//  ClassifyController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/4.
//  Copyright © 2019 大杉网络. All rights reserved.
//


@available(iOS 11.0, *)
@available(iOS 11.0, *)
class ClassifyController: ViewController {
    var navTopView : UIView!
    var isCancel = false
    var leftClassify : LeftClassify?
    var rightClassify : RightClassify?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        getData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.apply(gradient: [.white, .white])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }
    
    func setNavigation() {
        // 隐藏系统nav
        self.navigationController?.isNavigationBarHidden = true
        navTopView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height:headerHeight))
        let searchView = UIButton()
        // 自定义bar
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight))
        let navItem = UINavigationItem()
        navBar.backgroundColor = .clear
        navBar.isTranslucent = false
        let rightbtn = UIBarButtonItem(image: UIImage(named: "5-3"), style: .plain, target: self, action: #selector(toNews))
        navItem.rightBarButtonItem?.tintColor = .white
        navItem.setRightBarButton(rightbtn, animated: true)
        navBar.pushItem(navItem, animated: true)
        // 搜索框
        navBar.tintColor = .black
        searchView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 30)
            layout.height = 33
            layout.marginLeft = YGValue(-30)
        }
        searchView.addTarget(self, action: #selector(toSearch), for: .touchUpInside)
        searchView.layer.cornerRadius = 15
        searchView.layer.masksToBounds = true
        searchView.backgroundColor = kSearchBGColor
        searchView.setTitle("请输入搜索关键字", for: .normal)
        searchView.setTitleColor(kGrayTextColor, for: .normal)
        searchView.titleLabel?.font = FontSize(14)
        searchView.titleLabel?.frame = CGRect(x: 0, y: 0, width: searchView.bounds.size.width, height: searchView.bounds.size.height)
        searchView.titleLabel?.textAlignment = .left
        navItem.titleView = searchView
        searchView.yoga.applyLayout(preservingOrigin: true)
        
        navTopView.addSubview(navBar)
        self.view.addSubview(navTopView)
    }
    
    // 跳转消息页面
    @objc func toNews (_ btn: UIButton) {
        navigationController?.pushViewController(NewsView(), animated: true)
    }
    
    // 选中一个大类
    func changeOne (value: Int) {
        rightClassify?.changePage(index: value - 1)
//        rightClassify!.bringSubviewToFront(rightClassify!.pageList[value - 1])
    }
    
    // 获取数据
    func getData () {
        AlamofireUtil.post(url:"/product/public/classify", param: [:],
        success:{(res,data) in
            if self.isCancel {
                return
            }
            // 左侧大分类
            let leftList = leftListModel.deserialize(from: data.description)!.general_classify!
            self.leftClassify = LeftClassify(frame: CGRect(x: 0, y: headerHeight, width: kScreenW * 0.25, height: kScreenH - headerHeight),data: leftList)
            self.leftClassify!.UIPivkerInit(closuer:self.changeOne)
            self.view.addSubview(self.leftClassify!)
            
            let rightList = rightListModel.deserialize(from: data.description)!.general_classify!
            
            self.rightClassify = RightClassify(frame: CGRect(x: 0, y: headerHeight + 1, width: kScreenW * 0.75, height: kScreenH - headerHeight), data: rightList, Nav: self.navigationController)
            self.view.addSubview(self.rightClassify!)
            
            ADPhotoLoader.share.loadImage(url: "https://www.shailema.com/upload/img/user/0aafb709143d4db3bc950793638c8211.jpeg", complete: {[weak self](data: Data?, url: String) in
                if data != nil {
                    // 处理图片
                    
                }
            })
            
            // clickdata 大家都在看
//            articleList = ArticleList.deserialize(from: data["data"].description)!.clickdata!
        },
        error:{
            
        },
        failure:{
            
        })
    }
    
    // 前往搜索
    @objc func toSearch (_ btn: UIButton) {
        self.navigationController?.pushViewController(SearchPageController(), animated: true)
    }
    
}
@available(iOS 11.0, *)
extension ClassifyController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
