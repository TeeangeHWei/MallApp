//
//  HomeTarBarController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/10.
//  Copyright © 2019 大杉网络. All rights reserved.
//


@available(iOS 11.0, *)
class HomeTarBarController: UITabBarController,UITabBarControllerDelegate {
    
    var mcTabBar = HomeTarBar(frame: CGRect.zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        mcTabBar.centerBtn.addTarget(self, action: #selector(centerBtnAction), for: .touchUpInside)
        self.setValue(mcTabBar, forKeyPath: "tabBar")
        self.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        mcTabBar.centerBtn.isSelected = (tabBarController.selectedIndex == (viewControllers?.count)!/2)
    }
    // 中间按钮点击
    @objc func centerBtnAction() {
        let count = viewControllers?.count ?? 0
        self.selectedIndex = count/2 // 关联中间按钮
        self.tabBarController(self, didSelect: viewControllers![selectedIndex])
        self.navigationController?.pushViewController(MemberViewController(), animated: true)
    }
}
