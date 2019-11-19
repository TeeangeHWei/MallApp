//
//  SecondRecommendCell.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/29.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit
import Photos
import JXPhotoBrowser

class SecondRecommendCell: UITableViewCell {
    let layout = UICollectionViewFlowLayout()
    var imageBackViewHeight: NSLayoutConstraint!
    var releaseTime : UILabel?
    var shareNum : UILabel?
    var shareText = UILabel()
    var copyText : String?
    var collectionView : UICollectionView!
    var shotitemid = String()
    var shotitemtitle : String?
    var price = UILabel()
    var phototag = Int()
    var imgtag = Int()
    var shotitemData : RecommendItem?
    weak var recommendnavi : UINavigationController?
    fileprivate static let cellID = "SecondRecommendCellID"
    var images = [String](){
        didSet{
            if images.count == 0 {
                    imageBackViewHeight.constant = 0
                }
                if images.count == 1 {
                    
                    let height = kScreenW - 30
                    
                    imageBackViewHeight.constant = height
                    print("imageBackViewHeight1",imageBackViewHeight.constant)
                    layout.itemSize = CGSize(width: height, height: height)
                    print("itemsize1",layout.itemSize)
                    layout.minimumLineSpacing = 0
                    layout.minimumInteritemSpacing = 0
                    
                }
                
                if images.count == 2 {
                    let height = (kScreenW - 3 - 80)/2
                    imageBackViewHeight.constant = height
                    print("imageBackViewHeight2",imageBackViewHeight.constant)
                    layout.itemSize = CGSize(width: height, height: height)
                    print("itemsize2",layout.itemSize)
                    layout.minimumLineSpacing = 0
                    layout.minimumInteritemSpacing = 3
                }
                
                if images.count == 3 {
                    let height = (kScreenW - 6 - 80)/3
                    imageBackViewHeight.constant = height
                    print("imageBackViewHeight3",imageBackViewHeight.constant)
                    layout.itemSize = CGSize(width: height, height: height)
                    print("itemsize3",layout.itemSize)
                    layout.minimumLineSpacing = 0
                    layout.minimumInteritemSpacing = 3
                }
                if images.count == 4 {
                    
                    let height = (kScreenW - 6 - 80)/3
                    print("images::",images)
                    imageBackViewHeight.constant = height * 2.25 + 3
                    print("imageBackViewHeight4",imageBackViewHeight.constant)
                    layout.itemSize = CGSize(width: height, height: height)
                    print("itemsize4",layout.itemSize)
                    layout.minimumLineSpacing = 6
                    layout.minimumInteritemSpacing = 3
                }
                if images.count > 4 && images.count < 7 {
                    
                    let height = (kScreenW - 6 - 80)/3
                    
                    imageBackViewHeight.constant = height * 2.25 + 3
                    print("imageBackViewHeight6",imageBackViewHeight.constant)
                    layout.itemSize = CGSize(width: height, height: height)
                    print("itemsize>7",layout.itemSize)
                    layout.minimumLineSpacing = 6
                    layout.minimumInteritemSpacing = 3
                }

                if images.count >= 7 {
                    let height = (kScreenW - 6 - 80)/3
                    
                    imageBackViewHeight.constant = height * 3 + 6
                    
                    layout.itemSize = CGSize(width: height, height: height)
                    print("itemsize>7",layout.itemSize)
                    layout.minimumLineSpacing = 6
                    layout.minimumInteritemSpacing = 3
                }
            
                
                collectionView.reloadData()
        }
    }
    // 自己定义方法 初始化cell 复用
    class func dequeue(_ tableView : UITableView) -> SecondRecommendCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? SecondRecommendCell {
            return cell
        }
        let cell = SecondRecommendCell.init(style: .default, reuseIdentifier: cellID)
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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

}

extension SecondRecommendCell {
    fileprivate func makeUI(){
        let view = self.contentView
        view.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()

        }
        print("contentview::",self.contentView)
        let topView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenW / 6))
        view.addSubview(topView)
        
        let avatar = UIImageView(image: UIImage(named: "avatar-default"))
        avatar.layer.cornerRadius = 25
        avatar.layer.masksToBounds = true
        topView.addSubview(avatar)
        avatar.snp.makeConstraints { (make) in
            make.size.equalTo(50)
            make.left.top.equalToSuperview().offset(5)
        }
        let authorName = UILabel()
        authorName.text = "赶紧省宣传素材"
        authorName.font = FontSize(14)
        topView.addSubview(authorName)
        authorName.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenW / 2.76)
            make.height.equalTo(20)
            make.left.equalTo(avatar.snp.right).offset(8)
            make.top.equalToSuperview().offset(2)
            
        }
        releaseTime = UILabel.init()
        releaseTime?.font = FontSize(12)
        releaseTime?.textColor = colorwithRGBA(150,150,150,1)
        topView.addSubview(releaseTime!)
        releaseTime?.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenW / 2.76)
            make.height.equalTo(20)
            make.top.equalTo(authorName.snp.bottom).offset(8)
            make.left.equalTo(avatar.snp.right).offset(8)
        }

        
        let copyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW / 5.175, height: 24))
        copyBtn.addTarget(self, action:  #selector(copyFunc), for: .touchUpInside)
        let copyColors = [colorwithRGBA(247,51,47,1).cgColor,colorwithRGBA(250,155,11,1).cgColor]
        copyBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), copyColors)
        copyBtn.layer.cornerRadius = 12
        copyBtn.layer.masksToBounds = true
        copyBtn.setTitle("复制文案", for: .normal)
        copyBtn.titleLabel?.textColor = .white
        copyBtn.titleLabel?.font = FontSize(12)
        topView.addSubview(copyBtn)
        copyBtn.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.width.equalTo(kScreenW / 5.175)
            make.top.equalToSuperview().offset(5)
            make.left.equalTo((releaseTime?.snp.right)!).offset(15)
        }
        let shareBtn = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW / 5.175, height: 24))
        shareBtn.addTarget(self, action: #selector(toShare), for: .touchUpInside)
        //        shareBtn.addTarget(self, action: #selector(self.toDetail), for: UIControl.Event.touchUpInside)
        shareBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), copyColors)
        shareBtn.layer.cornerRadius = 12
        shareBtn.layer.masksToBounds = true
        topView.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.width.equalTo(kScreenW / 5.175)
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(copyBtn.snp.right).offset(5)
        }
        
        let shareBtnImg = UIImageView(image: UIImage(named: "recommend-1"))
        shareBtn.addSubview(shareBtnImg)
        shareBtnImg.snp.makeConstraints { (make) in
            make.size.equalTo(14)
            make.top.equalTo(5)
            make.left.equalTo(20)
        }
        shareNum = UILabel.init()
        shareNum!.font = FontSize(12)
        shareNum!.textColor = .white
        shareBtn.addSubview(shareNum!)
       
        shareNum?.snp.makeConstraints({ (make) in
//            make.size.equalTo(14)
            make.height.equalTo(14)
            make.width.equalTo(50)
            make.top.equalTo(5)
            make.left.equalTo(shareBtnImg.snp.right).offset(3)
        })
        let shareContent = UIView()
        view.addSubview(shareContent)
        shareContent.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenW / 1.41)
            make.height.equalTo(kScreenW / 4.14)
            make.top.equalTo(topView.snp.bottom).offset(5)
            make.left.equalTo(avatar.snp.right).offset(8)
        }
        shareText = UILabel.init()
        shareText.numberOfLines = 15
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 5
        shareContent.addSubview(shareText)
        shareText.snp.makeConstraints({ (make) in
            make.width.equalTo(kScreenW / 1.41)
            make.height.equalTo(kScreenW / 3.6)
        })
        let imagesView = UIView(/*frame: CGRect(x: 66, y: 166, width: kScreenW - 80, height: 280)*/)
        
        imageBackViewHeight = NSLayoutConstraint.init(item: imagesView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 100)
        imagesView.backgroundColor = .clear
        view.addSubview(imagesView)
        imagesView.translatesAutoresizingMaskIntoConstraints = false
        imageView?.backgroundColor = .clear
        imagesView.addConstraint(imageBackViewHeight)
        imagesView.snp.makeConstraints { (make) in
            make.left.equalTo(avatar.snp.right).offset(5)
            make.top.equalTo(shareContent.snp.bottom).offset(15)
            make.width.equalTo(kScreenW - 60)
            make.height.equalTo(350)
        }
        // 图片组用collectionview 创建
        self.collectionView = UICollectionView(frame:CGRect(x: 0, y: 0, width: kScreenW - 80, height: 280), collectionViewLayout: layout)
        self.collectionView.isScrollEnabled = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        imagesView.addSubview(self.collectionView)
        
        collectionView.backgroundColor = .white
        collectionView.snp.makeConstraints { (make) in
            
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().offset(10)
        }
        collectionView.register(UINib.init(nibName: "WLImageCell", bundle: nil), forCellWithReuseIdentifier: "WLImageCell")
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 2, bottom: 5, right: 9)

        let commentView = UIView()
        commentView.backgroundColor = colorwithRGBA(246, 246, 246, 1)
        commentView.layer.cornerRadius = 5
        view.addSubview(commentView)
        commentView.snp.makeConstraints { (make) in
            make.top.equalTo(imagesView.snp.bottom).offset(15)
            make.left.equalTo(avatar.snp.right).offset(5)
            make.width.equalTo(kScreenW - 80)
            make.height.equalTo(88)
        }
        let commentText = UILabel()
        let commentStr = "【购买步骤】长按识别二维码-复制淘口令-点开手机【淘】领券下单"
        commentText.numberOfLines = 2
        let commentParaph = NSMutableParagraphStyle()
        commentParaph.lineSpacing = 5
        let commentAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12),NSAttributedString.Key.paragraphStyle: commentParaph]
        commentText.attributedText = NSAttributedString(string: commentStr, attributes: commentAttributes)
        commentView.addSubview(commentText)
        commentText.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.width.equalTo(kScreenW / 1.26)
            make.height.equalTo(35)
        }
        let commentCopy = UIButton()
        commentCopy.addTarget(self, action: #selector(copyComment), for: .touchUpInside)
        commentCopy.backgroundColor = colorwithRGBA(255,233,219,1)
        commentCopy.setTitle("复制评论", for: .normal)
        commentCopy.titleLabel?.font = FontSize(12)
        commentCopy.setTitleColor(colorwithRGBA(247,51,47,1), for: .normal)
        commentCopy.layer.cornerRadius = 12
        commentView.addSubview(commentCopy)
        commentCopy.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(commentText.snp.bottom).offset(8)
            make.width.equalTo(80)
            make.height.equalTo(24)
        }
    }
    @objc func copyFunc(_ btn:UIButton!){
        UIPasteboard.general.string = copyText!
        IDToast.id_show(msg: "复制成功", success: .success)
    }
    @objc func toShare(_ btn:UIButton) {
        getRatesurl()
    }
    @objc func copyComment(_ btn:UIButton!){
        UIPasteboard.general.string = "【购买步骤】长按识别二维码-复制淘口令-点开手机【淘】领券下单"
        IDToast.id_show(msg: "复制成功", success: .success)
    }
   
    // 高佣转链
    func getRatesurl () {
        
        let id = UserDefaults.getInfo()["id"] as! String
        let relationId = UserDefaults.getInfo()["relationId"] as! String
        if id == "-1" {
            //MARK: 跳转登录
            return
        } else if relationId == nil || relationId == "" {
            //MARK: 发起授权
            return
        }
        IDLoading.id_showWithWait()
        
        AlamofireUtil.post(url:"/product/public/ratesurl", param: [
            "itemid" : shotitemid,
            "relation_id" : UserDefaults.getInfo()["relationId"]!
        ],
        success:{(res, data) in
            if let coupon_click_url = data["tbk_privilege_get_response"]["result"]["data"]["coupon_click_url"].string {
                self.getTaobaoPwd(url: coupon_click_url)
            } else {
                IDLoading.id_dismissWait()
                IDToast.id_show(msg: "出错了，请重试", success: .fail)
            }
        },
        error:{
            IDLoading.id_dismissWait()
        },
        failure:{
            IDLoading.id_dismissWait()
        })
    }
    // 获取淘口令
       func getTaobaoPwd (url: String) {
           AlamofireUtil.post(url:"/taobao/public/getTPwd", param: [
            "text" : self.shotitemtitle,
               "url" : url
           ],
           success:{(res, data) in
               let invite = UserDefaults.getInfo()["inviteCode"]!
            let qrUrl = "https://www.ganjinsheng.com/user/inviteShare?id=\(self.shotitemid)&invite=\(invite)&tbPwd=\(data["model"].string)"
            self.getGoodsInfo(self.shotitemid, qrUrl)
           },
           error:{
               IDLoading.id_dismissWait()
           },
           failure:{
               IDLoading.id_dismissWait()
           })
       }
    // 获取宝贝信息
    func getGoodsInfo (_ id : String, _ qrUrl : String) {
        AlamofireUtil.post(url:"/product/public/detail", param: ["itemid" : id],
        success:{(res,data) in
            IDLoading.id_dismissWait()
            let goodsInfo = DetailData.deserialize(from: data["data"].description)!
            if #available(iOS 11.0, *) {
                let shareDialog = ShareDialog(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenW), itemData: self.shotitemData!, goodsData: goodsInfo, qrUrl: qrUrl, checkIndex: 0)
                self.window?.addSubview(shareDialog)
            } else {
                // Fallback on earlier versions
            }
            
        },
        error:{
            IDLoading.id_dismissWait()
        },
        failure:{
            IDLoading.id_dismissWait()
        })
    }
    @available(iOS 11.0, *)
    @objc func toDetail (sender:UITapGestureRecognizer) {
        weak var weakSelf = self //避免循环引用
           print("点击了")
           let vc = DetailController()
        detailId = Int(self.shotitemid)
        weakSelf!.recommendnavi?.pushViewController(vc, animated: true)
  
    }
}


extension SecondRecommendCell : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
        
        if indexPath.row == 0{
                   print("点击了")
                   if #available(iOS 11.0, *) {
                       let vc = DetailController()
                    detailId = Int(self.shotitemid)
                       recommendnavi?.pushViewController(vc, animated: true)
                   }
               }
        if indexPath.row >= 1{
            print("点击\(indexPath.row)")
            // 网图加载器
            let loader = JXKingfisherLoader()
            // 数据源
            let dataSource = JXNetworkingDataSource(photoLoader: loader, numberOfItems: { () -> Int in
                return self.images.count
            }, placeholder: { index -> UIImage? in
                return UIImage(named: "loading")
            }) { index -> String? in
                return self.images[index]
            }
            // 视图代理，实现了光点型页码指示器
            let delegate = JXDefaultPageControlDelegate()
            // 转场动画
            let trans = JXPhotoBrowserZoomTransitioning { (browser, index, view) -> UIView? in
                let indexPath = IndexPath(item: index, section: 0)
                return UIImageView(image: UIImage(named: "loading"))
            }
            // 打开浏览器
            JXPhotoBrowser(dataSource: dataSource, delegate: delegate, transDelegate: trans)
                .show(pageIndex: indexPath.row)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WLImageCell", for: indexPath) as! WLImageCell
        // 图片组view
        // 商品图
        let imgtag = cell.imageView.tag
        self.imgtag = 100
        self.imgtag = imgtag
        self.phototag = self.imgtag
        let cell1 = indexPath.row
        print("cell1:::",cell1)
        cell.imageView.isUserInteractionEnabled = true
        cell.imageView.clipsToBounds = true
        cell.imageView.layer.cornerRadius = 5
        cell.imageView.layer.masksToBounds = true
        
        
        // 优惠价
        
        if cell.imageView.subviews.count > 0{
            price = (cell.imageView.subviews[0] as? UILabel)!
        }else {
            price = UILabel.init()
            price.backgroundColor = kLowOrangeColor
            price.textColor = .white
            price.textAlignment = .center
            price.font = FontSize(10)
            cell.imageView.addSubview(price)
            price.snp.makeConstraints { (make) in
                make.width.equalTo(kScreenW/3.76)
                make.height.equalTo(24)
                make.left.bottom.equalTo(0)
            }
        }
        if indexPath.row == 0{
            price.isHidden = false
        }else{
            price.isHidden = true
        }
        price.text = "券后:¥\(self.shotitemData?.itemendprice ?? "")"
        
        let url = self.images[indexPath.item]
        let placeholderImage = UIImage(named: "loading")
        
        cell.imageView.kf.setImage(with: URL.init(string: url), placeholder: placeholderImage)
        
        return cell
    }
   
    
    
}
