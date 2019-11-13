//
//  OfficialController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/21.
//  Copyright © 2019 大杉网络. All rights reserved.
//


@available(iOS 11.0, *)
class OfficialController: ViewController, UIScrollViewDelegate,UIGestureRecognizerDelegate{

    var isCancel = false
    var allHeight = 0
    private var minId = 1
    private var isLoading = false
    private var isFinish = false
    var checkBoxList = [checkBox]()
    var goodsListData = [goodsItem]()
    var checkIndexList = [Int]()
    let selected = UILabel()
    var isDestroy = false
    
    let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - 70))
    let loadingView = UIActivityIndicatorView(style: .white)
    
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }
    
    override func viewDidLoad() {
        
        getData()
        setLoading()
        view.backgroundColor = kBGGrayColor
        view.addSubview(body)
        let navView = customNav(titleStr: "官方推荐", titleColor: kMainTextColor)
        view.addSubview(navView)
        let bannerImg = UIImageView(image: UIImage(named: "official-banner"))
        bannerImg.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenW * 0.48)
        body.addSubview(bannerImg)
        allHeight += Int(kScreenW * 0.48)
        
        body.delegate = self
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight + 40), right: CGFloat(0))
        
        // 底部
        let footer = UIView(frame: CGRect(x: 0, y: kScreenH - 70, width: kScreenW, height: 70))
        footer.addBorder(side: .top, thickness: 1, color: klineColor)
        footer.backgroundColor = .white
        footer.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(70)
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        view.addSubview(footer)
        // 底部左
        let footerLeft = UIView()
        footerLeft.configureLayout { (layout) in
            layout.isEnabled = true
        }
        footer.addSubview(footerLeft)
        selected.text = "已选（0）"
        selected.font = FontSize(14)
        selected.textColor = kMainTextColor
        selected.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginBottom = 10
        }
        footerLeft.addSubview(selected)
        let cue = UILabel()
        cue.text = "单选最多可选择6个"
        cue.font = FontSize(12)
        cue.textColor = kLowGrayColor
        cue.configureLayout { (layout) in
            layout.isEnabled = true
        }
        footerLeft.addSubview(cue)
        // 底部右
        let footerRight = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        footerRight.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        footerRight.layer.cornerRadius = 3
        footerRight.layer.masksToBounds = true
        footerRight.setTitle("批量分享", for: .normal)
        footerRight.addTarget(self, action: #selector(toShare), for: .touchUpInside)
        footerRight.setTitleColor(.white, for: .normal)
        footerRight.titleLabel?.font = FontSize(14)
        footerRight.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 80
            layout.height = 30
        }
        footer.addSubview(footerRight)
        
        
        footer.yoga.applyLayout(preservingOrigin: true)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isCancel = false
    }
    
    deinit {
        isDestroy = true
    }
    

    // 获取排行列表
    func getData () {
        if isFinish {
            return
        }
        self.loadingView.frame = CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 50)
        self.loadingView.isHidden = false
        AlamofireUtil.post(url: "/product/public/ranking", param: [
            "sale_type" : "4",
            "min_id" : self.minId
        ],
        success:{(res, data) in
            if self.isCancel {
                return
            }
            print("请求返回，此时控制器已销毁：\(self.isDestroy)")
            if self.isDestroy {
                return
            }
            self.minId = data["min_id"].int!
            self.goodsListData = goodsItemDataList.deserialize(from: data.description)!.data!
            for (index, item) in self.goodsListData.enumerated() {
                // 选择框
                let checkBoxItem = CheckBoxView(frame: CGRect(x: 10, y: self.allHeight, width: 20, height: 130))
                checkBoxItem.checkBtn.tag = index
                checkBoxItem.checkBtn.addTarget(self, action: #selector(self.changeOne), for: .touchUpInside)
                self.body.addSubview(checkBoxItem)
                self.checkBoxList.append(checkBoxItem.checkBtn)
                // 宝贝卡片
                let goodsItem = OfficialGoodsItem(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW - 100), height: 130), data: item, nav: self.navigationController!)
                self.body.addSubview(goodsItem)
                self.allHeight += 130
            }
            // 没有更多了
            self.isFinish = true
            let noMore = UILabel(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 50))
            noMore.text = "没有更多了～"
            noMore.textAlignment = .center
            noMore.font = FontSize(14)
            noMore.textColor = kGrayTextColor
            self.body.addSubview(noMore)
            self.loadingView.isHidden = true
            self.isLoading = false
            self.body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(self.allHeight + 100), right: CGFloat(0))
        },
        error:{
            
        },
        failure:{
            
        })
    }
    
    // 设置loading控件
    func setLoading () {
        loadingView.isHidden = true
        loadingView.color = .darkGray
        loadingView.frame = CGRect(x: 0, y: kScreenW * 0.48, width: kScreenW, height: 50)
        loadingView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = 50
        }
        loadingView.startAnimating()
        body.addSubview(loadingView)
    }
    
    // 选中一个宝贝
    @objc func changeOne (_ btn : UIButton) {
        let tag = btn.tag
        if checkIndexList.contains(tag) {
            // 取消选中
            checkIndexList = checkIndexList.filter{$0 != tag}
        } else {
            // 最多选6个
            if checkIndexList.count >= 6 {
                IDToast.id_show(msg: "最多选6个", success: .fail)
                checkBoxList[tag].checkValue = false
                return
            }
            checkIndexList.append(tag)
        }
        selected.text = "已选（\(checkIndexList.count)）"
    }
    
    // 批量分享
    @objc func toShare (_ btn : UIButton) {
        var goodsList = [goodsItem]()
        for index in checkIndexList {
            goodsList.append(goodsListData[index])
        }
        let officialShareDialog = OfficialShareDialog(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenW), data: goodsList, nav: navigationController!)
        self.view.window?.addSubview(officialShareDialog)
    }
    
}
