//
//  pagingTableHeaderView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/11.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit
@available(iOS 11.0, *)
class pagingTableHeaderView: UIView,UICollectionViewDelegate,UICollectionViewDataSource{
    var collectionView : UICollectionView?
    var PagingnaviController : UINavigationController?
    let cycleView = ZCycleView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenW * 240/640))
    let images = ["pdd-1","pdd-3","pdd-5","pdd-4"]
    let chageImages = ["pdd-1","pdd-5"]
    override init(frame: CGRect) {
        let kcycleViewHeight :CGFloat = 156
        
        super.init(frame: frame)
//        if UserDefaults.getIsShow() == 1{
//           cycleView.setImagesGroup([#imageLiteral(resourceName: "pdd-banner")])
//        }else{
//           cycleView.setUrlsGroup(["https://www.ganjinsheng.com/files/user/slide/20191115092309.png"])
//        }
        
        //        cycleView.pageControlItemSize = CGSize(width: 16, height: 4)
        //        cycleView.pageControlItemRadius = 0
        cycleView.pageControlIndictirColor = colorwithRGBA(241, 241, 241, 0.5)
        cycleView.pageControlCurrentIndictirColor = .yellow
        cycleView.pageControlAlignment = .right
        cycleView.didSelectedItem = {
            print("\($0)")
        }
        self.addSubview(cycleView)
        
       collectionView?.isUserInteractionEnabled = false
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.itemSize = CGSize(width: (kScreenW * 1.48 - 10)/3, height: 85)
        layout.sectionInset = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        if UserDefaults.getIsShow() == 1{
            collectionView = UICollectionView.init(frame:CGRect(x: 0, y: kScreenW * 0.38, width: kScreenW, height: kcycleViewHeight + 30), collectionViewLayout: layout)
        }else{
            collectionView = UICollectionView.init(frame:CGRect(x: 0, y: kScreenW * 0.38, width: kScreenW, height: (kcycleViewHeight + 30)/2), collectionViewLayout: layout)
        }
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        collectionView?.isScrollEnabled = false
        self.addSubview(collectionView!)


        // collView 视图 距离上下左右边距
//        collectionView?.contentInset = UIEdgeInsets.init(top: 2, left: 15, bottom: 2, right: 15)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collID")
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.dataArr.count
        if UserDefaults.getIsShow() == 1{
            return self.images.count
        }else{
            return self.chageImages.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collID", for: indexPath)
        if indexPath.section == 0{
//            let model = self.dataArr[indexPath.row]
            let img : UIImageView!
            if cell.contentView.subviews.count > 0{
                img = cell.contentView.subviews[0] as? UIImageView
            }else{
                
                img = UIImageView.init()
                cell.contentView.addSubview(img)
                
                img.layer.cornerRadius = 5
                img.layer.masksToBounds = true
                img.backgroundColor = .red
                if UserDefaults.getIsShow() == 1{
                    img.image = UIImage(named: images[indexPath.item])
                }else{
                    img.image = UIImage(named: chageImages[indexPath.item])
                }
                
                img.snp.makeConstraints { (make) in
//                    make.top.equalToSuperview()
//                    make.left.equalToSuperview()
//                    make.right.equalToSuperview()
                    make.width.equalTo((kScreenW * 1.48 - 10)/3)
                    make.height.equalTo(85)
                    
                }
            }
            
            
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = outRankViewController()
        if UserDefaults.getIsShow() == 1{
            if indexPath.row == 0{
                PagingnaviController?.pushViewController(vc, animated: true)
            }
            if indexPath.row == 1 {
                PagingnaviController?.pushViewController(PddRedPacViewController(), animated: true)
            }
            if indexPath.row == 3 {
                jumpToH5Shop()
            }
            if indexPath.row == 2 {
                PagingnaviController?.pushViewController(GoodShotViewController(), animated: true)
            }
        }else{
            if indexPath.row == 0{
               PagingnaviController?.pushViewController(vc, animated: true)
           }
            if indexPath.row == 1 {
               PagingnaviController?.pushViewController(GoodShotViewController(), animated: true)
           }
            
        }
        
    }
    
    func jumpToH5Shop () {
        IDLoading.id_showWithWait()
        AlamofireUtil.post(url:"/ddk/createH5Shopping", param: [
            "generateShortUrl" : true,
            "weAppWebViewShortUrl" : false,
            "weAppWebViewUrl" : false
        ],
        success:{(res,data) in
            IDLoading.id_dismissWait()
            let url = data["urlList"][0]["shortUrl"].string!
            let vc = PddH5ShopController()
            vc.webAddress = url
            self.PagingnaviController?.pushViewController(vc, animated: true)
        },
        error:{
            IDLoading.id_dismissWait()
        },
        failure:{
            IDLoading.id_dismissWait()
        })
    }
    
    
}
