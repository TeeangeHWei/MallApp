//
//  GoodShotViewController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/18.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class GoodShotViewController: ViewController {
    var isCancel = false
    let cell_identifier:String = "goodshotTableViewCell"
    var goodsTableView = UITableView()
    var goodshotData = [themelist]()
    var shotimg = [String]()
    var shotTitle = [String]()
    weak var navi : UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        self.view.backgroundColor = .white
        shotdata()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isCancel = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }
    func setNav(){
        let navView = customNav(titleStr: "主题商品", titleColor: .black, border: false)
        view.addSubview(navView)
    }
//MARK:-- 网络请求
    func shotdata(){
        AlamofireUtil.post(url: "/ddk/public/ddkThemeList", param: ["pageNo":1,"pageSize":10], success: { (res, data) in
            if self.isCancel {
                return
            }
            self.goodshotData = shotthemelist.deserialize(from: data.description)!.themeList!
//            self.themedataSource = [self.goodshotData]
            for item in self.goodshotData{
                self.shotimg.append(item.imageUrl!)
                self.shotTitle.append(item.name!)
            }
            print("self.shotimg:::",self.shotimg)
            print("goodss:::",self.goodshotData)
            print("good:::",data)
            self.createUI()
            self.goodsTableView.reloadData()
        }, error: {
            
        }, failure: {
            
        })
    }
    
}

extension GoodShotViewController : UITableViewDelegate,UITableViewDataSource{
    func createUI(){
        self.goodsTableView = UITableView.init(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH), style:.plain)
        self.goodsTableView.tableFooterView = UIView.init()
        self.goodsTableView.delegate = self
        self.goodsTableView.dataSource = self
        
        self.goodsTableView.separatorStyle = .none
        self.goodsTableView.rowHeight =  240
        self.goodsTableView.estimatedRowHeight = 0
        self.goodsTableView.estimatedSectionFooterHeight = 0
        self.goodsTableView.estimatedSectionHeaderHeight = 0
        self.goodsTableView.allowsSelection = false
        self.goodsTableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.goodsTableView.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(60), right: CGFloat(0))
        self.view.addSubview(self.goodsTableView)
        self.goodsTableView.register(GoodShotTableViewCell.classForCoder(), forCellReuseIdentifier: cell_identifier)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shotTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell : GoodShotTableViewCell = tableView.dequeueReusableCell(withIdentifier: cell_identifier, for: indexPath) as! GoodShotTableViewCell
        cell.navi = navigationController
        let imgitem = shotimg[indexPath.row]
        let titleitem = shotTitle[indexPath.row]
        cell.titlelabel!.text = titleitem
        let urlimg = URL.init(string: imgitem)
        cell.themeimg?.kf.setBackgroundImage(with: urlimg, for: .normal)
        cell.themeimg?.isUserInteractionEnabled = true
        cell.themeimg?.tag = indexPath.row
        cell.themeimg?.addTarget(self, action: #selector(pushview), for: .touchUpInside)
        print("imgitem:::",imgitem)
        cell.backgroundColor = colorwithRGBA(241, 241, 241, 1)
        
        return cell
    }
    @objc func pushview(_ imgv:UIButton){
        let vc = GoodShotListViewController()
        //获取button 位置
        let imgtag = imgv.tag
        // 添加id
        vc.themeId = goodshotData[imgtag].id
        vc.shotlisttitle = shotTitle[imgtag]
        vc.refresh()
        navigationController?.pushViewController(vc, animated: true)
    }
}
