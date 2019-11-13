//
//  setupView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/18.
//  Copyright © 2019 大杉网络. All rights reserved.
//

@available(iOS 11.0, *)
class SetupView: ViewController, UIScrollViewDelegate {
    private var allHeight = 0
    let avatar = UIImageView(image: UIImage(named: "avatar"))
    let nicknameLabel = UILabel()
    let zfbLabel = UILabel()
    var cacheSize = "0kb"
    let clearLabel = UILabel()
    lazy var clippedImageView: UIImageView? = {
        let clippedImageView = UIImageView(frame: CGRect(x: 20, y: 300, width: 300, height: 300))
        clippedImageView.backgroundColor = .red
        return clippedImageView
    }()
    
    override func viewDidLoad() {
        let navView = customNav(titleStr: "设置", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - headerHeight))
        body.backgroundColor = kBGGrayColor
        body.addBorder(side: .top, thickness: 1, color: klineColor)
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - headerHeight)
            layout.paddingTop = 1
        }
        self.view.addSubview(body)
        
        // 列表1
        let setupList1 = setupList()
        body.addSubview(setupList1)
        // 修改头像
        let avatarLabel = UILabel()
        avatarLabel.isUserInteractionEnabled = false
        avatarLabel.text = "修改头像"
        avatarLabel.font = FontSize(14)
        avatarLabel.textColor = kGrayTextColor
        avatarLabel.configureLayout { (layout) in
            layout.isEnabled = true
        }
        let setAvatar = setupItem(isAvatar: true, "", avatarLabel)
        setAvatar.addBorder(side: .bottom, thickness: 1, color: klineColor)
        setAvatar.addTarget(self, action: #selector(cropper), for: .touchUpInside)
        setupList1.addSubview(setAvatar)
        // 昵称
        nicknameLabel.isUserInteractionEnabled = false
        nicknameLabel.text = UserDefaults.getInfo()["nickName"] as! String
        nicknameLabel.textAlignment = .right
        nicknameLabel.font = FontSize(14)
        nicknameLabel.textColor = kGrayTextColor
        nicknameLabel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.minWidth = YGValue(kScreenW * 0.4)
        }
        let setNickname = setupItem(isAvatar: false, "昵称", nicknameLabel)
        setNickname.addTarget(self, action: #selector(toNickname), for: .touchUpInside)
        setupList1.addSubview(setNickname)
        
        // 列表2
        let setupList2 = setupList()
        body.addSubview(setupList2)
        // 支付宝
        zfbLabel.isUserInteractionEnabled = false
        zfbLabel.text = UserDefaults.getInfo()["alipayAccount"] as! String
        zfbLabel.textAlignment = .right
        zfbLabel.font = FontSize(14)
        zfbLabel.textColor = kGrayTextColor
        zfbLabel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.minWidth = YGValue(kScreenW * 0.4)
        }
        let setzfb = setupItem(isAvatar: false, "绑定支付宝", zfbLabel)
        setzfb.addBorder(side: .bottom, thickness: 1, color: klineColor)
        setzfb.addTarget(self, action: #selector(toAlipay), for: .touchUpInside)
        setupList2.addSubview(setzfb)
        // 团队管理微信
        let aQrcodeLabel = UILabel()
        aQrcodeLabel.isUserInteractionEnabled = false
        aQrcodeLabel.text = "设置"
        aQrcodeLabel.textAlignment = .right
        aQrcodeLabel.font = FontSize(14)
        aQrcodeLabel.textColor = kGrayTextColor
        aQrcodeLabel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.minWidth = YGValue(kScreenW * 0.4)
        }
        let setQrcode = setupItem(isAvatar: false, "团队管理微信", aQrcodeLabel)
        setQrcode.addTarget(self, action: #selector(toWechat), for: .touchUpInside)
        if UserDefaults.getIsShow() == 1 {
            setupList2.addSubview(setQrcode)
        }
        

        // 列表3
        let setupList3 = setupList()
        body.addSubview(setupList3)
        // 密码
        let passwordLabel = UILabel()
        passwordLabel.isUserInteractionEnabled = false
        passwordLabel.text = "修改"
        passwordLabel.textAlignment = .right
        passwordLabel.font = FontSize(14)
        passwordLabel.textColor = kGrayTextColor
        passwordLabel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.minWidth = YGValue(kScreenW * 0.4)
        }
        let setPassword = setupItem(isAvatar: false, "修改密码", passwordLabel)
        setPassword.addBorder(side: .bottom, thickness: 1, color: klineColor)
        setPassword.addTarget(self, action: #selector(toPassword), for: .touchUpInside)
        setupList3.addSubview(setPassword)
        // 手机号
        let phoneLabel = UILabel()
        phoneLabel.isUserInteractionEnabled = false
        phoneLabel.text = "修改"
        phoneLabel.textAlignment = .right
        phoneLabel.font = FontSize(14)
        phoneLabel.textColor = kGrayTextColor
        phoneLabel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.minWidth = YGValue(kScreenW * 0.4)
        }
        let setPhone = setupItem(isAvatar: false, "修改手机号", phoneLabel)
        setPhone.addBorder(side: .bottom, thickness: 1, color: klineColor)
        setPhone.addTarget(self, action: #selector(toPhone), for: .touchUpInside)
        setupList3.addSubview(setPhone)
        // 清除缓存
        clearLabel.isUserInteractionEnabled = false
        clearLabel.text = cacheSize
        clearLabel.textAlignment = .right
        clearLabel.font = FontSize(14)
        clearLabel.textColor = kGrayTextColor
        clearLabel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.minWidth = YGValue(kScreenW * 0.4)
        }
        var clear = setupItem(isAvatar: false, "清除缓存", clearLabel)
        clear.addBorder(side: .bottom, thickness: 1, color: klineColor)
        clear.addTarget(self, action: #selector(clearCookie), for: .touchUpInside)
        setupList3.addSubview(clear)
        // 消息设置
        let newsLabel = UILabel()
        newsLabel.configureLayout { (layout) in
            layout.isEnabled = true
        }
        let setNews = setupItem(isAvatar: false, "消息设置", newsLabel)
        setNews.addBorder(side: .bottom, thickness: 1, color: klineColor)
        setNews.addTarget(self, action: #selector(toSetNew), for: .touchUpInside)
        setupList3.addSubview(setNews)
        // 关于
        let aboutLabel = UILabel()
        aboutLabel.configureLayout { (layout) in
            layout.isEnabled = true
        }
        let about = setupItem(isAvatar: false, "关于", aboutLabel)
        about.addTarget(self, action: #selector(toAbout), for: .touchUpInside)
        setupList3.addSubview(about)
        
        // 退出登录
        let logout = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.8, height: 40))
        logout.backgroundColor = kGrayBtnColor
        logout.setTitle("退出登录", for: .normal)
        logout.setTitleColor(kMainTextColor, for: .normal)
        logout.titleLabel?.font = FontSize(14)
        logout.layer.cornerRadius = 3
        logout.layer.masksToBounds = true
        logout.layer.shadowColor = kLowOrangeColor.cgColor
        logout.layer.shadowOpacity = 0.5
        logout.layer.shadowRadius = 3
        logout.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.8)
            layout.height = 40
            layout.marginLeft = YGValue(kScreenW * 0.1)
        }
        logout.addTarget(self, action: #selector(toLogin), for: .touchUpInside)
        body.addSubview(logout)
        
        allHeight += 60
        
        
        
        body.delegate = self
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight), right: CGFloat(0))
        body.yoga.applyLayout(preservingOrigin: true)
        
        KiClipperHelper.sharedInstance.nav = navigationController
        KiClipperHelper.sharedInstance.clippedImgSize = self.clippedImageView?.frame.size
        KiClipperHelper.sharedInstance.clippedImageHandler = {[weak self]img in
            let data = resetImgSize(sourceImage: img, maxImageLenght: 500, maxSizeKB: 100)
            let temp = UIImage(data: data)
            let imgBase64 = imageBase64(temp!)
            self?.clippedImageView?.image = temp
            self!.avatar.image = temp
//            let avatarBase64 = imageBase64(img)
            self!.avatarUpload(avatarUrl: imgBase64)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nicknameLabel.text = UserDefaults.getInfo()["nickName"] as! String
        zfbLabel.text = UserDefaults.getInfo()["alipayAccount"] as! String
        CleanTool.fileSizeOfCachingg { (size) in
            self.cacheSize = size
            self.clearLabel.text = size
//            clear = self.setupItem(isAvatar: false, "清除缓存", clearLabel)
        }
    }
    
    // 渲染单个设置列表
    func setupList () -> UIView {
        let setupList = UIView()
        setupList.backgroundColor = .white
        setupList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.width = YGValue(kScreenW)
            layout.paddingLeft = 15
            layout.marginBottom = 15
        }
        allHeight += 15
        return setupList
    }
    
    // 渲染单个设置项
    func setupItem (isAvatar: Bool, _ leftS: String, _ rightL: UILabel) -> UIButton {
        let setupItem = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW - 15, height: 50))
        setupItem.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.width = YGValue(kScreenW - 15)
            layout.height = YGValue(50)
            layout.paddingRight = 15
        }
        if isAvatar {
            let url = URL(string: UrlFilter(UserDefaults.getInfo()["headPortrait"] as! String))!
            let placeholderImage = UIImage(named: "loading")
            avatar.af_setImage(withURL: url, placeholderImage: placeholderImage)
            avatar.isUserInteractionEnabled = false
            avatar.layer.cornerRadius = 18
            avatar.layer.masksToBounds = true
            avatar.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(36)
                layout.height = YGValue(36)
            }
            setupItem.addSubview(avatar)
        } else {
            let left = UILabel()
            left.text = leftS
            left.isUserInteractionEnabled = false
            left.font = FontSize(14)
            left.configureLayout { (layout) in
                layout.isEnabled = true
            }
            setupItem.addSubview(left)
        }
        // 右
        let right = UIView()
        right.isUserInteractionEnabled = false
        right.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
        }
        setupItem.addSubview(right)
        
        right.addSubview(rightL)
        let arrow = UIImageView(image: UIImage(named: "arrow-black"))
        arrow.isUserInteractionEnabled = false
        arrow.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 16
            layout.width = 9
            layout.marginLeft = 5
        }
        right.addSubview(arrow)
        
        allHeight += 50
        
        return setupItem
    }
    
    // 修改昵称
    @objc func toNickname (_ btn: UIButton) {
        navigationController?.pushViewController(NicknameView(), animated: true)
    }
    // 绑定支付宝
    @objc func toAlipay (_ btn: UIButton) {
        navigationController?.pushViewController(AlipayView(), animated: true)
    }
    // 设置团队微信
    @objc func toWechat (_ btn: UIButton) {
        navigationController?.pushViewController(WechatView(), animated: true)
    }
    // 修改密码
    @objc func toPassword (_ btn: UIButton) {
        navigationController?.pushViewController(PasswordView(), animated: true)
    }
    // 修改手机号
    @objc func toPhone (_ btn: UIButton) {
        navigationController?.pushViewController(PhoneView(), animated: true)
    }
    // 退出登录
    @objc func toLogin (_ btn: UIButton) {
        //清除token
        UserDefaults.removeAutho()
        UserDefaults.removeInfo()
        navigationController?.pushViewController(LoginCommonViewController(), animated: true)
    }
    // 清除缓存
    @objc func clearCookie (_ btn: UIButton) {
        IDDialog.id_show(title: "", msg: "是否确定清除缓存？", leftActionTitle: "取消", rightActionTitle: "确定", leftHandler: {
            print("点击了左边")
        }) {
            CleanTool.clearCache()
            self.cacheSize = "0B"
            self.clearLabel.text = self.cacheSize
        }
    }
    // 消息设置
    @objc func toSetNew (_ btn: UIButton) {
        navigationController?.pushViewController(SetNewView(), animated: true)
    }
    // 关于
    @objc func toAbout (_ btn: UIButton) {
        navigationController?.pushViewController(AboutView(), animated: true)
    }
    
    // 裁剪头像
    @objc func cropper (_ btn: UIButton) {
        KiClipperHelper.sharedInstance.clipperType = .Move
        KiClipperHelper.sharedInstance.systemEditing = false
        KiClipperHelper.sharedInstance.isSystemType = false
        takePhoto()
    }
    
    func takePhoto() {
        
        KiClipperHelper.sharedInstance.photoWithSourceType(type: .photoLibrary) //直接打开相册选取图片
        
        //        KiClipperHelper.sharedInstance.photoWithSourceType(type: .camera) //打开相机拍摄照片
        
        //        let sheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "相册", "拍照")
        //        sheet.show(in: UIApplication.shared.keyWindow!)
    }
    
    // 上传头像
    func avatarUpload (avatarUrl : String) {
        
        AlamofireUtil.upload(url: "/user/info/updatePortrait", param: ["portrait" : avatarUrl],
        success: { data in
            IDToast.id_show(msg: "更换头像成功",success:.success)
        },
        error: {
            
        },
        failure: {
            
        })
    }
}
