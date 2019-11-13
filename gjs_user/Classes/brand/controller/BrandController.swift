//
//  brandController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/19.
//  Copyright © 2019 大杉网络. All rights reserved.
//


@available(iOS 11.0, *)
class BrandController: ViewController {

    var isCancel = false
    var allHeight = 230
    let body = UIScrollView(frame: CGRect(x: 0, y:headerHeight, width: kScreenW, height: kScreenH))
    
    override func viewDidLoad() {
        getBrandList()
        view.backgroundColor = colorwithRGBA(255, 148, 20, 1)
        view.addSubview(body)
        
        // 标题
        let title = UIView(frame: CGRect(x: 0, y: 175, width: kScreenW, height: 40))
        title.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .center
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = 40
            layout.marginTop = 15
        }
        let leftIcon = UIImageView(image: UIImage(named: "brand-title"))
        leftIcon.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 20
            layout.height = 20
        }
        title.addSubview(leftIcon)
        let titleLabel = UILabel()
        titleLabel.text = "品牌推荐"
        titleLabel.font = FontSize(14)
        titleLabel.textColor = .white
        titleLabel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginLeft = 5
            layout.marginRight = 5
        }
        title.addSubview(titleLabel)
        let rightIcon = UIImageView(image: UIImage(named: "brand-title"))
        rightIcon.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 20
            layout.height = 20
        }
        title.addSubview(rightIcon)
        title.yoga.applyLayout(preservingOrigin: true)
        
        body.addSubview(title)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isCancel = false
        setNavc()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }

    func setNavc () {
//        setNav(titleStr: "品牌特卖", titleColor: .white, navItem: navigationItem, navController: navigationController)
//        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
//        navigationController?.navigationBar.apply(gradient: [colorwithRGBA(255, 148, 20, 1), colorwithRGBA(255, 148, 20, 1)])
//        navigationController?.isToolbarHidden = true
//        navigationController?.navigationBar.tintColor = .white
        let navView = customNav(titleStr: "品牌特卖", titleColor: .white, border: false)
        navView.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), [colorwithRGBA(255, 148, 20, 1), colorwithRGBA(255, 148, 20, 1)])
        self.view.addSubview(navView)
    }
    
    // 修改系统状态栏字颜色为白色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // 获取品牌列表
    func getBrandList () {
        let oneHeight = Int((kScreenW - 60) * 0.25 * 0.52 + 72 + (kScreenW - 70)/3)
        AlamofireUtil.post(url: "/product/public/brand", param: [
            "back" : "20",
            "min_id" : "1"
        ],
        success:{(res, data) in
            if self.isCancel {
                return
            }
            let brandListData = brandList.deserialize(from: data.description)!.data!
            let brandBanner = BrandBannerView(frame: CGRect(x: 0, y: 0, width: kScreenW - 30, height: 200), data: brandListData, nav: self.navigationController!)
            self.body.addSubview(brandBanner)
            for item in brandListData {
                let brandItem = BrandItem(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW - 30), height: oneHeight), data: item, nav: self.navigationController!)
                self.body.addSubview(brandItem)
                self.allHeight += oneHeight + 15
            }
            self.body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(self.allHeight + 60), right: CGFloat(0))
        },
        error:{
            
        },
        failure:{
            
        })
    }
    
}
