//
//  PddSpreadViewController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/14.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class PddSpreadViewController: ViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var pageTitle : String?
    var collectionView : UICollectionView?
    var shareImg = UIImageView()
    var shareImgView = UIView()
    var sharebotView = UIView()
    var sharebotTitle = UILabel()
    var sharebtnImg : UIImageView?
    var labelView : UITextView?
    var QRCodeViewImg = UIImageView()
    var shortURL : String?
    var QRimg : UIImage?
    let imgarr = [["img":"sharebtn_18","name":"复制文案"],
                  ["img":"sharebtn_19","name":"下载图片"],
                  ["img":"sharebtn_20","name":"微信"],
                  ["img":"sharebtn_21","name":"朋友圈"]]
    let sharimg = ["newshare_22","newshare_23","newshare_24","newshare_25","newshare_26"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let navView = customNav(titleStr: pageTitle!, titleColor: kMainTextColor)
        self.view.addSubview(navView)
        makeUI()
        shortURLData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func makeUI(){
        let sharelabel : UILabel
        // 添加分享图片视图
        self.view.addSubview(self.shareImg)
        self.shareImg.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(headerHeight + 20)
            make.height.equalTo(kScreenH * 0.5 )
            make.width.equalTo(kScreenW * 0.62)
        })
        // 添加二维码view视图
        self.shareImgView.backgroundColor = .white
        self.shareImgView.layer.cornerRadius = 5
        self.shareImgView.layer.masksToBounds = true
        self.shareImg.addSubview(self.shareImgView)
        self.shareImgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-43)
            make.height.equalTo(65)
            make.width.equalTo(65)
        }
        
        // 添加二维码图片样式
        self.shareImgView.addSubview(self.QRCodeViewImg)
        self.QRCodeViewImg.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.width.equalTo(60)
            make.top.equalTo(2)
            make.left.equalTo(2)
        }
        
        // 添加二维码底下扫码有惊喜
        self.sharebotView.backgroundColor = .white
        self.sharebotView.layer.cornerRadius = 5
        self.sharebotView.layer.masksToBounds = true
        self.shareImg.addSubview(self.sharebotView)
        sharebotView.snp.makeConstraints { (make) in
//            make.top.equalTo(self.shareImg.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(20)
            make.width.equalTo(60)
        }
        self.sharebotTitle.text = "扫码有惊喜"
        self.sharebotTitle.font = UIFont.systemFont(ofSize: 10)
        self.sharebotTitle.textAlignment = .center
        self.sharebotView.addSubview(sharebotTitle)
        sharebotTitle.snp.makeConstraints({ (make) in
            make.top.left.bottom.right.equalToSuperview()
            make.height.equalTo(10)
            make.width.equalTo(48)
        })
        
        
        
        
        
        
        sharelabel = UILabel.init()
        sharelabel.text = "分享文案"
        sharelabel.font = UIFont.systemFont(ofSize: 20)
        sharelabel.textAlignment = .center
        self.view.addSubview(sharelabel)
        sharelabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.shareImg.snp.bottom).offset(1)
            make.height.equalTo(kScreenW * 0.12)
            make.width.equalTo(kScreenW * 0.29)
        }
        self.labelView = UITextView.init()
        self.labelView!.backgroundColor = colorwithRGBA(246, 246, 246, 1)
        self.labelView!.layer.cornerRadius = 5
        self.labelView!.font = UIFont.systemFont(ofSize: 15)
        self.labelView!.textAlignment = .left
        self.labelView!.isEditable = false
        self.labelView!.textContainerInset = UIEdgeInsets(top: 30, left: 5, bottom: 30, right: 5)
        
        self.labelView!.layer.masksToBounds = true
        self.view.addSubview(self.labelView!)
        self.labelView!.snp.makeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.top.equalTo(sharelabel.snp.bottom).offset(1)
                    make.height.equalTo(kScreenW * 0.25)
                    make.width.equalTo(kScreenW - 60)
                }
        self.collectionView?.isUserInteractionEnabled = false
                let layout = UICollectionViewFlowLayout.init()
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: kScreenW/5, height: 75)
        //        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 5, bottom: 10, right: 5)
                              
        self.collectionView = UICollectionView.init(frame:CGRect(), collectionViewLayout: layout)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.backgroundColor = .white
        self.collectionView?.isScrollEnabled = false
        self.view.addSubview(self.collectionView!)
        self.collectionView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.labelView!.snp.bottom).offset(12)
            make.height.equalTo(kScreenW * 0.25)
            make.width.equalTo(kScreenW - 60)
        })
                              
                // collView 视图 距离上下左右边距
        self.collectionView?.contentInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collID")
    }

    func shortURLData(){
        
        AlamofireUtil.post(url: "/ddk/ddkRpPromUrlGenerate", param: ["generateShortUrl":true,"channelType":0], success: { (res, data) in
            let url = data["urlList"][0]["mobileShortUrl"].string
            
            self.shortURL = url
            self.reload_data()
            
        }, error: {
            
        }, failure: {
            
        })
        
   
    }
    func reload_data(){
        self.labelView!.text = "红包福利专享专场,超多大额优惠券发放中,一键立抢>>" + self.shortURL!
        UIPasteboard.general.string = "红包福利专享专场,超多大额优惠券发放中,一键立抢>>" + shortURL!
        self.QRCodeViewImg.image = QRGenerator.setQRCodeToImageView(self.QRCodeViewImg, self.shortURL!)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgarr.count
       }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            
            IDToast.id_show(msg: "复制成功", success: .success)
        }else if indexPath.row == 1{
            let sharedownImg = getImageFromView(view: shareImg)
            UIImageWriteToSavedPhotosAlbum(sharedownImg, nil, nil, nil)
            IDToast.id_show(msg: "下载成功", success: .success)
        }else if indexPath.row == 2 {
            let textShare = pageTitle
            let sharedownImg = getImageFromView(view: shareImg)
            let imageShare = sharedownImg
            let activityItems = [textShare as Any,imageShare as Any]
            //弹出分享框
            let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities:nil)
            present(activityViewController, animated: true, completion: nil)
            //分享结束后的回调
            activityViewController.completionWithItemsHandler = {(_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ activityError: Error?) -> Void in
                print(completed ? "成功" : "失败")
            }
        }else if indexPath.row == 3{
            let textShare = pageTitle
            let imageShare = getImageFromView(view: shareImg)
            let activityItems = [textShare as Any,imageShare as Any]
            //弹出分享框
            let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities:nil)
            present(activityViewController, animated: true, completion: nil)
            //分享结束后的回调
            activityViewController.completionWithItemsHandler = {(_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ activityError: Error?) -> Void in
                print(completed ? "成功" : "失败")
            }
        }
        
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collID", for: indexPath)
        let imgView : UIImageView!
        let titleLab : UILabel!
        let item = imgarr[indexPath.row]
        // 避免重用
        if cell.contentView.subviews.count > 0 {
            imgView = cell.contentView.subviews[0] as? UIImageView
            titleLab = cell.contentView.subviews[1] as? UILabel
        }else{
            imgView = UIImageView.init()
            imgView.contentMode = .scaleAspectFit
            imgView.backgroundColor = UIColor.clear
            imgView.layer.masksToBounds = true
            imgView.layer.cornerRadius = 20
            imgView.image = UIImage(named: item["img"]!)
            cell.contentView.addSubview(imgView)
            imgView.snp.makeConstraints { (make) in
                make.size.equalTo(50)
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            
            
            titleLab = UILabel.init()
            titleLab.font = UIFont.systemFont(ofSize: 13)
            titleLab.textColor = UIColor.black
            titleLab.textAlignment = .center
            titleLab.text = item["name"]
            cell.contentView.addSubview(titleLab)
            titleLab.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(imgView.snp.bottom).offset(10)
            }
        }
        return cell
    }
        
}
