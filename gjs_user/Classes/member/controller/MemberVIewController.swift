//
//  MemberController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/13.
//  Copyright © 2019 大杉网络. All rights reserved.
//


@available(iOS 11.0, *)
class MemberViewController: ViewController, UIScrollViewDelegate {
    
    var isCancel = false
    var navTopView : UIView!
    var navBar = UINavigationBar(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight))
    var navItem = UINavigationItem()
    
    private let body:UIScrollView = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - headerHeight + 10))
    private var allHeight:CGFloat = 20
    // 顶部图片高度
    let headerBgHeight:CGFloat = (903/1080) * kScreenW
    // 头部信息
    private var headerBox:UIView!
    // 会员等级
    private let memberStatus = UserDefaults.getInfo()["memberStatus"] as! String

    // 当前特权部分
    private var currentBox:UIView!
    private var currentItemBox:UIView!
    private var currentItemHeight:CGFloat = 0
    private var currentLabel = [UILabel]()
    private var currentType = 1
    let memberProfit = [
        ["key":"1","val":"超级会员","profitSelf":"100%","profitShare":"100%","profitDirect":"16.7%"],
        ["key":"2","val":"团长","profitSelf":"133.33%","profitShare":"133.33%","profitDirect":"33.3%","profitInDirect":"16.7%"],
        ["key":"3","val":"合作伙伴","profitSelf":"150%","profitShare":"150%","profitDirect":"50%","profitInDirect":"16.7%"]
    ]
    
    // 滚动监听
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let titlelabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        titlelabel.text = "会员特权"
        titlelabel.textColor = kMainTextColor
        navItem.titleView = titlelabel
        if scrollView.contentOffset.y <= 0 {
            var offset = scrollView.contentOffset
            offset.y = 0
            scrollView.contentOffset = offset
        }
        if scrollView.contentOffset.y > 10 {
            navBar.apply(gradient: [colorwithRGBA(255,231,196, 1), colorwithRGBA(255,202,122, 1)])
        }else {
            navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navBar.backgroundColor = .clear
        }
    }
    
    // 设置导航栏
    func navSetting(){
//        setNav(titleStr: "会员特权", titleColor: kMainTextColor, navItem: navigationItem, navController: navigationController)
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.isNavigationBarHidden = true
        navTopView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: headerHeight))
        navTopView.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), [colorwithRGBA(255,231,196, 1).cgColor, colorwithRGBA(255,202,122, 1).cgColor])
        navBar.backgroundColor = .clear
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.apply(gradient: [colorwithRGBA(255,231,196, 1), colorwithRGBA(255,202,122, 1)])
        let backBtn = UIBarButtonItem(image: UIImage(named: "arrow-back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: #selector(backAction(sender:)))
        navItem.rightBarButtonItem?.tintColor = .white
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        title.text = "会员特权"
        title.textAlignment = .center
        title.textColor = .black
        navItem.titleView = title
        navItem.setLeftBarButton(backBtn, animated: true)
        navBar.pushItem(navItem, animated: true)
        
        navTopView.addSubview(navBar)
        self.view.addSubview(navTopView)
        body.contentOffset.y = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        navSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isCancel = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }
    
    override func viewDidLoad() {
        navSetting()
        super.viewDidLoad()
        body.backgroundColor = .white
        self.view.addSubview(body)
        // 顶部状态栏颜色
        let headerTop = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kStatuHeight))
        let topColor = [colorwithRGBA(255,231,196, 1).cgColor, colorwithRGBA(255,202,122, 1).cgColor]
        headerTop.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), topColor)
        body.addSubview(headerTop)
        allHeight += kStatuHeight
        
        // -----头部信息
        headerBox = UIView(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: headerBgHeight))
        body.addSubview(headerBox)
        allHeight += headerBgHeight
        
        let headerBg = UIImageView(image: UIImage(named: "member-header"))
        headerBg.frame = CGRect(x: 0, y: 0, width: kScreenW, height: headerBgHeight)
        headerBg.contentMode = .scaleAspectFit
        headerBox.addSubview(headerBg)
        
        let avatar = UIImageView()
        let url = URL(string: UrlFilter(UserDefaults.getInfo()["headPortrait"] as! String))
        let placeholderImage = UIImage(named: "loading")
        avatar.af_setImage(withURL: url!, placeholderImage: placeholderImage)
        headerBox.addSubview(avatar)
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = headerBgHeight*0.22*0.5
        avatar.layer.borderWidth = 2
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.snp.makeConstraints { (make) in
            make.height.equalTo(headerBgHeight*0.22)
            make.width.equalTo(headerBgHeight*0.22)
            make.top.equalTo(headerBgHeight*0.32)
            make.centerX.equalToSuperview()
        }
        
        let nick = UILabel()
        headerBox.addSubview(nick)
        nick.text = UserDefaults.getInfo()["nickName"] as! String
        nick.font = FontSize(16)
        nick.textColor = colorwithRGBA(102, 33, 0, 1.0)
        nick.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatar.snp.bottom).offset(8)
        }
        
        let rank = UIImageView()
        if(memberStatus == "1"){
            rank.image = UIImage(named: "member-super")
        }else if(memberStatus == "2"){
            rank.image = UIImage(named: "member-leader")
        }else if(memberStatus == "3"){
            rank.image = UIImage(named: "member-partner")
        }
        headerBox.addSubview(rank)
        rank.contentMode = .scaleAspectFit
        rank.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(14)
            make.top.equalTo(nick.snp.bottom).offset(5)
        }
        
        let headerTip = UILabel()
        headerBox.addSubview(headerTip)
        headerTip.text = "升级团长享受更多权益"
        headerTip.textColor = kLowOrangeColor
        headerTip.font = FontSize(14)
        headerTip.snp.makeConstraints { (make) in
            make.bottom.equalTo(-headerBgHeight*0.11)
            make.left.equalTo(headerBgHeight*0.1)
        }
        
        let headerInvite = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 26))
        headerBox.addSubview(headerInvite)
        headerInvite.setTitle("去邀请好友", for: .normal)
        headerInvite.setTitleColor(.white, for: .normal)
        headerInvite.titleLabel?.font = FontSize(12)
        headerInvite.layer.cornerRadius = 13
        headerInvite.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        headerInvite.addTarget(self, action: #selector(toInvite), for: .touchUpInside)
        headerInvite.snp.makeConstraints { (make) in
            make.bottom.equalTo(-headerBgHeight*0.095)
            make.right.equalTo(-headerBgHeight*0.12)
            make.width.equalTo(80)
        }
        loadData()
    }
    
    // 加载需要数据请求的内容
    func bodyContent(data:JSON){
        // -----升级进度
        let levelTitle = itemTitle(top: headerBox, str:"升级进度")
        let levelInfo = UIView()
        var levelHeight:CGFloat = 100
        
        body.addSubview(levelInfo)
        levelInfo.backgroundColor = colorwithRGBA(255, 243, 204, 1.0)
        levelInfo.layer.masksToBounds = true
        levelInfo.layer.cornerRadius = 10
        levelInfo.snp.makeConstraints { (make) in
            make.top.equalTo(levelTitle.snp.bottom).offset(5)
            make.left.equalTo(headerBgHeight*0.05)
            make.right.equalTo(-headerBgHeight*0.05)
            make.height.equalTo(levelHeight + 20)
            make.width.equalTo(kScreenW - headerBgHeight*0.1)
        }
        if(memberStatus == "1"){
            levelHeight = 200
            let levelProgree1 = levelItem(parent: levelInfo,top:nil, str:"直接邀请用户"+data["directNums"].description+"人",total: data["directNums"].description,current: data["currentDirectInviteNum"].description)
            levelItem(parent: levelInfo,top:levelProgree1, str:"间接邀请用户"+data["indirectNums"].description+"人",total: data["indirectNums"].description,current: data["currentIndirectInviteNum"].description)
            levelInfo.snp.updateConstraints { (make) in
                make.height.equalTo(levelHeight + 20)
            }
        }else if(memberStatus == "2" || memberStatus == "3"){
            levelItem(parent: levelInfo,top:nil, str:"直接粉丝有"+data["regimentalNums"].description+"个团长",total: data["regimentalNums"].description, current: data["currentRegimentalNums"].description)
        }
        allHeight += levelHeight + 5
        
        // 升级提示
        let levelTipIcon = UIImageView(image: UIImage(named: "member-tip"))
        body.addSubview(levelTipIcon)
        levelTipIcon.snp.makeConstraints { (make) in
            make.top.equalTo(levelInfo.snp.bottom).offset(5)
            make.width.height.equalTo(15)
            make.left.equalTo(headerBgHeight*0.06)
        }
        allHeight += 15 + 5
        let levelTipLabel = UILabel()
        body.addSubview(levelTipLabel)
        levelTipLabel.text = "满足任务即可升级"
        levelTipLabel.font = FontSize(12)
        levelTipLabel.textColor = kLowOrangeColor
        levelTipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(levelTipIcon.snp.right).offset(4)
            make.top.equalTo(levelInfo.snp.bottom).offset(5)
        }
        
        // -----当前权益
        let currentTitle = itemTitle(top: levelTipLabel, str:"当前特权")
        currentBox = UIView()
        body.addSubview(currentBox)
        currentBox.layer.borderWidth = 2
        currentBox.layer.borderColor = colorwithRGBA(250, 232, 188, 1.0).cgColor
        currentBox.layer.masksToBounds = true
        currentBox.layer.cornerRadius = 10
        currentBox.snp.makeConstraints { (make) in
            make.top.equalTo(currentTitle.snp.bottom).offset(5)
            make.left.equalTo(headerBgHeight*0.05)
            make.right.equalTo(-headerBgHeight*0.05)
            make.height.equalTo(50)
            make.width.equalTo(kScreenW - headerBgHeight*0.1)
        }
        allHeight += 5
        let currentBar = UIView()
        currentBar.layer.borderWidth = 2
        currentBar.layer.borderColor = colorwithRGBA(250, 232, 188, 1.0).cgColor
        currentBox.addSubview(currentBar)
        currentBar.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        var currentArry = [memberProfit[0],memberProfit[1]]
        if(memberStatus == "2" || memberStatus == "3"){
            currentArry = [memberProfit[1],memberProfit[2]]
        }
        for (index,item) in currentArry.enumerated(){
            let itemLabel = UILabel(frame: CGRect(x: 0, y: 0, width: currentBar.frame.width/2, height: 50))
            currentBar.addSubview(itemLabel)
            itemLabel.text = String(item["val"]!)
            itemLabel.font = FontSize(18)
            itemLabel.textColor = colorwithRGBA(174, 81, 0, 1.0)
            itemLabel.textAlignment = .center
            if(index == 0){
                itemLabel.textColor = colorwithRGBA(102, 33, 0, 1.0)
                itemLabel.backgroundColor = colorwithRGBA(255, 243, 204, 1.0)
                itemLabel.layer.borderWidth = 2
                itemLabel.layer.borderColor = colorwithRGBA(250, 232, 188, 1.0).cgColor
            }
            itemLabel.snp.makeConstraints { (make) in
                make.width.equalToSuperview().dividedBy(2)
                make.height.equalToSuperview()
                if(index == 1){
                    make.right.equalTo(0)
                }
            }
            itemLabel.isUserInteractionEnabled = true
            itemLabel.tag = Int(item["key"]!)!
            itemLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(currentType(sender:))))
            currentLabel.append(itemLabel)
        }
        currentItem(parent: currentBox,data: JSON(currentArry[0]))
        
        // -----平均收入
        let leaderTitle = itemTitle(top: currentBox, str:"团长收入")
        let leaderBox = UIImageView(image: UIImage(named: "member-leader-box"))
        body.addSubview(leaderBox)
        let leaderTemp = kScreenW - headerBgHeight*0.1
        leaderBox.snp.makeConstraints { (make) in
            make.top.equalTo(leaderTitle.snp.bottom).offset(5)
            make.left.equalTo(headerBgHeight*0.05)
            make.right.equalTo(-headerBgHeight*0.05)
            make.height.equalTo(leaderTemp*921/960)
            make.width.equalTo(kScreenW - headerBgHeight*0.1)
        }
        allHeight += leaderTemp*921/960 + 5
        
        // -----底部邀请按钮
        let inviteBtn = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW - headerBgHeight*0.1, height: 45))
        inviteBtn.isUserInteractionEnabled = true
        inviteBtn.addTarget(self, action: #selector(toInvite), for: .touchUpInside)
        body.addSubview(inviteBtn)
        inviteBtn.setTitle("邀请好友马上升级", for: .normal)
        inviteBtn.setTitleColor(colorwithRGBA(235, 133, 0, 1.0), for: .normal)
        inviteBtn.layer.borderWidth = 1
        inviteBtn.layer.borderColor = colorwithRGBA(235, 133 ,0, 1.0).cgColor
        inviteBtn.titleLabel?.font = FontSize(18)
        inviteBtn.layer.cornerRadius = 10
        inviteBtn.snp.makeConstraints { (make) in
            make.top.equalTo(leaderBox.snp.bottom).offset(25)
            make.left.equalTo(headerBgHeight*0.05)
            make.right.equalTo(-headerBgHeight*0.05)
            make.height.equalTo(45)
            make.width.equalTo(kScreenW - headerBgHeight*0.1)
        }
        allHeight += 45 + 25
        body.delegate = self
        body.contentInset = UIEdgeInsets(top: 0, left: CGFloat(0), bottom: allHeight, right: CGFloat(0))
    }
    
    // 公用标题
    func itemTitle(top: UIView,str:String) -> UIView{
        let titleBox = UIView()
        body.addSubview(titleBox)
        titleBox.snp.makeConstraints { (make) in
            make.top.equalTo(top.snp.bottom).offset(10)
            make.width.equalTo(kScreenW)
            make.height.equalTo(40)
        }
        allHeight += 40 + 10
        let bg = UIImageView(image: UIImage(named: "member-title"))
        bg.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 40)
        bg.contentMode = .scaleAspectFit
        titleBox.addSubview(bg)
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 40))
        title.text = str
        title.textColor = colorwithRGBA(102, 33, 0, 1.0)
        titleBox.addSubview(title)
        title.font = BoldFontSize(18)
        title.textAlignment = .center
        return titleBox
    }
    
    // 升级进度item
    func levelItem(parent:UIView, top:UIView?, str:String, total:String, current:String) -> UIView{
        let box = UIView()
        parent.addSubview(box)
        box.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(100)
            if(top != nil){
                make.top.equalTo(top!.snp.bottom).offset(0)
            }else{
               make.top.equalTo(0)
            }
        }
        
        let title = UILabel()
        box.addSubview(title)
        title.text = str
        title.font = FontSize(14)
        title.textColor = colorwithRGBA(102, 33, 0, 1.0)
        title.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.top.equalTo(20)
            make.left.equalTo(15)
        }
        // 进度条部分
        let progreeBox = UIView()
        box.addSubview(progreeBox)
        progreeBox.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalToSuperview().offset(-30)
            make.top.equalTo(title.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        // 进度条
        let rate = Float(current)!/Float(total)!
        let widthBg = CGFloat(22*(24/11))
        let temp = (kScreenW - headerBgHeight*0.1 - 20 - 30)*CGFloat(rate)
        let leftBg = 15 + CGFloat(temp) - (widthBg/2)
        let progreeNumBg = UIImageView(image: UIImage(named: "member-progree-tip"))
        progreeBox.addSubview(progreeNumBg)
        progreeNumBg.contentMode = .scaleAspectFit
        progreeNumBg.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.width.equalTo(widthBg)
            if(leftBg > 0){
                if(leftBg < ((kScreenW - headerBgHeight*0.1 - 20 - 30) + 15 - (widthBg/2))){
                    make.left.equalToSuperview().offset(leftBg)
                }else{
                    make.right.equalTo(0)
                }
            }
            make.top.equalTo(0)
        }
        let progreeNum = UILabel()
        progreeNumBg.addSubview(progreeNum)
        progreeNum.text = current
        progreeNum.textColor = .white
        progreeNum.font = FontSize(14)
        progreeNum.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(0.5)
        }
        
        let progree = UIProgressView(progressViewStyle: .default)
        progreeBox.addSubview(progree)
        progree.setProgress(Float(rate), animated:true)
        progree.trackTintColor = .white
        progree.progressTintColor = kLowOrangeColor
        progree.layer.masksToBounds = true
        progree.layer.cornerRadius = 2
        progree.snp.makeConstraints { (make) in
            make.top.equalTo(progreeNumBg.snp.bottom).offset(4)
            make.height.equalTo(4)
            make.width.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
        }
        
        // 进度条首尾
        let progreeStart = UIImageView(image: UIImage(named: "member-progree-1"))
        progreeBox.addSubview(progreeStart)
        progreeStart.snp.makeConstraints { (make) in
            make.width.height.equalTo(12)
            make.left.equalTo(0)
            make.top.equalTo(progree.snp.top).offset(-4)
        }
        let progreeStartLabel = UILabel()
        progreeBox.addSubview(progreeStartLabel)
        progreeStartLabel.text = "0"
        progreeStartLabel.font = FontSize(14)
        progreeStartLabel.textColor = colorwithRGBA(102, 33, 0, 1.0)
        progreeStartLabel.snp.makeConstraints { (make) in
            make.top.equalTo(progreeStart.snp.bottom).offset(1)
            make.centerX.equalTo(progreeStart)
        }
        
        let progreeEnd = UIImageView(image: UIImage(named: "member-progree-2"))
        progreeBox.addSubview(progreeEnd)
        progreeEnd.snp.makeConstraints { (make) in
            make.width.height.equalTo(12)
            make.right.equalTo(0)
            make.top.equalTo(progree.snp.top).offset(-4)
        }
        let progreeEndLabel = UILabel()
        progreeBox.addSubview(progreeEndLabel)
        progreeEndLabel.text = total
        progreeEndLabel.font = FontSize(14)
        progreeEndLabel.textColor = colorwithRGBA(102, 33, 0, 1.0)
        progreeEndLabel.snp.makeConstraints { (make) in
            make.top.equalTo(progreeEnd.snp.bottom).offset(1)
            make.centerX.equalTo(progreeEnd)
        }
        return box
    }
    
    // 切换当前权益类型
    @objc func currentType(sender:UITapGestureRecognizer){
        for item in currentLabel {
            item.layer.borderWidth = 0
            item.backgroundColor = nil
            item.textColor = colorwithRGBA(174, 81, 0, 1.0)
            if(item.tag == sender.view?.tag){
                item.textColor = colorwithRGBA(102, 33, 0, 1.0)
                item.backgroundColor = colorwithRGBA(255, 243, 204, 1.0)
                item.layer.borderWidth = 2
                item.layer.borderColor = colorwithRGBA(250, 232, 188, 1.0).cgColor
            }
        }
        currentItem(parent: currentBox, data: JSON(memberProfit[sender.view!.tag - 1]))
    }
    
    // 当前权益
    func currentItem(parent:UIView,data:JSON){
        var flag = false
        // 清空元素
        if(currentItemHeight != CGFloat(0)){
            currentItemBox.subviews.forEach{$0.removeFromSuperview()}
            allHeight -= currentItemHeight
            flag = true
        }
        
        var array = [
            ["key": "享受自购佣金","val":data["profitSelf"].description],
            ["key": "享受分享好友","val":"购物佣金"+data["profitShare"].description],
            ["key": "享受直接会员","val":"购物佣金"+data["profitDirect"].description]
        ]
        if(data["key"].description != "1"){
            array.append(["key": "享受团队所有间接","val":"会员获得佣金"+data["profitInDirect"].description])
            array.append(["key": "地推物料免费领取","val":""])
            array.append(["key": "云发单高级权限","val":""])
            array.append(["key": "一对一客服服务","val":""])
        }
        currentItemBox = UIView()
        parent.addSubview(currentItemBox)
        currentItemBox.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(50)
        }
        var top = 10
        let height = 90
        for (index,item) in array.enumerated(){
            let box = UIView()
            currentItemBox.addSubview(box)
            box.snp.makeConstraints { (make) in
                make.width.equalToSuperview().dividedBy(2)
                make.top.equalTo(top)
                if(item["val"] != ""){
                    make.height.equalTo(height + 15)
                }else{
                    make.height.equalTo(height)
                }
            }
            let image = UIImageView(image: UIImage(named: "member-"+String(index+1)))
            box.addSubview(image)
            image.snp.makeConstraints { (make) in
                make.width.height.equalTo(50)
                make.top.equalTo(10)
                make.centerX.equalToSuperview()
            }
            let label = UILabel()
            box.addSubview(label)
            label.text = item["key"]
            label.textColor = colorwithRGBA(102, 33, 0, 1.0)
            label.font = FontSize(14)
            label.textAlignment = .center
            label.snp.makeConstraints { (make) in
                make.width.equalToSuperview()
                make.height.equalTo(15)
                make.top.equalTo(image.snp.bottom).offset(5)
            }
            if(item["val"] != ""){
                let value = UILabel()
                box.addSubview(value)
                value.text = item["val"]
                value.textColor = colorwithRGBA(102, 33, 0, 1.0)
                value.font = FontSize(14)
                value.textAlignment = .center
                value.snp.makeConstraints { (make) in
                    make.width.equalToSuperview()
                    make.height.equalTo(15)
                    make.top.equalTo(label.snp.bottom).offset(5)
                }
            }
            if((index+1)%2 == 0){ //偶数，高度增加，右侧偏移
                box.snp.makeConstraints { (make) in
                    make.right.equalTo(0)
                }
                top += height
                if(item["val"] != ""){
                    top += 15
                }
            }
        }
        parent.snp.updateConstraints { (make) in
            make.height.equalTo(50+top+height+40)
        }
        currentItemHeight = CGFloat(50+top+height+40)
        currentItemBox.snp.makeConstraints { (make) in
            make.height.equalTo(top+height+40)
        }
        allHeight += CGFloat(currentItemHeight)
        // 更新滚动条
        if(flag){
            body.contentInset = UIEdgeInsets(top: 0, left: CGFloat(0), bottom: allHeight, right: CGFloat(0))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 外部传入额外高度
    func setOutHeight(val:CGFloat){
        self.allHeight += val
    }

    @objc func toIndex (_ btn: UIButton) {
        let delegate = UIApplication.shared.delegate
        delegate?.window??.rootViewController = TabBarViewController()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func toInvite(_ btn: UIButton){
        self.navigationController?.pushViewController(ShareController(), animated: true)
    }
    
    func loadData(){
        AlamofireUtil.post(url: "/user/invite/promote",
        param: [:],
        success: { (res, data) in
            if self.isCancel {
                return
            }
            self.bodyContent(data: data)
        },
        error: {},
        failure: {})
    }
    
}
