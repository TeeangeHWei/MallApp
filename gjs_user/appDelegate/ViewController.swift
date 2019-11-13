//
//  ViewController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/8.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
//        AlamofireUtil.cancelAll()
        //取消所有请求
//        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler {
//            (sessionDataTask, uploadData, downloadData) in
//            sessionDataTask.forEach { $0.cancel() }
//            uploadData.forEach { $0.cancel() }
//            downloadData.forEach { $0.cancel() }
//        }
    }
    func customNav(titleStr: String,titleColor: UIColor,border: Bool = true) -> UIView{
        let coustomNavView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height:headerHeight))
        coustomNavView.backgroundColor = .white
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight))
        let navItem = UINavigationItem()
        let backBtn = UIBarButtonItem(image: UIImage(named: "arrow-back"), style: .plain, target: nil, action: #selector(backAction(sender:)))
        navItem.setLeftBarButton(backBtn, animated: true)
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        navBar.tintColor = titleColor
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        if !border {
            navBar.shadowImage = UIImage()
        }
        navBar.isTranslucent = true
        title.text = titleStr
        title.textAlignment = .center
        title.textColor = titleColor
        navItem.titleView = title
        navBar.pushItem(navItem, animated: true)
        coustomNavView.addSubview(navBar)
        return coustomNavView
       
    }
    @objc func backAction(sender:UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
    }

}

