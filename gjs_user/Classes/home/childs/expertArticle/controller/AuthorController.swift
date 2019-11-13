//
//  AuthorController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/30.
//  Copyright © 2019 大杉网络. All rights reserved.
//

class AuthorController: ViewController {
    
//    let articleItem = ArticleItem(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 120))
    
    override func viewDidLoad() {
        // 文章列表
        let articleList = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - headerHeight))
        articleList.configureLayout { (layout) in
            layout.isEnabled = true
        }
        self.view.addSubview(articleList)
//        articleList.addSubview(articleItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav(titleStr: "作者", titleColor: kMainTextColor, navItem: navigationItem, navController: navigationController)
    }

}
