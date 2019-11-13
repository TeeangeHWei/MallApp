//
//  BrandGoodsListController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/20.
//  Copyright © 2019 大杉网络. All rights reserved.
//


@available(iOS 11.0, *)
class BrandGoodsListController: ViewController {
    
    var isCancel = false
    var titleStr : String = ""
    var allHeight = 0
    let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - headerHeight))
    
    override func viewDidLoad() {
        let NavView = customNav(titleStr: titleStr, titleColor: kMainTextColor, border: true)
        self.view.addSubview(NavView)
        getBrandList()
        view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
        view.backgroundColor = kBGGrayColor
        view.addSubview(body)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isCancel = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }
    
    // 获取品牌宝贝列表
    func getBrandList () {
        AlamofireUtil.post(url: "/product/public/singleBrand", param: [
            "id" : brandId
        ],
        success:{(res, data) in
            if self.isCancel {
                return
            }
            let oneBrand = oneBrandModel.deserialize(from: data["data"].description)!
            self.titleStr = oneBrand.fq_brand_name!
            let NavView = self.customNav(titleStr: self.titleStr, titleColor: kMainTextColor, border: true)
            self.view.addSubview(NavView)
            for item in oneBrand.items! {
                let goodsItemView = GoodsItemView(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW - 20), height: 130), data: item, nav: self.navigationController!)
                self.body.addSubview(goodsItemView)
                self.allHeight += 130
            }
            self.body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(self.allHeight + 60), right: CGFloat(0))
        },
        error:{
            
        },
        failure:{
            
        })
    }

}
