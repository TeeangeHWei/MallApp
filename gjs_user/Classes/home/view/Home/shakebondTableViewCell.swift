//
//  shakebondTableViewCell.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/3.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class shakebondTableViewCell: UITableViewCell {
    fileprivate static let cellID = "shakebondViewCellID"
    fileprivate var shakebondView : UICollectionView!
    weak var naviController : UINavigationController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var shakebondModel : Array<shakeBondData>!{
        didSet{
            self.shakebondView.reloadData()
        }
    }
//    var newShakebondModel : shakeBondData?{
//        didSet{
//            self.shakebondView.reloadData()
//        }
//    }

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
    class func dequeue(_ tableView : UITableView) -> shakebondTableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? shakebondTableViewCell {
            return cell
        }
        let cell = shakebondTableViewCell.init(style: .default, reuseIdentifier: cellID)
        return cell
        
    }
  
}
extension shakebondTableViewCell {
    fileprivate func makeUI(){
        let shakebond = self.contentView
        shakebond.backgroundColor = .white
        // 此处搭建 任何 视图
        let shakebondImg = UIImageView.init()
        shakebondImg.image = UIImage(named: "shakebond")
        shakebond.addSubview(shakebondImg)
        shakebondImg.snp.makeConstraints { (make) in
            make.width.equalTo(32)
            make.height.equalTo(20)
            make.leftMargin.equalTo(5)
            make.topMargin.equalTo(15)
        }
        // 在这个cell 里面  添加个  collectionView
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 150, height: 220)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        // 设置横向滑动
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: -50, left: 5, bottom: 0, right: 5)
        let shakeView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        shakeView.delegate = self
        shakeView.dataSource = self
        shakeView.backgroundColor = UIColor.white
        shakeView.showsVerticalScrollIndicator = false
        shakeView.showsHorizontalScrollIndicator = false
        self.shakebondView = shakeView
        shakebond.addSubview(shakeView)
        shakeView.snp.makeConstraints { (make) in
            make.top.equalTo(shakebondImg.snp.bottom).offset(5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(5)
        }
        print("shake",shakeView.frame)
        
        
        let shakeLabel = UILabel.init()
        shakeLabel.text = "抖券"
        shakeLabel.textColor = colorwithRGBA(247, 55, 51, 1)
        shakeLabel.font = UIFont.systemFont(ofSize: 15)
        shakebond.addSubview(shakeLabel)
        shakeLabel.snp.makeConstraints { (make) in
            make.width.equalTo(32)
            make.height.equalTo(20)
            make.leftMargin.equalTo(shakebondImg.snp.right).offset(20)
            make.topMargin.equalTo(shakebondImg.snp.topMargin)
        }
        // 更多秒杀按钮
        let Morebtn = UIButton.init()
        Morebtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        Morebtn.setTitle("更多", for: .normal)
        // 根据按钮偏移量 调换按钮与图片位置
        Morebtn.setTitleColor(colorwithRGBA(248, 14, 0, 0.8), for: .normal)
//        Morebtn.setImage(UIImage(named: "Spike_right"), for: .normal)
        Morebtn.addTarget(self, action: #selector(moreclick), for: .touchUpInside)
        shakebond.addSubview(Morebtn)
        Morebtn.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.right.equalTo(-15)
            make.top.equalTo(12)
        }
        let moreRightImg = UIImageView.init()
        moreRightImg.image = UIImage(named: "Spike_right")
        Morebtn.addSubview(moreRightImg)
        moreRightImg.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(6)
            make.right.equalToSuperview().offset(-15)
            make.size.equalTo(14)
        }
        let grayline = UIView.init( )
    
        grayline.backgroundColor = colorwithRGBA(241, 241, 241, 1)
        shakebond.addSubview(grayline)
        grayline.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.width.equalTo(kScreenW - 17)
            make.height.equalTo(1)
        }
        
        
        // collView 视图 距离上下左右边距
        shakeView.contentInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        // 注册cell
        shakeView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "shakecollCellID")
        shakeView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "spicollBtnCellID")
    }
    @objc func moreclick(){
        let vc = shakeBondViewController()
        naviController?.pushViewController(vc, animated: true)
    }
}

extension shakebondTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return self.shakebondModel!.count
        }else{
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
        // 创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shakecollCellID", for: indexPath)
        // 点赞view
        let likeView : UIImageView!
        // 点赞图标
        let likeImg : UIImageView!
        // 点赞数
        let likeNum : UILabel!
        // 播放图标
        let startImg : UIImageView!
        // 预计赚图片
        let yujiImg : UIImageView!
        // 预计赚金额
        let yujiCron : UILabel!
        // 商品图标
        let shotImg : UIImageView!
        // 商品名称
        let shotTitle : UILabel!
        //商品金额
        let shortCron : UILabel!
        //优惠券图片
        let couponImg : UIImageView!
        // 优惠券金额
        let couponCron : UILabel!
        // 平台图标
        let platImg : UIImageView!
        if cell.contentView.subviews.count > 0{
            shotImg = cell.contentView.subviews[0] as? UIImageView
            startImg = shotImg.subviews[0] as? UIImageView
            likeView = shotImg.subviews[1] as? UIImageView
            likeImg = likeView.subviews[0] as? UIImageView
            likeNum = likeView.subviews[1] as? UILabel
            yujiImg = cell.contentView.subviews[1] as? UIImageView
            yujiCron = yujiImg.subviews[0] as? UILabel
            platImg = cell.contentView.subviews[2] as? UIImageView
            shotTitle = cell.contentView.subviews[3] as? UILabel
            shortCron = cell.contentView.subviews[4] as? UILabel
            couponImg = cell.contentView.subviews[5] as? UIImageView
            couponCron = couponImg.subviews[0] as? UILabel
            
        }else{
            shotImg = UIImageView.init()
            cell.contentView.addSubview(shotImg)
            shotImg.layer.cornerRadius = 5
            shotImg.layer.masksToBounds = true
//            shotImg.backgroundColor = .red
            shotImg.snp.makeConstraints { (make) in
//                make.size.equalTo(100)
                make.height.equalTo(150)
                make.width.equalTo(135)
                make.top.equalToSuperview().offset(35)
                make.left.equalToSuperview().offset(7)
//                make.centerY.equalToSuperview().offset(-12)
            }
            startImg = UIImageView.init()
            startImg.image = UIImage(named: "shakeplay")
            shotImg.addSubview(startImg)
            startImg.snp.makeConstraints { (make) in
                make.centerX.centerY.equalToSuperview()
                make.size.equalTo(40)
            }
            
            likeView = UIImageView.init()
            shotImg.addSubview(likeView)
            likeView.layer.cornerRadius = 8
            likeView.layer.masksToBounds = true
            likeView.backgroundColor = colorwithRGBA(15, 15, 15, 0.5)
            likeView.snp.makeConstraints { (make) in
                make.left.top.equalToSuperview().offset(10)
                make.height.equalTo(15)
                make.width.equalTo(50)
            }
            likeImg = UIImageView.init()
            likeImg.image = UIImage(named: "home_content_shake_ic_like")
            likeView.addSubview(likeImg)
            likeImg.snp.makeConstraints { (make) in
                make.left.equalTo(5)
                make.size.equalTo(12)
            }
            likeNum = UILabel.init()
            likeNum.font = UIFont.systemFont(ofSize: 10)
            likeNum.textColor = .white
            likeView.addSubview(likeNum)
            likeNum.snp.makeConstraints { (make) in
                make.left.equalTo(likeImg.snp.right).offset(3)
                make.height.equalTo(15)
                make.width.equalTo(30)
            }
            
            yujiImg = UIImageView.init()
            yujiImg.image = UIImage(named: "yujizuan")
            cell.contentView.addSubview(yujiImg)
            yujiImg.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(-2)
                make.top.equalTo(startImg.snp.bottom).offset(10)
                make.height.equalTo(27)
                make.width.equalTo(80)
            }
            yujiCron = UILabel.init()
            yujiCron.textColor = .white
            yujiCron.text = "预计赚¥2.9"
            yujiCron.font = UIFont.systemFont(ofSize: 10)
            yujiImg.addSubview(yujiCron)
            yujiCron.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(5)
                make.top.equalToSuperview().offset(-2)
                make.height.equalTo(21)
                make.width.equalTo(70)
            }
            platImg = UIImageView.init()
            cell.contentView.addSubview(platImg)
            platImg.snp.makeConstraints { (make) in
                make.top.equalTo(shotImg.snp.bottom).offset(7)
                make.left.equalToSuperview().offset(2)
                make.size.equalTo(14)
                
            }
            shotTitle = UILabel.init()
            shotTitle.font = UIFont.systemFont(ofSize: 14)
            shotTitle.lineBreakMode = .byTruncatingTail
            cell.contentView.addSubview(shotTitle)
            shotTitle.snp.makeConstraints { (make) in
                make.left.equalTo(platImg.snp.right).offset(2)
                make.top.equalTo(shotImg.snp.bottom).offset(7)
                make.height.equalTo(20)
                make.width.equalTo(100)
            }
            shortCron = UILabel.init()
            shortCron.font = UIFont.boldSystemFont(ofSize: 16)
            cell.contentView.addSubview(shortCron)
            shortCron.snp.makeConstraints { (make) in
                make.top.equalTo(platImg.snp.bottom).offset(8)
                make.height.equalTo(30)
                make.width.equalTo(70)
            }
            couponImg = UIImageView.init()
            couponImg.image = UIImage(named:"coupon")
            cell.contentView.addSubview(couponImg)
            couponImg.snp.makeConstraints { (make) in
                make.top.equalTo(platImg.snp.bottom).offset(13)
                make.left.equalTo(shortCron.snp.right).offset(15)
                make.height.equalTo(18)
                make.width.equalTo(54)
            }
            
            couponCron = UILabel.init()
            couponCron.textColor = .white
            couponCron.textAlignment = .center
            couponCron.font = UIFont.systemFont(ofSize: 10)
            couponImg.addSubview(couponCron)
            couponCron.snp.makeConstraints { (make) in
//                make.left.equalToSuperview().offset(5)
                make.height.equalTo(18)
                make.width.equalTo(54)
            }
            
        }
            
        let model = self.shakebondModel![indexPath.row]
            if model.itemprice != nil{
                shotTitle.text = model.itemtitle
                shortCron.text = "¥" + model.itemprice!
                couponCron.text = model.couponmoney! + "元券"
                var icon = UIImage.init(named: "taobao")
                if model.shoptype == "B" {
                    icon = UIImage.init(named: "tianmao")
        //            typeLabel.text = "天猫"
        //            typeLabel.backgroundColor = colorwithRGBA(255, 1, 55, 1)
                } /*else {
                    typeLabel.text = "淘宝"
                    typeLabel.backgroundColor = colorwithRGBA(255, 80, 0, 1)
                }*/
                platImg.image = icon
                var memberStatus = 1
                let info = UserDefaults.getInfo()
                if info["id"] as! String != "" {
                    memberStatus = Int(UserDefaults.getInfo()["memberStatus"] as! String)!
                }
        //        yujiCron.text = "预计赚¥"+(model.tkmoney ?? "")
                if memberStatus == 1 {
                    let commission = Commons.strToDou(model.tkmoney!) * Commons.vip1Scale()
                    yujiCron.text = "预计赚¥\(String(format:"%.2f",commission))"
                }else {
                    let commission = Commons.strToDou(model.tkmoney!) * Commons.vip2Scale()
                    yujiCron.text = "预计赚¥\(String(format:"%.2f",commission))"
                }
                likeNum.text = model.dy_video_like_count
                let shakeImgUrl = URL.init(string: model.first_frame ?? "")
                let placeholderImage = UIImage(named: "loading")
                shotImg.kf.setImage(with: shakeImgUrl, placeholder: placeholderImage)
            }
        
        
        return cell
        }else{
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spicollBtnCellID", for: indexPath)
            
            var morebtn : UIButton!
            var moreTitle : UILabel!
            var moreimg : UIImageView!
            
            if cell.contentView.subviews.count > 0 {
                
                morebtn = cell.contentView.subviews[0] as? UIButton
                moreTitle = cell.contentView.subviews[1] as? UILabel
                moreimg = cell.contentView.subviews[2] as? UIImageView
            }else {
                morebtn = UIButton.init()
                morebtn.layer.masksToBounds = true
                morebtn.layer.cornerRadius = 4
                morebtn.backgroundColor = colorwithRGBA(247, 247, 247, 1)
                cell.contentView.addSubview(morebtn)
                morebtn.snp.makeConstraints { (make) in
                    make.height.equalTo(190)
                    make.width.equalTo(60)
                    make.top.equalToSuperview().offset(34)
                }
                
                moreTitle = UILabel.init()
                moreTitle.font = UIFont.systemFont(ofSize: 14)
                moreTitle.textColor = colorwithRGBA(156, 156, 156, 1)
                moreTitle.numberOfLines = 0
                moreTitle.textAlignment = .center
                cell.contentView.addSubview(moreTitle)
                moreTitle.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(60)
                    make.centerX.equalToSuperview()
                    make.width.equalTo(14)
                }
                
                moreimg = UIImageView.init()
                moreimg.image = UIImage(named: "morebtn")
                cell.contentView.addSubview(moreimg)
                moreimg.snp.makeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.top.equalTo(moreTitle.snp.bottom).offset(20)
                    make.width.height.equalTo(15)
                    make.height.equalTo(15)
                }
        }
            moreTitle.text = "查看更多"
            morebtn.addTarget(self, action: #selector(moreBtnClick(_:)), for: .touchUpInside)
            return cell
        }
    }
    @objc func moreBtnClick(_ btn : UIButton) {
           // 查看更多
        let vc = shakeBondViewController()
        naviController?.pushViewController(vc, animated: true)
       }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let videoVC = shakeBondVideoController()
            naviController?.pushViewController(videoVC, animated: true)
        }else{
            let vc = shakeBondViewController()
            naviController?.pushViewController(vc, animated: true)
        }
    }
}


extension shakebondTableViewCell : UICollectionViewDelegateFlowLayout {
    // 每个layout 大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize.init(width: 150, height: 220)
        }else {
            return CGSize.init(width: 60, height: 220)
        }
    }
}
