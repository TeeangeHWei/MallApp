//
//  shakeBondViewController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/11/11.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class shakeBondViewController: ViewController {
    var collectionView : UICollectionView!
    //表格底部用来提示数据加载的视图
    var loadMoreView:UIView?
   //用了记录当前是否允许加载新数据（正则加载的时候会将其设为false，放置重复加载）
   //计数器（用来做延时模拟网络加载效果）
    var timer: Timer!
    fileprivate var mind_id = 1
    var loadMoreEnable = true
    var istabHeaderRefreshed = false
    let loadingView = UIActivityIndicatorView(style: .white)
    fileprivate var shakeDataSource = [[shakeBondData]]()
    fileprivate var newShakeDataSource = [shakeBondData]()
    let refesh_footer = MJRefreshAutoFooter()
    override func viewDidLoad() {
        super.viewDidLoad()
        newShakeDataSource = Array.init()
        let navView = customNav(titleStr: "抖券", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        self.view.backgroundColor = colorwithRGBA(241, 241, 241, 0.8)
        
        let layout = HCFallsFlowLayout.init()
       
        //... 设置UIEdgeinset 行间距 列间距 可以自己定义
        //        layout.interitemSpacing
        //        layout.edgeInset
        //        layout.lineSpacing
        layout.basicSetting()
        //设置几列 默认是2列
        layout.columCount = 2
        
        layout.delegate = self
        
        self.collectionView = UICollectionView.init(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - 100), collectionViewLayout: layout)
        self.collectionView.backgroundColor = colorwithRGBA(241, 241, 241, 0.8)
        
        self.collectionView.register(homeShakeCell.self, forCellWithReuseIdentifier: "homeShakeCell")
        
        self.collectionView.delegate = self
        
        
        self.collectionView.dataSource = self
        
        self.view.addSubview(collectionView)
        shakeData()
        shakebondData()
        self.collectionView.gtm_addRefreshHeaderView {
            [weak self] in
            self?.shakeData()
            self?.istabHeaderRefreshed = true
            self?.collectionView.endRefreshing(isSuccess: true)
        }
        collectionView.pullDownToRefreshText("下拉刷新")
        .releaseToRefreshText("松开刷新")
        .refreshSuccessText("刷新成功")
        .refreshFailureText("刷新失败")
        .refreshingText("正在努力加载中...")
        self.collectionView.headerTextColor(.black)
        
    }
    func loadMore(){
        print("加载新数据！")
        loadMoreEnable = false
        self.shakeData()
        
    }
    //MARK: --  抖券请求
    @objc func shakeData(){
        AlamofireUtil.post(url: "/product/public/trill", param: ["cat_id":0,"back":10,"min_id":self.mind_id], success: { (res, data) in
            shakeBondlist = shakeBondDataList.deserialize(from: data.description)!.data!
            self.shakeDataSource = [shakeBondlist]
            self.newShakeDataSource += shakeBondlist
            self.loadMoreEnable = true
            self.mind_id = data["min_id"].int!
            self.collectionView.reloadData()
        }, error: {
            
        }, failure: {
            
        })
    }
    // 需要遍历此方法将shakeDataSource 附上值
    fileprivate func shakebondData(){
        var shakeArr = [shakeBondData]()
        let shakeimg = shakeBondlist
        
        for(_,_) in shakeimg.enumerated(){
            let shakeModel = shakeBondData.init()
            shakeArr.append(shakeModel)
        }
        self.shakeDataSource = [shakeArr]
        self.collectionView.reloadData()
    }

}
extension shakeBondViewController: WaterflowLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    
}
extension shakeBondViewController: UICollectionViewDelegate,UICollectionViewDataSource{
   
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        print("self.shakeDataSource",self.shakeDataSource.count)
        return self.newShakeDataSource.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeShakeCell", for: indexPath) as! homeShakeCell
        let model = newShakeDataSource[indexPath.row]
        let shakeImgUrl = URL.init(string: model.first_frame ?? "")
        let placeholderImage = UIImage(named: "loading")
        cell.shotImg!.kf.setImage(with: shakeImgUrl, placeholder: placeholderImage)
        cell.likeNum!.text = model.dy_video_like_count
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        cell.shotTitle!.text = model.itemtitle
        cell.shortCron!.text = "¥" + model.itemprice!
        cell.couponCron!.text = model.couponmoney! + "元券"
       var icon = UIImage.init(named: "taobao")
       if model.shoptype == "B" {
           icon = UIImage.init(named: "tianmao")
//            typeLabel.text = "天猫"
//            typeLabel.backgroundColor = colorwithRGBA(255, 1, 55, 1)
       } /*else {
           typeLabel.text = "淘宝"
           typeLabel.backgroundColor = colorwithRGBA(255, 80, 0, 1)
       }*/
        cell.platImg!.image = icon
        var memberStatus = 1
        let info = UserDefaults.getInfo()
        if info["id"] as! String != "" {
            memberStatus = Int(UserDefaults.getInfo()["memberStatus"] as! String)!
        }
        //// 判断会员赚
        if memberStatus == 1 {
            let commission = Commons.strToDou(model.tkmoney!) * Commons.vip1Scale()
            cell.member!.text = "会员赚¥\(String(format:"%.2f",commission))"
        } else {
            let commission = Commons.strToDou(model.tkmoney!) * Commons.vip2Scale()
            cell.member!.text = "团长赚¥\(String(format:"%.2f",commission))"
        }
        // 判断团长赚
        if memberStatus == 1 {
            let commission = Commons.strToDou(model.tkmoney!) * Commons.vip2Scale()
            cell.commander!.text = "团长赚¥\(String(format:"%.2f",commission))"
        } else {
            let commission = Commons.strToDou(model.tkmoney!) * Commons.vip3Scale()
            cell.commander!.text = "伙伴赚¥\(String(format:"%.2f",commission))"
        }
       if (loadMoreEnable && indexPath.row == self.newShakeDataSource.count-1){
           loadMore()
       }
       
////        yujiCron.text = "预计赚¥"+(model.tkmoney ?? "")
//       if memberStatus == 1 {
//           let commission = Commons.strToDou(model.tkmoney!) * Commons.vip1Scale()
//           yujiCron.text = "预计赚¥\(String(format:"%.2f",commission))"
//       }else {
//           let commission = Commons.strToDou(model.tkmoney!) * Commons.vip2Scale()
//           yujiCron.text = "团长赚¥\(String(format:"%.2f",commission))"
//       }
//        cell.label?.text = "\(indexPath.row)"
//        cell.label?.textAlignment = .center
//
//        cell.label?.frame = cell.bounds
        
        return cell
        
        
        
    }
    
    
    
    
}
