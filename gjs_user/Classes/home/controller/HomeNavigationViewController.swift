//
//  HomeNavgationViewController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/10.
//  Copyright © 2019 大杉网络. All rights reserved.
//


class HomeNavigationViewController : UINavigationController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
        setupTitleViewSectionStyle()
    }
    

    
    //push的时候判断到子控制器的数量。当大于零时隐藏BottomBar 也就是UITabBarController 的tababar
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        self.interactivePopGestureRecognizer?.isEnabled = true
        super.pushViewController(viewController, animated: animated)
    }
    
    //    重新设置标题颜色和样式
    func setupTitleViewSectionStyle() {
        let titleV = UINavigationBar.appearance()
        let textAttrs = NSMutableDictionary()
        textAttrs[NSAttributedString.Key.foregroundColor] = UIColor.black
        textAttrs[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 18)
        titleV.titleTextAttributes = (textAttrs as? [NSAttributedString.Key : Any])
    }
    
    func setupTitleViewMainStyle() {
        let titleV = UINavigationBar.appearance()
        let textAttrs = NSMutableDictionary()
        textAttrs[NSAttributedString.Key.foregroundColor] = UIColor.white
        textAttrs[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 18)
        titleV.titleTextAttributes = (textAttrs as? [NSAttributedString.Key : Any])
    }

}
