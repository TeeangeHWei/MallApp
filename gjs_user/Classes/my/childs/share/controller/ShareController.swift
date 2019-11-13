//
//  ShareController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/27.
//  Copyright © 2019 大杉网络. All rights reserved.
//

@available(iOS 11.0, *)
class ShareController : ViewController, UIGestureRecognizerDelegate {
    
    var isCancel = false
    private var collectionView:UICollectionView?
    private var layout:CollectionLayout?
    private var page = 0
    private var pageFrame = UIScreen.main.bounds.size.width - 60
    private var sectionCount = 50
    private var Qrcode:UIImage = UIImage()
    // 背景图片部分
    private var imgView:UIImageView!
    private var imgUrl = [""]
    private var shareUIImage : UIImage?
    
    let shareView = ShareView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH))
    let shareBtns = ShareBtns(frame: CGRect(x: 0, y: kScreenH - 100, width: kScreenW, height: 100))
    
    override func viewDidLoad() {
        loadData()
        navigationController?.navigationBar.isHidden = true
        let navView = customNav(titleStr: "邀请好友", titleColor: .white)
        navView.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        self.view.addSubview(navView)
        self.view.addSubview(shareView)
        self.view.addSubview(shareBtns)
        shareBtns.btnShare[0].addTarget(self, action: #selector(shareBox), for: .touchUpInside)
        shareBtns.btnShare[1].addTarget(self, action: #selector(shareBox), for: .touchUpInside)
        shareBtns.btnShare[2].addTarget(self, action: #selector(showQRCode), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }
    
    // 修改系统状态栏字颜色为白色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isCancel = false
    }
    
    private func setupUI(){
        layout = CollectionLayout()
        layout?.itemSize = CGSize(width: kScreenW - 190, height: (kScreenW - 190) / 0.5625)
        
        let rect = CGRect(x: 0, y: 155 + headerHeight, width:kScreenW, height: (kScreenW - 180) / 0.5625 + 10)
        collectionView = UICollectionView(frame: rect, collectionViewLayout: layout!)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.bounces = false
        collectionView?.register(CardCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        
        collectionView?.backgroundColor = UIColor.clear
        
        collectionView?.decelerationRate = UIScrollView.DecelerationRate.fast
        view.addSubview(collectionView!)
    }
    
    @objc private func autoNextPage(){
        guard page < sectionCount * imgUrl.count - 1 else {
            return
        }
        page += 1
        let nextPoint = CGPoint(x: CGFloat (page) * pageFrame, y: 0)
        collectionView?.setContentOffset(nextPoint, animated: true)
    }
    
    deinit {
        collectionView?.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func popSelf(){
        self.navigationController?.popViewController(animated: true)
    }
    
    // 获取数据
    func loadData() {
        AlamofireUtil.post(url: "/user/public/slideshow/getSharePoster",
        param: [:],
        success: { (res, data) in
            if self.isCancel {
                return
            }
            self.imgUrl = data.arrayObject as! [String]
            self.setupUI()
        },
        error: {},
        failure: {})
    }
    
    // 显示地推二维码
    @objc func showQRCode(){
        let alert = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: UIScreen.main.bounds.size.height))
        alert.backgroundColor = colorwithRGBA(0, 0, 0, 0.3)
        alert.tag = 100
        
        let QRBox = UIView()
        alert.addSubview(QRBox)
        QRBox.backgroundColor = .white
        QRBox.layer.cornerRadius = 10
        QRBox.layer.masksToBounds = true
        QRBox.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(240)
            make.height.equalTo(340)
        }
        let QrcodeImg = UIImageView()
        let url = AlamofireUtil.BASE_IMG_URL+"/user/appDownload?id="+(UserDefaults.getInfo()["inviteCode"] as! String)
        Qrcode = QRGenerator.setQRCodeToImageView(QrcodeImg, url)!
        QrcodeImg.contentMode = .scaleAspectFit
        QRBox.addSubview(QrcodeImg)
        QrcodeImg.snp.makeConstraints { (make) in
            make.top.left.equalTo(30)
            make.right.equalTo(-30)
            make.width.height.equalTo(180)
        }
        
        let label = UILabel()
        QRBox.addSubview(label)
        label.text = "线下地推二维码"
        label.textColor = kMainTextColor
        label.font = FontSize(16)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(QrcodeImg.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 180, height: 35))
        QRBox.addSubview(btn)
        btn.setTitle("保存二维码", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 6
        btn.titleLabel?.font = FontSize(16)
        btn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        btn.snp.makeConstraints { (make) in
            make.width.equalTo(180)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
            make.top.equalTo(label.snp.bottom).offset(10)
        }
        btn.addTarget(self, action: #selector(saveQRcode), for: .touchUpInside)
        
        let closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "share-6"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeAlert), for: .touchUpInside)
        alert.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.top.equalTo(QRBox.snp.bottom).offset(15)
        }
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.addSubview(alert)
    }
    
    // 关闭地推二维码
    @objc private func closeAlert(){
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.viewWithTag(100)?.removeFromSuperview()
    }
    
    // 保存地推二维码
    @objc private func saveQRcode(){
        UIImageWriteToSavedPhotosAlbum(Qrcode, self, #selector(saveResult(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // 保存地推二维码结果
    @objc private func saveResult(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject){
        if error != nil{
            IDToast.id_show(msg: "保存失败", success:.fail)
        }else{
            IDToast.id_show(msg: "保存成功", success:.success)
        }
    }
    
    // 分享弹窗模块
    @objc func shareBox(_ btn : UIButton){
        var type = btn.tag
        var data = ShareSdkModel()
        data.title = "赶紧省"
        data.content = "既能省钱又能赚钱的APP"
        data.url = AlamofireUtil.BASE_IMG_URL+"/user/appDownload?id="+(UserDefaults.getInfo()["inviteCode"] as! String)
        if type == 1 {
            data.type = .webPage
            data.image = UIImage(named: "logo")
        } else {
            data.type = .image
            data.image = createPoster(imgUrl[page % imgUrl.count])
        }
        let ShareBox = ShareSdkView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: UIScreen.main.bounds.size.height), data: data)
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.addSubview(ShareBox)
    }
    
    // 渲染截图选中的海报
    func createPoster (_ imgUrl : String) -> UIImage {
        let backView = UIView(frame:CGRect(x: 0, y: 0, width: 300, height: 533))
        
        backView.layer.shadowOpacity = 0.08
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize(width: 10, height: 10)
        backView.layer.shadowRadius = 3
        
        let imgView = UIImageView(frame:CGRect(x: 0, y: 0, width: 300, height: 533))
        let backUrl = URL(string: UrlFilter(imgUrl))!
        let placeholderImage = UIImage(named: "loading")
        imgView.af_setImage(withURL: backUrl, placeholderImage: placeholderImage)
        imgView.layer.cornerRadius = 10
        imgView.layer.masksToBounds = true
        backView.addSubview(imgView)
        
        let aQrcodeView = UIView(frame:CGRect(x: 300 * 0.5 - 50, y: 533 - 160, width: 100, height: 130))
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
        
        let shareUIImage = getImageFromView(view: backView)
        return shareUIImage
    }
}

// 扩展模块
@available(iOS 11.0, *)
extension ShareController:UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionCount
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgUrl.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CardCell
        let url = URL(string: UrlFilter(imgUrl[indexPath.item]))!
        print(url)
        let placeholderImage = UIImage(named: "loading")
        cell.imgView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        return cell
    }
}

@available(iOS 11.0, *)
extension ShareController:UICollectionViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x)
        print(pageFrame)
        page = Int(scrollView.contentOffset.x / (pageFrame - 90))
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //        changePageTimer?.invalidate()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

@available(iOS 11.0, *)
extension ShareController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch section {
        case 0:
            return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 20)
        case section - 1:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        }
    }
}
