//
//  JdHeaderView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/11.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class JdHeaderView: UIView {
    let cycleView = ZCycleView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenW * 240/640))
    let iconarr = [["title":"超级大卖场","icon":"jd_superSpecial","id":"2"],
                   ["title":"数码家电","icon":"jd_jiadian","id":"24"],
                   ["title":"母婴玩具","icon":"jd_baby","id":"26"],
                   ["title":"美妆穿搭","icon":"jd_ Beauty","id":"28"],
                   ["title":"图书文具","icon":"jd_wanju","id":"30"],
                   ["title":"9.9专区","icon":"jd_9.9","id":"10"],
                   ["title":"超市","icon":"jd_market","id":"25"],
                   ["title":"家具日用","icon":"jd_ family","id":"28"],
                   /*["title":"今日必推","icon":"jd_today"],*/
                   ["title":"医药保健","icon":"jd_yaopin","id":"29"],
                   /*["title":"热销爆款","icon":"jd_baokuan"],*/
                   ["title":"王牌好货","icon":"jd_haohuo","id":"32"]]
    var collectionView : UICollectionView?
 override init(frame: CGRect) {
    super.init(frame: frame)
        let kcycleViewHeight :CGFloat = 156
        
         
        cycleView.pageControlIndictirColor = colorwithRGBA(241, 241, 241, 0.5)
        cycleView.pageControlCurrentIndictirColor = .yellow
        cycleView.pageControlAlignment = .right
        cycleView.didSelectedItem = {
            print("\($0)")
    }
        self.addSubview(cycleView)
        makeUI()
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
extension JdHeaderView{
    fileprivate func makeUI(){
        let itemH = 50
        let itemW = 50
        let kcycleViewHeight :CGFloat = 156
        let layout = jdUicollecionFlowLayout()
        layout.itemSize = CGSize(width: itemW, height: itemH)
        // item横向间距离
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        
//        layout.sectionInset = UIEdgeInsets.init(top: 1, left: 1, bottom: 1, right: 1)
        let collView = UICollectionView.init(frame:CGRect(x: 0, y: kScreenW * 0.38, width: kScreenW, height: kcycleViewHeight + 30), collectionViewLayout: layout)
        collView.delegate = self
        collView.dataSource = self
        collView.isPagingEnabled = true
        if iconarr.count > 10{
            collView.isScrollEnabled = true
        }else{
           collView.isScrollEnabled = false
        }
        
//        collView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 10)
        collView.backgroundColor = UIColor.white
//        collView.bounces = false
        collView.alwaysBounceHorizontal = true
        collView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
//        collView.alwaysBounceVertical = false
        collView.showsHorizontalScrollIndicator = false
        collView.showsVerticalScrollIndicator = false
        collView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collID")
        self.addSubview(collView)
    }
}
extension JdHeaderView : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.iconarr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collID", for: indexPath)
        
        let imgView : UIImageView!
        let titleLab : UILabel!
        // 避免重用
        if cell.contentView.subviews.count > 0 {
            imgView = cell.contentView.subviews[0] as? UIImageView
            titleLab = cell.contentView.subviews[1] as? UILabel
        }else {
            
            imgView = UIImageView.init()
            imgView.backgroundColor = UIColor.clear
            imgView.layer.masksToBounds = true
            imgView.layer.cornerRadius = 20
            
            cell.contentView.addSubview(imgView)
            imgView.snp.makeConstraints { (make) in
                make.size.equalTo(48)
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            
            
            titleLab = UILabel.init()
            titleLab.font = UIFont.systemFont(ofSize: 13)
            titleLab.textColor = UIColor.black
            titleLab.textAlignment = .center
            cell.contentView.addSubview(titleLab)
            titleLab.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(imgView.snp.bottom).offset(8)
            }
        }
        titleLab.text = iconarr[indexPath.item]["title"]
        imgView.image = UIImage(named: iconarr[indexPath.item]["icon"]!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10,left: 20,bottom: 25,right: 15)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 40
//    }
    
    
    
}
