//
//  ShopGoodsController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/9.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class ShopGoodsController: ViewController {
   
    var isCancel = false
    var allHeight = 0
    var body = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH))
    var shopId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        view.backgroundColor = kBGGrayColor
        view.addSubview(body)
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isCancel = false
    }
    func setNav(){
        let NavView = customNav(titleStr: "店铺优惠", titleColor: kMainTextColor, border: false)
        view.addSubview(NavView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }

    func getData () {
        print(shopId)
        AlamofireUtil.post(url:"/product/public/keywordSearch", param: [
            "keyword" : "1",
            "shopid" : self.shopId,
            "back" : "20",
            "min_id" : "1"
        ],
        success:{(res,data) in
            if self.isCancel {
                return
            }
            let goodsList = goodsItemDataList.deserialize(from: data.description)!.data!
            for item in goodsList {
                let goodsItem = GoodsItemView(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 100),data: item, nav: self.navigationController!)
                self.body.addSubview(goodsItem)
                self.allHeight += 130
            }
            self.body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(self.allHeight + 80), right: CGFloat(0))
        },
        error:{
           
        },
        failure:{
                            
        })
    }
    
}
