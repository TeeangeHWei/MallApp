//
//  goodsListView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/14.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class GoodsListView: UIViewController {
    
    lazy var goodsList = { () -> UIScrollView in
        let goodsList = UIScrollView()
        goodsList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH)
            layout.paddingTop = 40
        }
        
//        let goodsItem = GoodsItemView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 100))
//        goodsList.addSubview(goodsItem)
        
        goodsList.yoga.applyLayout(preservingOrigin: true)
        goodsList.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(kScreenH - 30), right: CGFloat(0))
        
        return goodsList
    }
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
