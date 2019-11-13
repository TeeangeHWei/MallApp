//
//  RecommendItemView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/7.
//  Copyright © 2019 大杉网络. All rights reserved.
//
import Photos
import JXPhotoBrowser

@available(iOS 11.0, *)
class RecommendItemView: UIView {
    let isShow = UserDefaults.getIsShow()
    var articleHeight = 0
    private var copyText : String?
    private var itemData : RecommendItem?
    var nav : UINavigationController?
    var imgArr = [String]()
    
    var imgUrl = [
        "other-1",
        "other-2",
        "other-3"
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, data: RecommendItem, navC: UINavigationController) {
        self.init(frame: frame)
        nav = navC
        itemData = data
        // 单篇文章
        let article = self
        article.backgroundColor = .white
        article.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.padding = 10
            layout.paddingBottom = 20
            layout.marginBottom = 10
        }
        articleHeight += 30
        // 作者信息
        let author = UIView()
        author.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.paddingTop = 10
            layout.paddingBottom = 10
        }
        article.addSubview(author)
        articleHeight += 70
        // authorLeft
        let authorLeft = UIView()
        authorLeft.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        author.addSubview(authorLeft)
        let avatar = UIImageView(image: UIImage(named: "avatar-default"))
        avatar.layer.cornerRadius = 25
        avatar.layer.masksToBounds = true
        avatar.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.width = 50
            layout.height = 50
            layout.marginRight = 10
        }
        authorLeft.addSubview(avatar)
        let authorNameBox = UIView()
        authorNameBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.justifyContent = .center
            layout.height = 50
        }
        authorLeft.addSubview(authorNameBox)
        let authorName = UILabel()
        authorName.text = "赶紧省宣传素材"
        authorName.font = FontSize(14)
        authorName.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.marginBottom = 10
        }
        authorNameBox.addSubview(authorName)
        let releaseTime = UILabel()
        releaseTime.text = getDateFromTimeStamp10(timeStamp: data.show_time!).format("yyyy/MM/dd HH:mm:ss")
        releaseTime.font = FontSize(12)
        releaseTime.textColor = colorwithRGBA(150,150,150,1)
        releaseTime.configureLayout { (layout) in
            layout.isEnabled = true
        }
        authorNameBox.addSubview(releaseTime)
        // authorRight 按钮组
        let authorRight = UIView()
        authorRight.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        author.addSubview(authorRight)
        let copyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 24))
        copyBtn.addTarget(self, action: #selector(copyFunc), for: .touchUpInside)
        let copyColors = [colorwithRGBA(247,51,47,1).cgColor,colorwithRGBA(250,155,11,1).cgColor]
        copyBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), copyColors)
        copyBtn.layer.cornerRadius = 12
        copyBtn.layer.masksToBounds = true
        copyBtn.setTitle("复制文案", for: .normal)
        
        copyBtn.titleLabel?.textColor = .white
        copyBtn.titleLabel?.font = FontSize(12)
        copyBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 80
            layout.height = 24
            layout.marginRight = 10
        }
        
        authorRight.addSubview(copyBtn)
        let shareBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 24))
        shareBtn.addTarget(self, action: #selector(toShare), for: .touchUpInside)
        //        shareBtn.addTarget(self, action: #selector(self.toDetail), for: UIControl.Event.touchUpInside)
        shareBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), copyColors)
        shareBtn.layer.cornerRadius = 12
        shareBtn.layer.masksToBounds = true
        shareBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 80
            layout.height = 24
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.justifyContent = .center
        }
        authorRight.addSubview(shareBtn)
        let shareBtnImg = UIImageView(image: UIImage(named: "recommend-1"))
        shareBtnImg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 14
            layout.height = 14
            layout.marginRight = 5
        }
        shareBtn.addSubview(shareBtnImg)
        let shareNum = UILabel()
        shareNum.text = data.dummy_click_statistics!
        shareNum.font = FontSize(12)
        shareNum.textColor = .white
        shareNum.configureLayout { (layout) in
            layout.isEnabled = true
        }
        shareBtn.addSubview(shareNum)
        
        // 分享内容
        let shareContent = UIView()
        shareContent.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.paddingLeft = 60
        }
        article.addSubview(shareContent)
        let shareText = UILabel()
        let str = data.copy_content!.replacingOccurrences(of: "&lt;br&gt;", with: "\n")
        copyText = str
        shareText.numberOfLines = 15
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 5
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.paragraphStyle: paraph]
        shareText.attributedText = NSAttributedString(string: str, attributes: attributes)
        shareText.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 110
        }
        shareContent.addSubview(shareText)
        articleHeight += 110
//        print("文本高度:::::::::::::::::::::::::", caculateHeight(commemt: str, fontSize: CGFloat(14), showWidth: kScreenW - 80, spacing: CGFloat(5)))
        imgArr = data.itempic!
        let imgList = UIView()
        imgList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.flexWrap = .wrap
            layout.width = YGValue(kScreenW - 80)
        }
        shareContent.addSubview(imgList)
        for (index, imgStr) in imgArr.enumerated() {
            let shareImgItem = UIImageView()
            shareImgItem.tag = index
            let url = URL(string: imgStr)!
            let placeholderImage = UIImage(named: "loading")
            shareImgItem.isUserInteractionEnabled = true
            shareImgItem.af_setImage(withURL: url, placeholderImage: placeholderImage)
            shareImgItem.contentMode = .scaleAspectFill
            shareImgItem.clipsToBounds = true
            shareImgItem.layer.cornerRadius = 5
            shareImgItem.layer.masksToBounds = true
            shareImgItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue((kScreenW - 80)/3 - 10)
                layout.height = YGValue((kScreenW - 80)/3 - 10)
                layout.marginRight = YGValue(10)
                layout.marginTop = YGValue(10)
                layout.position = .relative
            }
            var tap = UITapGestureRecognizer(target: self, action: #selector(imgBrowser(sender:)))
            if index == 0 {
                tap = UITapGestureRecognizer(target: self, action: #selector(toDetail(sender:)))
                let price = UILabel()
                price.backgroundColor = kLowOrangeColor
                price.textColor = .white
                price.textAlignment = .center
                price.font = FontSize(10)
                price.text = "券后:¥\(itemData!.itemendprice!)"
                price.configureLayout { (layout) in
                    layout.isEnabled = true
                    layout.width = YGValue((kScreenW - 80)/3 - 10)
                    layout.height = 24
                    layout.position = .absolute
                    layout.bottom = 0
                    layout.left = 0
                }
                shareImgItem.addSubview(price)
            }
            shareImgItem.addGestureRecognizer(tap)
            imgList.addSubview(shareImgItem)
        }
        let count = Int(ceil(Double(imgArr.count) / 3.0))
        articleHeight += Int((kScreenW - 80)/3) * count
        // 评论
        let comment = UIView()
        comment.backgroundColor = colorwithRGBA(246,246,246,1)
        comment.layer.cornerRadius = 5
        comment.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.padding = 10
            layout.paddingLeft = 15
            layout.paddingRight = 15
            layout.marginTop = 10
            layout.marginRight = 10
        }
        shareContent.addSubview(comment)
        let commentText = UILabel()
        let commentStr = "【购买步骤】长按识别二维码-复制淘口令-点开手机【淘】领券下单"
        //        commentText.font = FontSize(14)
        commentText.numberOfLines = 2
        let commentParaph = NSMutableParagraphStyle()
        commentParaph.lineSpacing = 5
        let commentAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12),NSAttributedString.Key.paragraphStyle: commentParaph]
        commentText.attributedText = NSAttributedString(string: commentStr, attributes: commentAttributes)
        commentText.configureLayout { (layout) in
            layout.isEnabled = true
        }
        comment.addSubview(commentText)
        let commentBtn = UIView()
        commentBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .flexEnd
            layout.marginTop = 10
        }
        comment.addSubview(commentBtn)
        let commentCopy = UIButton()
        commentCopy.addTarget(self, action: #selector(copyComment), for: .touchUpInside)
        commentCopy.backgroundColor = colorwithRGBA(255,233,219,1)
        commentCopy.setTitle("复制评论", for: .normal)
        commentCopy.titleLabel?.font = FontSize(12)
        commentCopy.setTitleColor(colorwithRGBA(247,51,47,1), for: .normal)
        commentCopy.layer.cornerRadius = 12
        commentCopy.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(80)
            layout.height = YGValue(24)
        }
        commentBtn.addSubview(commentCopy)
        articleHeight += 108
        
        if isShow == 0{
            copyBtn.isHidden = true
            shareBtn.isHidden = true
        }
        article.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func copyFunc(_ btn:UIButton!){
        UIPasteboard.general.string = copyText!
        IDToast.id_show(msg: "复制成功", success: .success)
    }
    
    @objc func copyComment(_ btn:UIButton!){
        UIPasteboard.general.string = "【购买步骤】长按识别二维码-复制淘口令-点开手机【淘】领券下单"
        IDToast.id_show(msg: "复制成功", success: .success)
    }
    
    @objc func toShare(_ btn:UIButton) {
        getRatesurl()
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
            "itemid" : (itemData?.itemid!)!,
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
            "text" : itemData?.itemtitle!,
            "url" : url
        ],
        success:{(res, data) in
            let invite = UserDefaults.getInfo()["inviteCode"]!
            let qrUrl = "https://www.ganjinsheng.com/user/inviteShare?id=\((self.itemData?.itemid!)!)&invite=\(invite)&tbPwd=\(data["model"].string)"
            self.getGoodsInfo(self.itemData!.itemid!, qrUrl)
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
            let shareDialog = ShareDialog(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenW), itemData: self.itemData!, goodsData: goodsInfo, qrUrl: qrUrl, checkIndex: 0)
            self.window?.addSubview(shareDialog)
        },
        error:{
            IDLoading.id_dismissWait()
        },
        failure:{
            IDLoading.id_dismissWait()
        })
    }
    
    // 前往宝贝详情
    @objc func toDetail (sender:UITapGestureRecognizer) {
        let vc = DetailController()
        detailId = Int(itemData!.itemid!)
        nav?.pushViewController(vc, animated: true)
    }
    
    // 图片浏览器
    @objc func imgBrowser (sender:UITapGestureRecognizer) {
        let tag = sender.view?.tag
        // 网图加载器
        let loader = JXKingfisherLoader()
        // 数据源
        let dataSource = JXNetworkingDataSource(photoLoader: loader, numberOfItems: { () -> Int in
            return self.imgArr.count
        }, placeholder: { index -> UIImage? in
            return UIImage(named: "loading")
        }) { index -> String? in
            return self.imgArr[index]
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
            .show(pageIndex: tag!)
    }
}
