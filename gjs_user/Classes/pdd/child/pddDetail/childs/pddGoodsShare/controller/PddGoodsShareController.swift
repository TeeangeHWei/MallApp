//
//  GoodsShareController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/6.
//  Copyright © 2019 大杉网络. All rights reserved.
//

@available(iOS 11.0, *)
class PddGoodsShareController: ViewController {

    var goodsInfo : PddDetailData?
    // 滚动高度
    var allHeight = 0
    // 图片列表
    let imgList = UIScrollView()
    // 图片链接数组
    var imgArr = [String]()
    // 图片选择框数组
    var checkBoxList = [checkBox]()
    // 选中的下标
    var checkIndex = 0
    // 预计奖励
    let award = UILabel()
    // 分享文案
    let descText = UILabel()
    // 优惠券链接
    var shareLink = ""
    // 分享文案字符串
    var descTextStr = ""
    // 淘口令
    var tPwd = ""
    
    override func viewDidLoad() {
        setNav()
        view.backgroundColor = .white
        let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenH, height: kScreenH))
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - headerHeight - 100)
        }
        view.addSubview(body)
        
        // 预计奖励
        let newPrice = (Commons.strToDou(goodsInfo!.minGroupPrice!) - Commons.strToDou(goodsInfo!.couponDiscount!))/100.00
        let tkmoney = newPrice * Commons.strToDou(goodsInfo!.promotionRate!)/1000.00
        let commission = tkmoney * Commons.getScale()
        award.text = "您的奖励预计为：\(String(format:"%.2f",commission))元"
        award.textAlignment = .center
        award.font = FontSize(14)
        award.backgroundColor = colorwithRGBA(254,246,240,1)
        award.textColor = colorwithRGBA(230,153,49,1)
        award.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = 36
        }
        body.addSubview(award)
        allHeight += 36
        
        // 选择图片
        let imgBox = UIView()
        imgBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.alignItems = .center
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        body.addSubview(imgBox)
        let imgTitle = UILabel()
        imgTitle.text = "选择图片"
        imgTitle.font = FontSize(14)
        imgTitle.textColor = kMainTextColor
        imgTitle.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 30)
            layout.height = 36
        }
        imgBox.addSubview(imgTitle)
        imgList.showsHorizontalScrollIndicator = false
        imgList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.width = YGValue(kScreenW - 30)
            layout.height = 100
        }
        imgBox.addSubview(imgList)
        self.imgArr = goodsInfo!.goodsGalleryUrls!
        var allLeft = 0
        for (index, item) in imgArr.enumerated() {
            let imgItem = setOneImg(item,allLeft,index)
            imgList.addSubview(imgItem)
            allLeft += 110
        }
        if checkBoxList.count > 0 {
            checkBoxList[0].checkValue = true
        }
        self.imgList.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(0), right: CGFloat(allLeft))
        // 生成海报按钮
        let posterBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        posterBtn.setTitle("生成海报", for: .normal)
        posterBtn.addTarget(self, action: #selector(poster), for: .touchUpInside)
        posterBtn.setTitleColor(.white, for: .normal)
        posterBtn.titleLabel?.font = FontSize(14)
        posterBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        posterBtn.layer.cornerRadius = 16
        posterBtn.layer.masksToBounds = true
        posterBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 100
            layout.height = 32
            layout.marginTop = 15
        }
        imgBox.addSubview(posterBtn)
        allHeight += 183
        
        // 分享文案
        let descBox = UIView()
        descBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.alignItems = .center
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        body.addSubview(descBox)
        let descTitle = UILabel()
        descTitle.text = "编辑分享文案"
        descTitle.font = FontSize(14)
        descTitle.textColor = kMainTextColor
        descTitle.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 30)
            layout.height = 36
        }
        descBox.addSubview(descTitle)
        let descTextBox = UIView()
        descTextBox.layer.cornerRadius = 5
        descTextBox.backgroundColor = colorwithRGBA(248, 245, 247, 1)
        descTextBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 30)
            layout.padding = 10
        }
        descBox.addSubview(descTextBox)
        descTextStr =  "\(goodsInfo!.goodsName!)\n【拼团价】：\(goodsInfo!.minGroupPrice!)元\n【券后价】：\(newPrice)元\n【下载赶紧省再省】\(tkmoney)元\n【下单地址】\(shareLink)"
        let textHeight = getLabHeigh(labelStr: descTextStr, font: FontSize(14), width: kScreenW - 50)
        descText.text = descTextStr
        descText.font = FontSize(14)
        descText.textColor = kMainTextColor
        descText.numberOfLines = 0
        descText.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = YGValue(textHeight)
        }
        descTextBox.addSubview(descText)
        let btnList = UIView()
        btnList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .flexEnd
            layout.marginTop = 15
        }
        descTextBox.addSubview(btnList)
        let linkCopy = UIButton()
        linkCopy.addTarget(self, action: #selector(copyLink), for: .touchUpInside)
        linkCopy.layer.borderColor = kLowOrangeColor.cgColor
        linkCopy.layer.borderWidth = 1
        linkCopy.layer.cornerRadius = 14
        linkCopy.setTitle("仅复制链接", for: .normal)
        linkCopy.setTitleColor(kLowOrangeColor, for: .normal)
        linkCopy.titleLabel?.font = FontSize(14)
        linkCopy.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .flexEnd
            layout.width = 100
            layout.height = 28
        }
        btnList.addSubview(linkCopy)
        let tklCopy = UIButton()
        tklCopy.layer.borderColor = kLowOrangeColor.cgColor
        tklCopy.layer.borderWidth = 1
        tklCopy.layer.cornerRadius = 14
        tklCopy.setTitle("仅复制淘口令", for: .normal)
        tklCopy.addTarget(self, action: #selector(copyTPwd), for: .touchUpInside)
        tklCopy.setTitleColor(kLowOrangeColor, for: .normal)
        tklCopy.titleLabel?.font = FontSize(14)
        tklCopy.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .flexEnd
            layout.width = 120
            layout.height = 28
            layout.marginLeft = 10
        }
        btnList.addSubview(tklCopy)
        let copyTextBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 32))
        copyTextBtn.setTitle("复制文案分享", for: .normal)
        copyTextBtn.addTarget(self, action: #selector(copyDescText), for: .touchUpInside)
        copyTextBtn.setTitleColor(.white, for: .normal)
        copyTextBtn.titleLabel?.font = FontSize(14)
        copyTextBtn.layer.cornerRadius = 16
        copyTextBtn.layer.masksToBounds = true
        copyTextBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        copyTextBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 120
            layout.height = 32
            layout.marginTop = 15
        }
        descBox.addSubview(copyTextBtn)
        allHeight += Int(textHeight) + 146
        
        // 分享按钮组
        let shareBtns = UIView(frame: CGRect(x: 0, y: kScreenH - headerHeight - 90, width: kScreenW, height: 100))
        shareBtns.addBorder(side: .top, thickness: 1, color: klineColor)
        shareBtns.backgroundColor = .white
        shareBtns.configureLayout { (layout) in
            layout.isEnabled = true
            layout.alignItems = .center
            layout.paddingTop = 30
        }
        view.addSubview(shareBtns)
        let shareTitle = UILabel()
        shareTitle.text = "图片分享到"
        shareTitle.font = FontSize(14)
        shareTitle.configureLayout { (layout) in
            layout.isEnabled = true
        }
        shareBtns.addSubview(shareTitle)
        let shareBtnList = UIView()
        shareBtnList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.padding = 10
        }
        shareBtns.addSubview(shareBtnList)
        let shareArr = [
            [
                "name" : "微信好友",
                "img" : "share-wechat"
            ],
            [
                "name" : "朋友圈",
                "img" : "share-friend-circle"
            ],
            [
                "name" : "微博",
                "img" : "share-sina"
            ],
            [
                "name" : "QQ",
                "img" : "share-qq"
            ],
            [
                "name" : "QQ空间",
                "img" : "share-zone"
            ]
        ]
        for (index,item) in shareArr.enumerated() {
            let shareItem = UIButton()
            shareItem.tag = index
            shareItem.addTarget(self, action: #selector(toShare), for: .touchUpInside)
            shareItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.alignItems = .center
                layout.width = YGValue((kScreenW - 20) * 0.2)
            }
            shareBtnList.addSubview(shareItem)
            let itemImg = UIImageView(image: UIImage(named: item["img"]!))
            itemImg.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = 30
                layout.height = 30
                layout.marginBottom = 8
            }
            shareItem.addSubview(itemImg)
            let itemLabel = UILabel()
            itemLabel.text = item["name"]!
            itemLabel.font = FontSize(12)
            itemLabel.configureLayout { (layout) in
                layout.isEnabled = true
            }
            shareItem.addSubview(itemLabel)
        }
        shareBtns.yoga.applyLayout(preservingOrigin: true)
        
        
        body.yoga.applyLayout(preservingOrigin: true)
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight), right: CGFloat(0))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func setNav(){
        let Nav = customNav(titleStr: "创建分享", titleColor: kMainTextColor, border: false)
        self.view.addSubview(Nav)
    }
    
    // 设置单个图片
    func setOneImg (_ url : String, _ left : Int, _ index : Int) -> UIView {
        let imgItem = UIView(frame: CGRect(x: left, y: 0, width: 100, height: 100))
        imgItem.layer.cornerRadius = 5
        imgItem.layer.masksToBounds = true
        imgItem.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 100
            layout.width = 100
            layout.marginRight = 10
            layout.position = .relative
        }
        let detailImg = UIImageView()
        detailImg.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        detailImg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 100
            layout.width = 100
        }
        let imgUrl = URL(string: url)!
        let placeholderImage = UIImage(named: "loading")
        detailImg.af_setImage(withURL: imgUrl, placeholderImage: placeholderImage)
        imgItem.addSubview(detailImg)
        let checkInput = checkBox()
        checkInput.tag = index
        checkInput.addTarget(self, action: #selector(checkOne), for: .touchUpInside)
        checkInput.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 20
            layout.width = 20
            layout.position = .absolute
            layout.top = 5
            layout.right = 5
        }
        imgItem.addSubview(checkInput)
        checkBoxList.append(checkInput)
        imgItem.yoga.applyLayout(preservingOrigin: true)
        return imgItem
    }
    
    // 获取商品详情图
    func getImgs () {
//        detailId = 596349108854
        AlamofireUtil.post(url:"/product/public/detail", param: ["itemid" : detailId!],
        success:{(res,data) in
            let goodsInfo = DetailData.deserialize(from: data["data"].description)!
            self.imgArr = goodsInfo.taobao_image!.components(separatedBy: ",")
            var allLeft = 0
            for (index, item) in self.imgArr.enumerated() {
                let imgItem = self.setOneImg(item,allLeft,index)
                self.imgList.addSubview(imgItem)
                allLeft += 110
            }
            self.imgList.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(0), right: CGFloat(allLeft))
        },
        error:{
           
        },
        failure:{
                            
        })
    }
    
    // 生成海报
    @objc func poster (_ btn : UIButton) {
        let shareDialog = PddShareDialog(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenW), itemData: self.goodsInfo!, qrUrl: shareLink, checkIndex: self.checkIndex)
        self.view.window!.addSubview(shareDialog)
    }
    
    // 复制链接
    @objc func copyLink (_ btn : UIButton) {
        UIPasteboard.general.string = shareLink
        IDToast.id_show(msg: "复制成功", success: .success)
    }
    // 复制淘口令
    @objc func copyTPwd (_ btn : UIButton) {
        UIPasteboard.general.string = tPwd
        IDToast.id_show(msg: "复制成功", success: .success)
    }
    // 复制文案
    @objc func copyDescText (_ btn : UIButton) {
        UIPasteboard.general.string = tPwd
        IDToast.id_show(msg: "复制成功", success: .success)
    }
    
    // 选中一个图片
    @objc func checkOne (_ btn : checkBox) {
        let index = btn.tag
        for item in checkBoxList {
            item.checkValue = false
        }
        checkBoxList[index].checkValue = true
        checkIndex = index
    }
    
    // 分享
    @objc func toShare (_ btn : UIButton) {
        let tag = btn.tag
        var type = "wechat"
        if tag == 1 {
            type = "friend_cricle"
        } else if tag == 2 {
            type = "sina"
        } else if tag == 3 {
            type = "qq"
        } else if tag == 4 {
            type = "zone"
        }
        let imgUrl = self.imgArr[checkIndex]
        var imgData : Data?
        do {
            imgData = try Data.init(contentsOf: URL.init(string: imgUrl)!)
        } catch {
            
        }
        let imgUI = UIImage(data: imgData!)
        var data = ShareSdkModel.init()
        data.type = .image
        data.image = imgUI
        ShareSdkView().shareByOneType(typeStr: type, data: data)
    }
}
