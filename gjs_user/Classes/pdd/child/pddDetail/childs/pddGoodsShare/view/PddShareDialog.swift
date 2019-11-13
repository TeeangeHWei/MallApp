//
//  ShareAlert.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/9.
//  Copyright © 2019 大杉网络. All rights reserved.
//

@available(iOS 11.0, *)
class PddShareDialog: UIView {
    
    private let shareView = UIView()
    private var viewHieght = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, itemData: PddDetailData, qrUrl: String, checkIndex: Int) {
        self.init(frame: frame)
        
        let alertBox = self
        alertBox.tag = 102
        alertBox.backgroundColor = colorwithRGBA(0, 0, 0, 0.5)
        alertBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH)
            layout.position = .relative
        }
        // 弹窗内容
        let alertContent = UIScrollView()
        alertContent.showsVerticalScrollIndicator = false
        alertContent.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - 60)
            layout.padding = 15
            layout.paddingTop = YGValue(kStatuHeight + 10)
        }
        viewHieght += 30
        alertBox.addSubview(alertContent)
        // 分享图
        shareView.clearAll2()
        shareView.backgroundColor = .white
        shareView.layer.cornerRadius = 5
        shareView.layer.masksToBounds = true
        shareView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 30)
            layout.padding = 15
        }
        alertContent.addSubview(shareView)
        // 头像
        let avatarBox = UIView()
        avatarBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.width = YGValue(kScreenW - 60)
        }
        shareView.addSubview(avatarBox)
        let avatar = UIImageView(image: UIImage(named: "avatar-default"))
        avatar.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 60
            layout.height = 60
            layout.marginRight = 10
        }
        viewHieght += 60
        avatarBox.addSubview(avatar)
        let info = UIView()
        info.configureLayout { (layout) in
            layout.isEnabled = true
            layout.justifyContent = .center
            layout.height = 60
            layout.width = YGValue(kScreenW - 130)
        }
        avatarBox.addSubview(info)
        let name = UILabel()
        name.text = "赶紧省"
        name.font = FontSize(16)
        name.textColor = kMainTextColor
        name.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginBottom = 10
        }
        info.addSubview(name)
        let slogan = UILabel()
        slogan.text = "自用省钱 分享赚钱"
        slogan.font = FontSize(14)
        slogan.configureLayout { (layout) in
            layout.isEnabled = true
        }
        info.addSubview(slogan)
        // 商品信息
        let goodsInfo = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW - 60, height: 500))
        goodsInfo.backgroundColor = .white
        goodsInfo.layer.cornerRadius = 5
        //        goodsInfo.layer.masksToBounds = true
//        goodsInfo.layer.shadowColor = colorwithRGBA(0, 0, 0, 1.0).cgColor
//        goodsInfo.layer.shadowOpacity = 0.2
//        goodsInfo.layer.shadowRadius = 3
        goodsInfo.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 60)
            layout.marginTop = 10
        }
        viewHieght += 20
        shareView.addSubview(goodsInfo)
        // 宝贝图
        let goodsImg = UIImageView()
        goodsImg.layer.cornerRadius = 5
        goodsImg.layer.masksToBounds = true
        let url = URL(string: itemData.goodsGalleryUrls![checkIndex])!
        let placeholderImage = UIImage(named: "loading")
        goodsImg.af_setImage(withURL: url, placeholderImage: placeholderImage)
        let scale = Double((goodsImg.image!.size.width))/Double(kScreenW - 60)
        let itemHeight = Double((goodsImg.image!.size.height))/scale
        goodsImg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 60)
            layout.height = YGValue(CGFloat(itemHeight))
        }
        goodsInfo.addSubview(goodsImg)
        viewHieght += Int(itemHeight)
        // 宝贝信息
        let goodsText = UIView()
        goodsText.configureLayout { (layout) in
            layout.isEnabled = true
            layout.padding = 10
            layout.paddingLeft = 20
            layout.paddingRight = 20
            layout.width = YGValue(kScreenW - 60)
        }
        goodsInfo.addSubview(goodsText)
        viewHieght += 90
        // 宝贝标题
//        let goodsTitle = UILabel()
//        goodsTitle.text = itemData.itemtitle!
//        goodsTitle.font = FontSize(14)
//        goodsTitle.textColor = kMainTextColor
//        goodsTitle.configureLayout { (layout) in
//            layout.isEnabled = true
//            layout.marginBottom = 5
//        }
//        goodsText.addSubview(goodsTitle)
        // 宝贝标题
        let goodsName =  IDLabel.init()
        goodsName.font = FontSize(14)
        goodsName.text = itemData.goodsName!
        let titleH = getLabHeigh(labelStr: itemData.goodsName!, font: FontSize(14), width: kScreenW - 100) + 2
        goodsName.numberOfLines = 0
        goodsName.id_canCopy = true
        goodsName.textColor = UIColor.black
        goodsName.id_setupAttbutImage(img: UIImage(named: "pdd-icon")!, index: 0)
        let style=NSMutableParagraphStyle.init()
        style.lineSpacing = 10
        goodsName.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 100)
            layout.height = YGValue(titleH)
        }
        goodsText.addSubview(goodsName)
        // ------价格box------
        let priceBox = UIView()
        priceBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.marginTop = 10
        }
        goodsText.addSubview(priceBox)
        // 左
        let priceLeft = UIView()
        priceLeft.configureLayout { (layout) in
            layout.isEnabled = true
        }
        priceBox.addSubview(priceLeft)
        // 原价
        let oldPrice = UILabel()
        oldPrice.text = "拼多多价：\(itemData.minGroupPrice!)元"
        oldPrice.font = FontSize(12)
        oldPrice.textColor = kGrayTextColor
        oldPrice.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginBottom = 5
        }
        priceLeft.addSubview(oldPrice)
        // 优惠券
        let coupon = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        coupon.layer.contents = UIImage(named:"recommend-2")?.cgImage
        coupon.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 100
            layout.height = 27.8
            layout.paddingLeft = 28.5
        }
        priceLeft.addSubview(coupon)
        let couponMoney = UILabel()
        couponMoney.text = "¥\(itemData.couponDiscount!)"
        couponMoney.textColor = .white
        couponMoney.textAlignment = .center
        couponMoney.font = FontSize(14)
        couponMoney.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 71.5
            layout.height = 27.8
        }
        coupon.addSubview(couponMoney)
        // ------右------
        let priceRight = UIView()
        priceRight.configureLayout { (layout) in
            layout.isEnabled = true
            layout.alignItems = .flexEnd
        }
        priceBox.addSubview(priceRight)
        // 销量
        let sales = UILabel()
        sales.text = "\(itemData.salesTip!)人已买"
        sales.font = FontSize(12)
        sales.textColor = kGrayTextColor
        sales.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginBottom = 5
        }
        priceRight.addSubview(sales)
        // 券后价
        let newPrice = UIView()
        newPrice.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.height = 27.8
        }
        priceRight.addSubview(newPrice)
        let newLabel1 = UILabel()
        newLabel1.text = "[券后价]"
        newLabel1.font = FontSize(12)
        newLabel1.textColor = kLowOrangeColor
        newLabel1.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginRight = 5
        }
        newPrice.addSubview(newLabel1)
        let newLabel2 = UILabel()
        let newPriceStr = (Commons.strToDou(itemData.minGroupPrice!) - Commons.strToDou(itemData.couponDiscount!))/100.00
        newLabel2.text = "¥\(String(format:"%.2f",newPriceStr))"
        newLabel2.font = FontSize(20)
        newLabel2.textColor = kLowOrangeColor
        newLabel2.configureLayout { (layout) in
            layout.isEnabled = true
//            layout.width = 100
        }
        newPrice.addSubview(newLabel2)
        // ---------二维码----------
        let aQrcodeBox = UIView()
        aQrcodeBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.width = YGValue(kScreenW - 60)
        }
        shareView.addSubview(aQrcodeBox)
        viewHieght += 115
        let aQrcode = UIView()
        aQrcode.backgroundColor = .white
        aQrcode.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 100
            layout.height = 100
            layout.padding = 10
            layout.marginRight = 10
        }
        aQrcodeBox.addSubview(aQrcode)
        // 生成二维码
        let aQrcodeImg = UIImageView()
        QRGenerator.setQRCodeToImageView(aQrcodeImg, qrUrl)
        aQrcodeImg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 80
            layout.height = 80
        }
        aQrcode.addSubview(aQrcodeImg)
        // 长按二维码提示
        let aQrcodeRight = UIView()
        aQrcodeRight.configureLayout { (layout) in
            layout.isEnabled = true
            layout.justifyContent = .center
            layout.height = 100
        }
        aQrcodeBox.addSubview(aQrcodeRight)
        // 邀请码
        let inviteCode = UILabel()
        inviteCode.backgroundColor = colorwithRGBA(247, 51, 47, 1)
        inviteCode.textAlignment = .center
        inviteCode.layer.cornerRadius = 3
        inviteCode.layer.masksToBounds = true
        inviteCode.text = "邀请码：\(UserDefaults.getInfo()["inviteCode"]!)"
        inviteCode.textColor = .white
        inviteCode.font = FontSize(12)
        inviteCode.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 130
            layout.height = 20
            layout.marginBottom = 5
        }
        aQrcodeRight.addSubview(inviteCode)
        let cue = UIView()
        cue.configureLayout { (layout) in
            layout.isEnabled = true
        }
        aQrcodeRight.addSubview(cue)
        let cueLabel1 = UILabel()
        cueLabel1.text = "长按识别二维码"
        cueLabel1.font = FontSize(12)
        cueLabel1.textColor = kGrayTextColor
        cueLabel1.configureLayout { (layout) in
            layout.isEnabled = true
        }
        cue.addSubview(cueLabel1)
        let cueLabel2 = UILabel()
        cueLabel2.text = "查看商品详情"
        cueLabel2.font = FontSize(12)
        cueLabel2.textColor = kGrayTextColor
        cueLabel2.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginTop = 5
        }
        cue.addSubview(cueLabel2)
        // 识别不了提醒
        let noIdentify = UIImageView(image: UIImage(named: "recommend-3"))
        noIdentify.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 30)
            layout.height = YGValue((kScreenW - 30) * 0.11)
            layout.marginLeft = -15
            layout.marginBottom = -15
        }
        shareView.addSubview(noIdentify)
        
        // 下载及分享按钮
        let alertBtns = UIView()
        alertBtns.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 60
            layout.flexDirection = .row
            layout.justifyContent = .center
            layout.alignItems = .center
        }
        alertBox.addSubview(alertBtns)
        // 下载按钮
        let downloadBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        downloadBtn.addTarget(self, action: #selector(downloadImg), for: .touchUpInside)
        downloadBtn.setTitle("下载图片", for: .normal)
        downloadBtn.titleLabel?.font = FontSize(14)
        downloadBtn.setTitleColor(.white, for: .normal)
        downloadBtn.layer.cornerRadius = 15
        downloadBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        downloadBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 100
            layout.height = 30
            layout.marginRight = 10
        }
        alertBtns.addSubview(downloadBtn)
        // 分享按钮
        let shareBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        shareBtn.addTarget(self, action: #selector(shareBox), for: .touchUpInside)
        shareBtn.setTitle("分享图片", for: .normal)
        shareBtn.titleLabel?.font = FontSize(14)
        shareBtn.setTitleColor(.white, for: .normal)
        shareBtn.layer.cornerRadius = 15
        shareBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        shareBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 100
            layout.height = 30
        }
        alertBtns.addSubview(shareBtn)
        
        // 关闭按钮
        let closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "close-danger"), for: .normal)
        closeBtn.isUserInteractionEnabled = true
        closeBtn.addTarget(self, action: #selector(closedAction), for: .touchUpInside)
        closeBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(30)
            layout.height = YGValue(30)
            layout.position = .absolute
            layout.top = YGValue(kStatuHeight + 15)
            layout.right = 15
        }
        alertBox.addSubview(closeBtn)
        
        alertContent.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(viewHieght + 100), right: CGFloat(0))
        
        alertBox.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 关闭弹窗
    @objc func closedAction(btn: UIButton) {
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.viewWithTag(102)?.removeFromSuperview()
    }
    // 下载图片到本地
    @objc func downloadImg (_ btn: UIButton) {
        let shareUIImage = getImageFromView(view: shareView)
        loadImage(image: shareUIImage)
    }
    
    func loadImage(image:UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil{
            IDToast.id_show(msg: "保存失败", success: .fail)
        }else{
            IDToast.id_show(msg: "保存成功", success: .success)
        }
    }
    // 生成二维码
    @objc func qrcode (_ btn: UIButton) {
        _ = btn.tag
        _ = UIImageView(image: UIImage(named: "logo"))
    }
    
    // 分享弹窗模块
    @objc func shareBox(){
        let shareUIImage = getImageFromView(view: shareView)
        var data = ShareSdkModel()
        data.title = "赶紧省"
        data.content = "既能省钱又能赚钱的APP"
        data.url = "https://www.ganjinsheng.com"
        data.image = shareUIImage
        data.type = .image
        let ShareBox = ShareSdkView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: UIScreen.main.bounds.size.height), data: data)
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.addSubview(ShareBox)
    }
}
