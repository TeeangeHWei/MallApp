//
//  shakeBondVideoController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/11/12.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class shakeBondVideoController: ViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var viewControllers : Array<UIViewController> = []
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index : Int = self.viewControllers.index(of: viewController) ?? NSNotFound
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        
        return self.viewControllers[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index : Int = self.viewControllers.index(of: viewController) ?? NSNotFound
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index += 1
        if index >= self.viewControllers.count {
            return nil
        }
        
        return self.viewControllers[index]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建搜索页，视频列表页和用户详情页
//        let searchVC : SearchViewController = SearchViewController()
        let videosVC : VideosViewController = VideosViewController()
//        let userInfoVC : UserInfoViewController = UserInfoViewController()
        self.viewControllers = [videosVC]
        
        // 创建UIPageViewController
        let pageVC : UIPageViewController = UIPageViewController.init(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
        pageVC.setViewControllers([videosVC], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        pageVC.dataSource = self
        pageVC.delegate = self
        
        // 将pageVC添加到当前VC
        self.addChild(pageVC)
        self.view.addSubview(pageVC.view)
        pageVC.view.frame = self.view.bounds
        pageVC.didMove(toParent: self)
    }



}
