//
//  wechatView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/19.
//  Copyright © 2019 大杉网络. All rights reserved.
//

class WechatView: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let uploadImg = UIImageView(image: UIImage(named: "qrcodeImg"))
    private var qrcodeImg = UIImage(named: "qrcodeImg")
    private let wechatInput = IDTextField()
    private var imgStr:String = ""
    override func viewDidLoad() {
        let navView = customNav(titleStr: "团队管理微信", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - headerHeight))
        body.backgroundColor = kBGGrayColor
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - headerHeight)
        }
        self.view.addSubview(body)
        
        // 表单
        let formList = UIView()
        formList.backgroundColor = .white
        formList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
        }
        body.addSubview(formList)
        // 上传微信二维码
        let info = UserDefaults.getInfo() as! [String:String]
        let imgUrl = "\(AlamofireUtil.BASE_IMG_URL)\(info["wechatQrcode"]!)"
        let url = URL.init(string: imgUrl)!
        let placeholderImage = UIImage(named: "loading")
        self.uploadImg.af_setImage(withURL: url, placeholderImage: placeholderImage)
        let aQrcode = UIView()
        aQrcode.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.paddingTop = 20
            layout.paddingBottom = 20
        }
        formList.addSubview(aQrcode)
        let upload = UIButton()
        upload.addTarget(self, action: #selector(uploadImgFunc), for: .touchUpInside)
        upload.backgroundColor = kBGGrayColor
        upload.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 100
            layout.height = 100
        }
        aQrcode.addSubview(upload)
        
        uploadImg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 70
            layout.height = 70
            layout.marginTop = 15
            layout.marginLeft = 15
        }
        upload.addSubview(uploadImg)
        let aQrcodeText = UILabel()
        aQrcodeText.text = "点击上传二维码"
        aQrcodeText.font = FontSize(14)
        aQrcodeText.textColor = kGrayTextColor
        aQrcodeText.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginTop = 10
        }
        aQrcode.addSubview(aQrcodeText)
        // 微信号
        let wechatNum = UIView()
        wechatNum.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.height = 46
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        formList.addSubview(wechatNum)
        let wechatKey = UILabel()
        wechatKey.text = "微信号"
        wechatKey.font = FontSize(14)
        wechatKey.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue((kScreenW - 30) * 0.25)
        }
        wechatNum.addSubview(wechatKey)
        
        wechatInput.text = UserDefaults.getInfo()["wechatNum"] as! String
        wechatInput.font = FontSize(14)
        wechatInput.placeholder = "请输入微信号"
        wechatInput.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue((kScreenW - 30) * 0.75)
        }
        wechatNum.addSubview(wechatInput)
        
        // 温馨提示
        let cue = UILabel()
        cue.numberOfLines = 5
        cue.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 30)
            layout.marginLeft = 15
            layout.marginTop = 10
        }
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 5
        let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : kMainTextColor, NSAttributedString.Key.paragraphStyle: paraph]
        let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : kGrayTextColor, NSAttributedString.Key.paragraphStyle: paraph]
        let attributedString1 = NSMutableAttributedString(string:"温馨提示：", attributes:attrs1)
        let str2 = "上传的微信将会s展示给您所属团队队员。如因此涉及个人隐私，可选暂不上传微信。如已上传的用户可选择删除微信，微信将不再对团队队员开放。"
        let attributedString2 = NSMutableAttributedString(string: str2, attributes:attrs2)
        attributedString1.append(attributedString2)
        cue.attributedText = attributedString1
        body.addSubview(cue)
        
        // -------- 提交按钮 --------
        let submitBtn = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.8, height: 40))
        submitBtn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        submitBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        submitBtn.setTitle("提交", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.titleLabel?.font = FontSize(14)
        submitBtn.layer.cornerRadius = 3
        submitBtn.layer.masksToBounds = true
        submitBtn.layer.shadowColor = kLowOrangeColor.cgColor
        submitBtn.layer.shadowOpacity = 0.5
        submitBtn.layer.shadowRadius = 3
        submitBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.8)
            layout.height = 40
            layout.marginTop = 20
            layout.marginLeft = YGValue(kScreenW * 0.1)
        }
        body.addSubview(submitBtn)
        
        body.yoga.applyLayout(preservingOrigin: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // 创建UIImagePickerController对象,设置数据源和代理,跳转到图片选择控制器
    func imageFormPhotosAlbum(){
        let picker = UIImagePickerController()
        //设置代理
        picker.delegate = self
        //设置数据源(从相册或者相机)
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    // 监听选择完照片后返回照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 根据UIImagePickerControllerOriginalImage从info里边取值
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let data = resetImgSize(sourceImage: image, maxImageLenght: 500, maxSizeKB: 100)
        let temp = UIImage(data: data)
        qrcodeImg = temp
        uploadImg.image = temp
        imgStr = imageBase64(temp!)
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func uploadImgFunc (_ btn: UIButton) {
        imageFormPhotosAlbum()
    }
    
    // 上传接口 https://www.ganjinsheng.com/api/user/info/teamWechat
    @objc func submit (_ btn: UIButton) {
        if(wechatInput.text! == ""){
            IDToast.id_show(msg: "请填写微信号",success:.fail)
            return
        }
        AlamofireUtil.upload(url: "/user/info/teamWechat",
        param: [
            "qrCode": imgStr.description,
            "wechatNum": wechatInput.text!
        ],
        success: { (data) in
            IDToast.id_show(msg: "绑定成功",success:.success)
            self.navigationController?.popViewController(animated: true)
        },
        error: {},
        failure: {})
    }
    
    // 获取数据
    func getData () {
        
    }
}
