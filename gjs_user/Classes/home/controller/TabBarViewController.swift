//
//  TabBarViewController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/10.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class TabBarViewController: HomeTarBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.orange
        //透明设置为NO，显示白色，view的高度到tabbar顶部截止，YES的话到底部
        mcTabBar.insertSubview(CustomizeHomeTabBar.drawTabBarImageView(), at: 0)
        mcTabBar.isOpaque = true
        mcTabBar.isTranslucent = false
        mcTabBar.positon = .bulge
        mcTabBar.centerImage = UIImage(named: "9")!
        setUpAllViewController()
    }
    
    func setUpAllViewController() -> Void {
        ///添加控制器
        setChildController(HomeViewController(), "首页","1",selectImg: "5")
        setChildController(ClassifyController(), "分类","2",selectImg: "6")
        let nav = MemberViewController()
        nav.setOutHeight(val: 100)
        let Hhsnav = JhsController()
        print("UserDefaults::",UserDefaults.getIsShow())
        if UserDefaults.getIsShow() == 1{
            setChildController(nav, "","", selectImg: "")
        }else{
            setChildController(Hhsnav, "","", selectImg: "")
        }
        
        setChildController(NewRecommendController(), "发现","3",selectImg: "7")
        setChildController(MyController(), "我的", "4", selectImg: "8")
    }
    
    // 子控件属性
    private func setChildController(_ controller : UIViewController,_ title : String,_ norImage : String, selectImg : String){
        controller.tabBarItem.title = title
        // tabbar标题位置
        controller.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0,vertical: -3)
        //设置按钮图片
        controller.tabBarItem.image = UIImage(named: norImage)
        controller.tabBarItem.selectedImage = UIImage(named: selectImg)
        //设置navigation
        let nav = HomeNavigationViewController(rootViewController: controller)
        controller.title = title
        self.addChild(nav)
    }
    
    func TabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 2 {
            navigationController?.pushViewController(MemberViewController(), animated: true)
            tabBar.isHidden = true
            return
        }
    }
}
