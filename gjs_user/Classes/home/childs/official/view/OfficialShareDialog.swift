//
//  OfficialShareDialog.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/21.
//  Copyright © 2019 大杉网络. All rights reserved.
//


@available(iOS 11.0, *)
class OfficialShareDialog: UIView {
    
    private let shareView = UIView(frame: CGRect(x: 0, y: -headerHeight, width: kScreenW, height: kScreenH))
    private var viewHieght = 0
    private var ratesurl : String?
    private var taobaoPwd : String?
    private var navC : UINavigationController?
    private var qrUrl = "https://www.ganjinsheng.com/user/shareGoods?id="
//        https://www.ganjinsheng.com/user/shareGoods?id=577883800953,40898970290&invite=125801
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, data: [goodsItem], nav: UINavigationController) {
        
        self.init(frame: frame)
        self.navC = nav
        
        let alertBox = self
        alertBox.tag = 103
        alertBox.backgroundColor = colorwithRGBA(0, 0, 0, 0.5)
        alertBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH)
            layout.marginTop = YGValue(-headerHeight)
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
        shareView.backgroundColor = kBGGrayColor
        shareView.layer.cornerRadius = 5
        shareView.layer.masksToBounds = true
        shareView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 30)
        }
        alertContent.addSubview(shareView)
        // 宝贝列表
        let goodsList = UIView()
        goodsList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 30)
            layout.padding = 15
            layout.paddingBottom = 5
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.flexWrap = .wrap
        }
        shareView.addSubview(goodsList)
        for (index, item) in data.enumerated() {
            let goodsItem = ShareGoodsItem(frame: CGRect(x: 0, y: 0, width: (kScreenW - 70)/2, height: 150), data: item, nav: navC!)
            goodsList.addSubview(goodsItem)
            if index == data.count - 1 {
                qrUrl += "\(item.itemid!)&invite=\(UserDefaults.getInfo()["inviteCode"]!)"
            } else {
                qrUrl += "\(item.itemid!),"
            }
        }
        let count = Int(ceil(Double(data.count) / 2.0))
        viewHieght += count * Int((kScreenW - 70)/2 + 62)
        
        // 分享图底部
        let shareBottom = UIView()
        shareBottom.backgroundColor = .white
        shareBottom.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.justifyContent = .spaceBetween
            layout.width = YGValue(kScreenW - 30)
            layout.height = 140
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        shareView.addSubview(shareBottom)
        // logo
        let logo = UIImageView(image: UIImage(named: "logo-long"))
        logo.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 90
            layout.height = 26.2
        }
        shareBottom.addSubview(logo)
        // 二维码
        let aQrcodeBox = UIView()
        aQrcodeBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        shareBottom.addSubview(aQrcodeBox)
        let aQrcodeText = UILabel()
        aQrcodeText.text = "扫码逛一逛"
        aQrcodeText.font = FontSize(14)
        aQrcodeText.textColor = kMainTextColor
        aQrcodeText.configureLayout { (layout) in
            layout.isEnabled = true
        }
        aQrcodeBox.addSubview(aQrcodeText)
        viewHieght += 130
        let aQrcode = UIView()
        aQrcode.backgroundColor = .white
        aQrcode.layer.cornerRadius = 5
        aQrcode.layer.shadowColor = colorwithRGBA(0, 0, 0, 1.0).cgColor
        aQrcode.layer.shadowRadius = 3
        aQrcode.layer.shadowOpacity = 0.2
        aQrcode.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 100
            layout.height = 100
            layout.padding = 10
            layout.marginLeft = 10
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
        delegate.window?.viewWithTag(103)?.removeFromSuperview()
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
    @objc func aQrcode (_ btn: UIButton) {
        _ = btn.tag
        _ = UIImageView(image: UIImage(named: "logo"))
    }
    
    // 分享图片
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
