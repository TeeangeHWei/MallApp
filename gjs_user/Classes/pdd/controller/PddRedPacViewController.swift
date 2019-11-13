//
//  PddRedPacViewController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/14.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit
                /*---------------------------拼多多红包推广页面------------------------------*/
class PddRedPacViewController: ViewController {
    var pacData = [["img":"pac_11","topname":"天天拆红包","subName":"红包专场会场,巨额福利优惠"],
                   ["img":"pac_12","topname":"今日爆款","subName":"今日爆款推荐"],
                   ["img":"pac_13","topname":"品牌清仓","subName":"旗舰店好货百万优惠券"],
                   ["img":"pac_14","topname":"1.9包邮","subName":"全网最低价，极品肉单"],
                   ["img":"pac_15","topname":"限时秒杀","subName":"超低价好货疯抢"]]
    let cell_identifier:String = "PddRedPacTableViewCell"
    var pacTableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = colorwithRGBA(241, 241, 241, 1)
        let navView = customNav(titleStr: "拼多多红包推广", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        
        createUI()
        
    }

   
}
extension PddRedPacViewController : UITableViewDelegate,UITableViewDataSource{
    func createUI(){
        let headerlabel = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenH, height: 30))
        view.addSubview(headerlabel)
        headerlabel.textColor = .red
        headerlabel.font = UIFont.systemFont(ofSize: 13)
        headerlabel.textAlignment = .center
               
        headerlabel.text = "推广以下任一频道,用户进入享受福利后您可获得佣金！"
        
        self.pacTableView = UITableView.init(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - 50), style:.grouped)
        self.pacTableView.tableFooterView = UIView.init()
        self.pacTableView.delegate = self
        self.pacTableView.dataSource = self
        self.pacTableView.tableHeaderView = headerlabel
        self.pacTableView.separatorStyle = .none
        self.view.addSubview(self.pacTableView)
        self.pacTableView.register(PddRedPacTableViewCell.classForCoder(), forCellReuseIdentifier: cell_identifier)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pacData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PddRedPacTableViewCell = tableView.dequeueReusableCell(withIdentifier: cell_identifier, for: indexPath) as! PddRedPacTableViewCell
        let item = pacData[indexPath.row]
        cell.navi = navigationController
        cell.rightbtn?.tag = indexPath.row
        cell.rightbtn?.addTarget(self, action: #selector(Spread), for: .touchUpInside)
        
        cell.leftImageView?.image = UIImage(named: item["img"]!)
        cell.topnameLabel?.text = item["topname"]
        cell.subNameLabel?.text = item["subName"]
        return cell
    }
    @objc func Spread(_ btn:UIButton){
        let vc = PddSpreadViewController()
        let index = btn.tag
        if index == 0 {
            vc.pageTitle = "天天拆红包"
            vc.shareImg.image = UIImage(named: "new_share_22")
            navigationController!.pushViewController(vc, animated: true)
        }else if index == 1{
            vc.pageTitle = "今日爆款"
            vc.shareImg.image = UIImage(named: "new_share_23")
            navigationController!.pushViewController(vc, animated: true)
        }else if index == 2{
            vc.pageTitle = "品牌清仓"
            vc.shareImg.image = UIImage(named: "new_share_24")
            navigationController!.pushViewController(vc, animated: true)
        }else if index == 3{
            vc.pageTitle = "1.9包邮"
            vc.shareImg.image = UIImage(named: "new_share_25")
            navigationController!.pushViewController(vc, animated: true)
        }else if index == 4{
            vc.pageTitle = "限时秒杀"
            vc.shareImg.image = UIImage(named: "new_share_26")
            navigationController!.pushViewController(vc, animated: true)
        }
   
    }
    
}
