//
//  myFansView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/16.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class MyFansView: ViewController, UIScrollViewDelegate {
    private var allHeight = 0
    private let body = UIScrollView(frame: CGRect(x: 10, y: headerHeight + 156, width: kScreenW - 20, height: (kScreenH - headerHeight - 156 - 46)))
    private var typeArr = [UIButton]()
    private let layer = CALayer()
    private let footer = UILabel(frame: CGRect(x: 0, y: kScreenH - 46, width: kScreenW, height: 46))
    private let noFans = UIView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW - 20, height: 200))
    private let loading = UIActivityIndicatorView(style: .white)
    private let endStr = UILabel()
    private var wechatNum:String = "未填写"
    
    //上级
    let superiorAvatar = UIImageView(image:UIImage(named: "loading"))
    private let superiorName = UILabel()
    private let superiorWechat = UILabel()
    
    //粉丝列表
    private var dataList:[FansModel] = [FansModel]()
    
    private var level = 1
    private var pageNo = 1
    private var pages = 2
    private var pageSize = 10
    
    // MARK: - 动画结束时调用
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(CGFloat(allHeight) <= scrollView.contentOffset.y + scrollView.frame.height){
            if(pageNo <= pages){
                loadFanList()
            }else{
                noMore()
            }
        }
    }
    
    override func viewDidLoad() {
        let navView = customNav(titleStr: "我的粉丝", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        self.view.backgroundColor = kBGGrayColor
        let superior = UIView(frame: CGRect(x: 10, y: headerHeight + 15, width: kScreenW - 20, height: 80))
        superior.backgroundColor = .white
        superior.layer.cornerRadius = 5
        superior.layer.masksToBounds = true
        
        let superiorLeft = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW - 120, height: 80))
        superiorAvatar.frame = CGRect(x: 15, y: 10, width: 60, height: 60)
        superiorAvatar.layer.cornerRadius = 30
        superiorAvatar.layer.masksToBounds = true
        superiorName.frame = CGRect(x: 90, y: 15, width: kScreenW - 210, height: 25)
        superiorName.font = FontSize(14)
        superiorName.text = "团队长：官方"
        superiorWechat.frame = CGRect(x: 90, y: 40, width: kScreenW - 210, height: 25)
        superiorWechat.text = "微信号：未填写"
        superiorWechat.font = FontSize(14)
        superiorLeft.addSubview(superiorAvatar)
        superiorLeft.addSubview(superiorName)
        superiorLeft.addSubview(superiorWechat)
        
        let superiorRight = UIButton(frame: CGRect(x: kScreenW - 90, y: 25, width: 60, height: 30))
        superiorRight.addTarget(self, action: #selector(wishSeed), for: UIControl.Event.touchUpInside)
        superiorRight.setTitle("复制", for: .normal)
        superiorRight.setTitleColor(kLowOrangeColor, for: .normal)
        superiorRight.titleLabel?.textColor = kLowOrangeColor
        superiorRight.titleLabel?.font = FontSize(14)
        superiorRight.layer.borderWidth = 1
        superiorRight.layer.borderColor = kLowOrangeColor.cgColor
        superiorRight.layer.cornerRadius = 3
        
        superior.addSubview(superiorLeft)
        superior.addSubview(superiorRight)
        
        // -------- 粉丝类型 ---------
        let typeList = UIView(frame: CGRect(x: 10, y: headerHeight + 110, width: kScreenW - 20, height: 46))
        typeList.backgroundColor = .white
        typeList.layer.masksToBounds = true
        typeList.layer.mask = typeList.configRectCorner(view: typeList, corner: [.topLeft, .topRight], radii: CGSize(width: 5, height: 5))
        typeList.addBorder(side: .bottom, thickness: 1, color: klineColor)
        for index in 0...1 {
            let typeItem = UIButton(frame: CGRect(x: CGFloat(index) * kScreenW/2, y: 0, width: (kScreenW - 20)/2, height: 46))
            typeItem.tag = index
            typeItem.addTarget(self, action: #selector(typeChange), for: .touchUpInside)
            if index == 0 {
                typeItem.setTitle("直属粉丝", for: .normal)
                typeItem.setTitleColor(kLowOrangeColor, for: .normal)
            } else {
                typeItem.setTitle("推荐粉丝", for: .normal)
                typeItem.setTitleColor(kMainTextColor, for: .normal)
            }
            typeItem.titleLabel?.font = FontSize(14)
            typeList.addSubview(typeItem)
            typeArr.append(typeItem)
        }
        //类型下划线
        let width = (kScreenW - 20)/2
        layer.frame = CGRect(x: 0, y: 42, width: width, height: 4)
        layer.cornerRadius = 2
        layer.backgroundColor = kLowOrangeColor.cgColor
        typeList.layer.addSublayer(layer)
        
        //底部显示
        footer.text = "直属粉丝：0位"
        footer.font = FontSize(14)
        footer.textColor = .white
        footer.backgroundColor = kLowOrangeColor
        footer.textAlignment = .center
        
        //粉丝列表
        body.backgroundColor = .white
        body.delegate = self
        body.showsVerticalScrollIndicator = false
        
        self.view.addSubview(superior)
        self.view.addSubview(typeList)
        self.view.addSubview(body)
        self.view.addSubview(footer)
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight), right: CGFloat(0))
        
        loadTutor()
        loadFanList()
    }
    
    // 切换粉丝列表
    @objc func typeChange (btn: UIButton) {
        if btn.tag == 0 {
            typeArr[0].setTitleColor(kLowOrangeColor, for: .normal)
            typeArr[1].setTitleColor(kMainTextColor, for: .normal)
            level = 1
        } else {
            typeArr[0].setTitleColor(kMainTextColor, for: .normal)
            typeArr[1].setTitleColor(kLowOrangeColor, for: .normal)
            level = 2
        }
        UIView.animate(withDuration: 0.3) {
            self.layer.frame.origin.x = (kScreenW - 20)/2 * CGFloat(btn.tag)
        }
        //清空body
        body.subviews.forEach{$0.removeFromSuperview()}
        allHeight = 0
        pages = 2
        pageNo = 1
        loadFanList()
    }
    
    //没有粉丝
    func setNoFans(){
        let imgHeight = (kScreenW - 20) * 0.8 * 0.28
        let noFansImg = UIImageView(image: UIImage(named: "noFans"))
        noFansImg.frame = CGRect(x: (kScreenW - (kScreenW - 20) * 0.8)/2, y: 10, width: (kScreenW - 20) * 0.8, height: imgHeight)
        noFansImg.contentMode = .scaleAspectFit
        allHeight += Int(imgHeight)
        noFans.addSubview(noFansImg)
        let noFansText1 = UILabel(frame: CGRect(x: 0, y: imgHeight + 20, width: kScreenW - 20, height: 20))
        noFansText1.text = "还没有粉丝呢，快邀请好友使用赶紧省吧！"
        noFansText1.font = FontSize(12)
        noFansText1.textColor = kGrayTextColor
        noFansText1.textAlignment = .center
        noFans.addSubview(noFansText1)
        let noFansText2 = UILabel(frame: CGRect(x: 0, y: imgHeight + 50, width: kScreenW - 20, height: 20))
        noFansText2.text = "好友下单，你也有机会获取佣金哦"
        noFansText2.font = FontSize(12)
        noFansText2.textColor = kGrayTextColor
        noFansText2.textAlignment = .center
        noFans.addSubview(noFansText2)
        allHeight += 60
        let toShare = UIButton(frame: CGRect(x: (kScreenW - 120)/2, y: imgHeight + 80, width: 120, height: 36))
        toShare.setTitle("立即邀请", for: .normal)
        toShare.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        toShare.addTarget(self, action: #selector(toSharePage), for: .touchUpInside)
        toShare.setTitleColor(.white, for: .normal)
        toShare.layer.cornerRadius = 18
        toShare.layer.masksToBounds = true
        toShare.titleLabel?.font = FontSize(14)
        noFans.addSubview(toShare)
        allHeight += 66
        body.addSubview(noFans)
        body.contentInset = UIEdgeInsets(top: 0, left: CGFloat(0), bottom: CGFloat(self.allHeight), right: CGFloat(0))
        pageNo = pages
    }
    
    //加载中
    func setLoading(){
        loading.frame = CGRect(x: 0, y: allHeight, width: Int(kScreenW - 20), height: 50)
        loading.isHidden = false
        loading.color = .darkGray
        loading.hidesWhenStopped = true
        loading.startAnimating()
        body.addSubview(loading)
        body.contentInset = UIEdgeInsets(top: 0, left: CGFloat(0), bottom: CGFloat(self.allHeight + 50), right: CGFloat(0))
    }
    
    //没有更多信息
    func noMore(){
        endStr.text = "没有更多了～"
        endStr.textColor = kGrayTextColor
        endStr.font = FontSize(14)
        endStr.textAlignment = .center
        endStr.frame = CGRect(x: 0, y: allHeight, width: Int(kScreenW), height: 40)
        body.contentInset = UIEdgeInsets(top: 0, left: CGFloat(0), bottom: CGFloat(self.allHeight + 40), right: CGFloat(0))
        body.addSubview(endStr)
    }
    
    // 设置单个下级粉丝
    func setItem (data:FansInfo) {
        let fansItem = UIButton(frame: CGRect(x: 0, y: allHeight, width: Int(kScreenW - 20), height: 70))
        fansItem.tag = Int(data.id!)!
        fansItem.addTarget(self, action: #selector(loadFansDetail), for: .touchUpInside)
        let itemLeft = UIView()
        fansItem.addSubview(itemLeft)
        // 头像
        let itemAvatar = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        let url = URL(string: UrlFilter(data.headPortrait!))!
        let placeholderImage = UIImage(named: "loading")
        itemAvatar.af_setImage(withURL: url, placeholderImage: placeholderImage)
        itemAvatar.layer.cornerRadius = 25
        itemAvatar.layer.masksToBounds = true
        itemLeft.addSubview(itemAvatar)
        
        // 用户信息
        let name = UILabel(frame: CGRect(x: 70, y: 15, width: 70, height: 25))
        name.text = data.nickName
        name.font = FontSize(14)
        let member = UIImageView(image: UIImage(named: "grade-1"))
        member.frame = CGRect(x: 145, y: 15, width: 70, height: 25)
        member.contentMode = .scaleAspectFit
        let time = UILabel(frame: CGRect(x: 70, y: 40, width: 150, height: 20))
        let createTime = getDateFromTimeStamp(timeStamp: data.createTime!)
        time.text = createTime.format("yyyy/MM/dd HH:mm:ss")
        time.font = FontSize(12)
        time.textColor = kGrayTextColor
        fansItem.addSubview(name)
        fansItem.addSubview(member)
        fansItem.addSubview(time)
        
        // 粉丝数
        let itemRight = UIView(frame: CGRect(x: kScreenW - 140, y: 0, width: 120, height: 70))
        itemRight.isUserInteractionEnabled = false
       
        fansItem.addSubview(itemRight)
        let fansNum = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 70))
        fansNum.text = "粉丝数：" + data.fansNums!
        fansNum.font = FontSize(14)
        fansNum.textAlignment = .right
        itemRight.addSubview(fansNum)
        let arrow = UIImageView(image: UIImage(named: "arrow-black"))
        arrow.frame = CGRect(x: 96, y: 0, width: 9, height: 70)
        arrow.contentMode = .scaleAspectFit
        itemRight.addSubview(arrow)
        body.addSubview(fansItem)
        allHeight += 70
    }
    
    func setAlert(info:FansInfo,wallet:FansWallet){
        wechatNum = info.wechatNum!
        let alert = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: UIScreen.main.bounds.size.height))
        alert.backgroundColor = colorwithRGBA(0, 0, 0, 0.3)
        alert.configureLayout { (layout) in
            layout.isEnabled = true
            layout.justifyContent = .center
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(UIScreen.main.bounds.size.height)
        }
        let alertMain = UIView()
        alertMain.backgroundColor = .white
        alertMain.layer.masksToBounds = true
        alertMain.layer.cornerRadius = 10
        alertMain.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.8)
            layout.position = .relative
            layout.paddingBottom = 20
        }
        alert.addSubview(alertMain)
        // 粉丝信息
        let fansInfo = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.8, height: 150))
        fansInfo.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        fansInfo.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.justifyContent = .center
            layout.width = YGValue(kScreenW * 0.8)
            layout.height = 150
        }
        alertMain.addSubview(fansInfo)
        // 头像及昵称
        let avatarBox = UIView()
        avatarBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.justifyContent = .center
        }
        fansInfo.addSubview(avatarBox)
        // 头像
        let avatar = UIImageView()
        let url = URL(string: UrlFilter(info.headPortrait!))!
        let placeholderImage = UIImage(named: "loading")
        avatar.af_setImage(withURL: url, placeholderImage: placeholderImage)
        avatar.layer.cornerRadius = 30
        avatar.layer.masksToBounds = true
        avatar.layer.borderWidth = 2
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.width = YGValue(60)
            layout.height = YGValue(60)
            layout.marginRight = 10
        }
        avatarBox.addSubview(avatar)
        let name = UIView()
        name.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
        }
        avatarBox.addSubview(name)
        let nickname = UILabel()
        nickname.text = info.nickName!
        nickname.font = FontSize(16)
        nickname.textColor = .white
        nickname.configureLayout { (layout) in
            layout.isEnabled = true
        }
        name.addSubview(nickname)
        let member = UIImageView(image: UIImage(named: "grade-1"))
        member.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 16
            layout.width = 64
            layout.marginTop = 10
        }
        name.addSubview(member)
        // 邀请码
        let invite = UIView()
        invite.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.marginTop = 20
        }
        fansInfo.addSubview(invite)
        let inviteCode = UILabel()
        inviteCode.text = "微信号：" + info.wechatNum!
        inviteCode.font = FontSize(16)
        inviteCode.textColor = .white
        inviteCode.configureLayout { (layout) in
            layout.isEnabled = true
        }
        invite.addSubview(inviteCode)
        let inviteBtn = UIButton()
        inviteBtn.backgroundColor = .white
        inviteBtn.layer.cornerRadius = 3
        inviteBtn.setTitle("复制", for: .normal)
        inviteBtn.addTarget(self, action: #selector(copyWechat), for: .touchUpInside)
        inviteBtn.setTitleColor(colorwithRGBA(247, 106, 22, 1), for: .normal)
        inviteBtn.titleLabel?.font = FontSize(14)
        inviteBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 50
            layout.height = 24
            layout.marginLeft = 5
        }
        invite.addSubview(inviteBtn)
        
        // 粉丝数
        let fansNum = UIView()
        fansNum.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.marginTop = 20
        }
        alertMain.addSubview(fansNum)
        let num = UILabel()
        num.text = info.fansNums!
        num.font = FontSize(24)
        num.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginBottom = 8
        }
        fansNum.addSubview(num)
        let fansNumKey = UILabel()
        fansNumKey.text = "粉丝数"
        fansNumKey.font = FontSize(14)
        fansNumKey.textColor = kGrayTextColor
        fansNumKey.configureLayout { (layout) in
            layout.isEnabled = true
        }
        fansNum.addSubview(fansNumKey)
        
        // 预估收入
        let income = UIView()
        income.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.marginTop = 20
        }
        alertMain.addSubview(income)
        // 上月预估收入
        let lastMouth = UIView()
        lastMouth.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.width = YGValue((kScreenW * 0.8)/2)
        }
        income.addSubview(lastMouth)
        let lastMouthNum = UILabel()
        lastMouthNum.text = wallet.lastMouthConsume!
        lastMouthNum.font = FontSize(20)
        lastMouthNum.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginBottom = 8
        }
        lastMouth.addSubview(lastMouthNum)
        let lastMouthKey = UILabel()
        lastMouthKey.text = "上月预估收入"
        lastMouthKey.font = FontSize(14)
        lastMouthKey.textColor = kGrayTextColor
        lastMouthKey.configureLayout { (layout) in
            layout.isEnabled = true
        }
        lastMouth.addSubview(lastMouthKey)
        // 中间分割线
        let centerLine = UIView()
        centerLine.backgroundColor = klineColor
        centerLine.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 40
            layout.width = 1
        }
        income.addSubview(centerLine)
        // 累积收益
        let total = UIView()
        total.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.width = YGValue((kScreenW * 0.8)/2)
        }
        income.addSubview(total)
        let totalNum = UILabel()
        totalNum.text = wallet.balance!
        totalNum.font = FontSize(20)
        totalNum.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginBottom = 8
        }
        total.addSubview(totalNum)
        let totalKey = UILabel()
        totalKey.text = "累计收益"
        totalKey.font = FontSize(14)
        totalKey.textColor = kGrayTextColor
        totalKey.configureLayout { (layout) in
            layout.isEnabled = true
        }
        total.addSubview(totalKey)
        // 注册时间
        let createTime = UILabel()
        let time = getDateFromTimeStamp(timeStamp: info.createTime!)
        createTime.text = "注册时间：" + time.format("yyyy/MM/dd HH:mm:ss")
        createTime.font = FontSize(12)
        createTime.textColor = kGrayTextColor
        createTime.textAlignment = .center
        createTime.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginTop = 20
        }
        alertMain.addSubview(createTime)
        
        // 关闭按钮
        let closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closedAction), for: .touchUpInside)
        closeBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 14
            layout.height = 14
            layout.position = .absolute
            layout.top = 15
            layout.right = 15
        }
        alertMain.addSubview(closeBtn)
        alert.yoga.applyLayout(preservingOrigin: true)
        
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        alert.tag = 101
        delegate.window?.addSubview(alert)
    }

    // 关闭弹窗
    @objc func closedAction() {
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.viewWithTag(101)?.removeFromSuperview()
    }
    
    //复制下级微信
    @objc func copyWechat(_ sender:UIButton!){
        if(wechatNum != "未填写"){
            UIPasteboard.general.string = wechatNum
            IDToast.id_show(msg: "复制成功", success: .success)
        }
    }
    
    // 复制上级微信
    @objc func wishSeed(_ sender:UIButton!){
        UIPasteboard.general.string = superiorWechat.text!.id_subString(from: 4, offSet: superiorWechat.text!.count)
        IDToast.id_show(msg: "复制成功", success: .success)
    }
    
    //上级信息
    func loadTutor() {
        AlamofireUtil.post(url: "/user/invite/tutor",
        param: [:],
        success: { (res, data) in
            let superInfo = FansInfo.deserialize(from: data.description)!
            let url = URL(string: UrlFilter(superInfo.headPortrait!))!
            let placeholderImage = UIImage(named: "loading")
            self.superiorAvatar.af_setImage(withURL: url, placeholderImage: placeholderImage)
            self.superiorName.text = "团队长：" + superInfo.nickName!
            self.superiorWechat.text = "微信号：" + superInfo.wechatNum!
        },
        error: {},
        failure: {})
    }
    
    //粉丝列表
    func loadFanList(){
        if(pageNo > pages){
            return
        }
        setLoading()
        AlamofireUtil.post(url: "/user/invite/myFans",
        param: [
            "level":level,
            "pageNo":pageNo,
            "pageSize":pageSize
        ],
        success: { (res, data) in
            self.loading.stopAnimating()
            self.pages = Int(data["pages"].description)!
            if(self.level == 1){
                self.footer.text = "直属粉丝：" + data["total"].description + " 位"
            }else{
                self.footer.text = "间接粉丝：" + data["total"].description + " 位"
            }
            self.dataList = [FansModel].deserialize(from: data["list"].description) as! [FansModel]
            if(self.dataList.count > 0){
                for item in self.dataList {
                    self.setItem(data: item.userInfo!)
                }
                self.body.contentInset = UIEdgeInsets(top: 0, left: CGFloat(0), bottom: CGFloat(self.allHeight), right: CGFloat(0))
            }
            if(Int(data["total"].description)! <= 0){
                self.setNoFans()
                return
            }else if(Int(data["total"].description)! < self.pageSize){
                self.noMore()
            }
            self.pageNo += 1
        },
        error: {},
        failure: {})
    }
    
    //粉丝详情
    @objc func loadFansDetail(_ btn: UIButton){
        AlamofireUtil.post(url: "/user/invite/selectMyFansDetail",
        param: [
            "myFansId": btn.tag
        ],
        success: { (res, data) in
            let info = FansInfo.deserialize(from: data["userInfo"].description)!
            let wallet = FansWallet.deserialize(from: data["userWallet"].description)!
            self.setAlert(info: info, wallet: wallet)
        },
        error: {},
        failure: {})
    }
    
    // 邀请好友
    @objc func toSharePage (_ btn : UIButton) {
        navigationController?.pushViewController(ShareController(), animated: true)
    }
}
