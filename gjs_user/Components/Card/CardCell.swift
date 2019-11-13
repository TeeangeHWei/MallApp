//
//  CardCell.swift
//  Banner
//
//  Created by 王彦森 on 2017/12/12.
//  Copyright © 2017年 Dwyson. All rights reserved.
//


class CardCell: UICollectionViewCell {
    
    var imgView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let backView = UIView(frame:contentView.bounds)
        addSubview(backView)

        backView.layer.shadowOpacity = 0.08
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize(width: 10, height: 10)
        backView.layer.shadowRadius = 3
        
        imgView = UIImageView(frame:contentView.bounds)
        imgView.layer.cornerRadius = 10
        imgView.layer.masksToBounds = true
        backView.addSubview(imgView)
        
        let aQrcodeView = UIView(frame:CGRect(x: contentView.bounds.size.width * 0.5 - 50, y: contentView.bounds.size.height - 160, width: 100, height: 130))
        backView.addSubview(aQrcodeView)
        
        let aQrcode = UIView(frame:CGRect(x: 0, y: 0, width: 100, height: 100))
        aQrcode.layer.cornerRadius = 5
        aQrcode.layer.masksToBounds = true
        aQrcode.backgroundColor = .white
        aQrcodeView.addSubview(aQrcode)
        
        let QrcodeImg = UIImageView(frame:CGRect(x: 5, y: 5, width: 90, height: 90))
        let url = AlamofireUtil.BASE_IMG_URL+"/user/appDownload?id="+(UserDefaults.getInfo()["inviteCode"] as! String)
        QRGenerator.setQRCodeToImageView(QrcodeImg, url)
        aQrcode.addSubview(QrcodeImg)
        
        let aQrcodeLabel = UILabel(frame:CGRect(x: 0, y: 106, width: 100, height: 24))
        aQrcodeLabel.backgroundColor = .white
        aQrcodeLabel.layer.cornerRadius = 5
        aQrcodeLabel.layer.masksToBounds = true
        aQrcodeLabel.text = "邀请码：" + (UserDefaults.getInfo()["inviteCode"] as! String)
        aQrcodeLabel.textColor = kMainTextColor
        aQrcodeLabel.font = FontSize(10)
        aQrcodeLabel.textAlignment = .center
        aQrcodeView.addSubview(aQrcodeLabel)
        
        
        contentView.addSubview(backView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
