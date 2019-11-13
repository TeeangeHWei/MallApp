//
//  officialTableViewCell.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/27.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class officialTableViewCell: UITableViewCell {
    fileprivate static let cellID = "officialTableViewCellID"
    fileprivate var officialCollView : UICollectionView!
    var officialbtn = UIButton()
    var buyStr : String?
    var zeroadtitle : String?
    var navC : UINavigationController?
    var cycleView = ZCycleView()
    let isShow = UserDefaults.getIsShow()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 自己定义方法 初始化cell 复用
    class func dequeue(_ tableView : UITableView) -> officialTableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? officialTableViewCell {
            return cell
        }
        let cell = officialTableViewCell.init(style: .default, reuseIdentifier: cellID)
        return cell
    }
    
}
@available(iOS 11.0, *)
extension officialTableViewCell{
    fileprivate func makeUI(){
        let officialcontentview = contentView
        // 此处搭建 任何 视图
        
        // 在这个cell 里面  添加个  collectionView
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        // 设置竖向滑动
        //        layout.scrollDirection = .vertical
        
        let officialview = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        officialview.backgroundColor = UIColor.clear
        officialview.showsVerticalScrollIndicator = false
        officialview.showsHorizontalScrollIndicator = false
        self.officialCollView = officialview
        officialcontentview.addSubview(officialview)
        //        SpicollView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: <#T##CGFloat#>)
        officialview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        

//        officialbtn = UIButton.init()
//        officialbtn.addTarget(self, action: #selector(toOfficial), for: .touchUpInside)
//        officialcontentview.addSubview(officialbtn)
//        officialbtn.snp.makeConstraints { (make) in
//            make.height.equalTo(90)
//            make.width.equalTo(243)
//            make.edges.equalTo(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
//        }
        
        cycleView = ZCycleView.init()
        if isShow == 0{
            cycleView.isHidden = true
        }else{
            cycleView.isHidden = false
        }
        cycleView.pageControlIndictirColor = colorwithRGBA(241, 241, 241, 0.5)
        cycleView.pageControlCurrentIndictirColor = .yellow
        cycleView.pageControlAlignment = .center
        
        officialcontentview.addSubview(cycleView)
        cycleView.snp.makeConstraints { (make) in
            make.height.equalTo(90)
            make.width.equalTo(243)
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
//        cycleView.setImagesGroup([#imageLiteral(resourceName: "pdd-banner")])
        cycleView.didSelectedItem = {
            print("\($0)")
            let vc = BannerWebViewController()
            vc.webAddress = "https://www.ganjinsheng.com/user/null"
            vc.toUrl = self.buyStr! + "123"
            print("buystr",vc.toUrl)
            vc.headerTitle = self.zeroadtitle!
            self.navC?.pushViewController(vc, animated: true)
        }
        
        let bottomline = UIImageView.init()
        bottomline.backgroundColor = colorwithRGBA(247, 247, 247, 1)
        officialcontentview.addSubview(bottomline)
        bottomline.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenW)
            make.height.equalTo(3)
            make.bottom.equalToSuperview()
        }
        
    }
    @objc func toOfficial (_ btn : UIButton) {
        let vc = BannerWebViewController()
        vc.webAddress = "https://www.ganjinsheng.com/user/null"
        vc.toUrl = buyStr ?? "" + "123"
        vc.headerTitle = self.zeroadtitle!
        self.navC?.pushViewController(vc, animated: true)
    }
}




