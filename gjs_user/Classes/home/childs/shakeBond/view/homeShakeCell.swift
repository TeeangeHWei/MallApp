//
//  homeShakeCell.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/11/11.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class homeShakeCell: UICollectionViewCell {
    var label : UILabel?
    var itemImg : UIImageView?
    var startImg : UIImageView?
    // 点赞view
    var likeView : UIImageView?
    // 点赞图标
    var likeImg : UIImageView?
    // 点赞数
    var likeNum : UILabel?
    // 商品名称
    var shotTitle : UILabel?
    //商品金额
    var shortCron : UILabel?
    //优惠券图片
    var couponImg : UIImageView?
    // 优惠券金额
    var couponCron : UILabel?
    // 平台图标
    var platImg : UIImageView?
    // 商品图标
    var shotImg : UIImageView?
    // 会员赚
    var member : UILabel?
    // 团长赚
    var commander : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = colorwithRGBA(241, 241, 241, 0.5)
        self.label = UILabel.init(frame: self.bounds)
        
        self.label?.font = UIFont.systemFont(ofSize: 30)
        self.addSubview(label!)
        setUI()
        
        
    }
    func setUI(){
        shotImg = UIImageView.init()
        self.addSubview(shotImg!)
        shotImg!.layer.cornerRadius = 5
        shotImg!.layer.masksToBounds = true
//            shotImg.backgroundColor = .red
        shotImg!.snp.makeConstraints { (make) in
//                make.size.equalTo(100)
            make.height.equalTo(230)
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.left.equalToSuperview()
//                make.centerY.equalToSuperview().offset(-12)
        }
        startImg = UIImageView.init()
        startImg!.image = UIImage(named: "shakeplay")
        shotImg!.addSubview(startImg!)
        startImg!.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        likeView = UIImageView.init()
        shotImg!.addSubview(likeView!)
        likeView!.layer.cornerRadius = 8
        likeView!.layer.masksToBounds = true
        likeView!.backgroundColor = colorwithRGBA(15, 15, 15, 0.5)
        likeView!.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(10)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        likeImg = UIImageView.init()
        likeImg!.image = UIImage(named: "home_content_shake_ic_like")
        likeView!.addSubview(likeImg!)
        likeImg!.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.top.equalToSuperview().offset(5)
            make.size.equalTo(13)
        }
        likeNum = UILabel.init()
        likeNum!.font = UIFont.systemFont(ofSize: 11)
        likeNum!.textColor = .white
        likeView!.addSubview(likeNum!)
        likeNum!.snp.makeConstraints { (make) in
            make.left.equalTo(likeImg!.snp.right).offset(3)
            make.top.equalToSuperview().offset(3)
            make.height.equalTo(15)
            make.width.equalTo(35)
        }
        platImg = UIImageView.init()
        self.addSubview(platImg!)
        platImg!.snp.makeConstraints { (make) in
            make.top.equalTo(shotImg!.snp.bottom).offset(7)
            make.left.equalToSuperview().offset(4)
            make.size.equalTo(18)
            
        }
        shotTitle = UILabel.init()
        shotTitle!.font = UIFont.systemFont(ofSize: 16)
        shotTitle!.lineBreakMode = .byTruncatingTail
        self.addSubview(shotTitle!)
        shotTitle!.snp.makeConstraints { (make) in
            make.left.equalTo(platImg!.snp.right).offset(2)
            make.top.equalTo(shotImg!.snp.bottom).offset(7)
            make.height.equalTo(20)
            make.width.equalTo(180)
        }
        shortCron = UILabel.init()
        shortCron!.font = UIFont.boldSystemFont(ofSize: 16)
        self.addSubview(shortCron!)
        shortCron!.snp.makeConstraints { (make) in
            make.top.equalTo(platImg!.snp.bottom).offset(8)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        couponImg = UIImageView.init()
        couponImg!.image = UIImage(named:"coupon")
        self.addSubview(couponImg!)
        couponImg!.snp.makeConstraints { (make) in
            make.top.equalTo(platImg!.snp.bottom).offset(13)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(20)
            make.width.equalTo(56)
        }
        
        couponCron = UILabel.init()
        couponCron!.textColor = .white
        couponCron!.textAlignment = .center
        couponCron!.font = UIFont.systemFont(ofSize: 12)
        couponImg!.addSubview(couponCron!)
        couponCron!.snp.makeConstraints { (make) in
//                make.left.equalToSuperview().offset(5)
            make.height.equalTo(20)
            make.width.equalTo(56)
        }
        member = UILabel.init(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        member?.font = FontSize(10)
        member?.layer.cornerRadius = 3
        member?.textAlignment = .center
//        member?.layer.masksToBounds = true
        member?.textColor = .white
        let memberColors = [colorwithRGBA(250,60,147,1).cgColor,colorwithRGBA(253,133,92,1).cgColor]
        member?.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), memberColors)
        self.addSubview(member!)
        member?.snp.makeConstraints{ (make) in
            make.width.equalTo(80)
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(5)
            make.top.equalTo(shortCron!.snp.bottom).offset(15)
            
        }
        commander = UILabel.init(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        commander?.layer.cornerRadius = 3
//        commander?.layer.masksToBounds = true
        commander?.font = FontSize(10)
        commander?.textColor = .white
        commander?.textAlignment = .center
        let commanderColors = [colorwithRGBA(83,54,240,1).cgColor,colorwithRGBA(169,103,239,1).cgColor]
        commander?.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), commanderColors)
        self.addSubview(commander!)
        commander?.snp.makeConstraints{ (make) in
            make.width.equalTo(80)
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(shortCron!.snp.bottom).offset(15)
        }
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
