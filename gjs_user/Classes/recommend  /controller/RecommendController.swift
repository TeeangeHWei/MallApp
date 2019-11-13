//
//  RecommendController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/7.
//  Copyright © 2019 大杉网络. All rights reserved.
//



@available(iOS 11.0, *)
class RecommendController: UIViewController, UIScrollViewDelegate {
    
    var isCancel = false
    var minId = 1
    var allHeight = 0
    var isLoading = false
    let loadingView = UIActivityIndicatorView(style: .white)
    
    let body = UIScrollView()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 打印当前滚动条实时位置
        let height = allHeight - Int(kScreenH) + Int(headerHeight) + Int(kTabBarHeight) + 40
        if Int(scrollView.contentOffset.y) >= height && !isLoading {
            getData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isCancel = false
    }
    
    func setNav () {
        self.navigationController?.navigationBar.isHidden = true
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
        title.textColor = kMainTextColor
        navItem.titleView = title
        navBar.pushItem(navItem, animated: true)
        coustomNavView.addSubview(navBar)
        self.view.addSubview(coustomNavView)
    }
    
    override func viewDidLoad() {
        setNav()
        body.frame = CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - headerHeight)
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - headerHeight - kTabBarHeight)
        }
        setLoading()
        self.view.addSubview(body)
        body.delegate = self
        
        getData()
        
        body.yoga.applyLayout(preservingOrigin: true)
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight), right: CGFloat(0))
    }

    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }
    
    func getData () {
        if isLoading {
            return
        }
        isLoading = true
        self.loadingView.isHidden = false
        AlamofireUtil.post(url:"/product/public/friend", param: ["min_id":minId],
        success:{(res,data) in
            if self.isCancel {
                return
            }
            if self.minId != data["min_id"].int! {
                self.minId = data["min_id"].int!
            }
            // 朋友圈文案列表
            let recommendList = RecommendList.deserialize(from: data.description)!.data!
            for item in recommendList {
                let recommendItem = RecommendItemView(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 500), data: item, navC: self.navigationController!)
                self.body.addSubview(recommendItem)
                self.allHeight += recommendItem.articleHeight
            }
            self.body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(self.allHeight), right: CGFloat(0))
            self.isLoading = false
        },
        error:{
            
        },
        failure:{
                            
        })
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
        body.addSubview(loadingView)
    }
    
}
