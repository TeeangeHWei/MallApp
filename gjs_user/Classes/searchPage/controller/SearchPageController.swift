//
//  searchPageController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/12.
//  Copyright © 2019 大杉网络. All rights reserved.
//

@available(iOS 11.0, *)
class SearchPageController: ViewController ,UITextFieldDelegate{
    var isCancel = false
    var navTopView : UIView!
    let inputControl = UITextField(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.65, height: 30))
    var searchPageView : SearchPageView?
    var pddSearchPageView : PddSearchPageView?
    var jdSearchPageView : JdSearchPageView?
    var oldIndex = 0
    var viewArr = [UIScrollView]()
    
    // 切换平台类型相关
    private let layer1 = CALayer()
    private var typeArr = [UIButton]()
    private var type = 0
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("收回键盘")
            inputControl.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isCancel = false
        inputControl.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }
    
    override func viewDidLoad() {
        setNavC()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        // 选项卡
        let typeList = ["淘宝", "拼多多"]
        let typeBar = UIView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: 46))
        typeBar.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .center
            layout.width = YGValue(kScreenW)
            layout.height = 46
        }
        typeBar.backgroundColor = .white
        typeBar.addBorder(side: .top, thickness: 1, color: klineColor)
        typeBar.addBorder(side: .bottom, thickness: 1, color: klineColor)
        for (index, item) in typeList.enumerated() {
            let width = (kScreenW - 60)/3
            let typeItem = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 46))
            typeItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(width)
                layout.height = 46
                layout.paddingLeft = 30
                layout.paddingRight = 30
            }
            typeItem.setTitle(item, for: .normal)
            if(index == 0){
                typeItem.setTitleColor(kLowOrangeColor, for: .normal)
            }else{
                typeItem.setTitleColor(kGrayTextColor, for: .normal)
            }
            typeItem.addTarget(self, action: #selector(typeChange), for: .touchUpInside)
            typeItem.titleLabel?.font = FontSize(14)
            typeItem.tag = index
            typeArr.append(typeItem)
            typeBar.addSubview(typeItem)
        }
        //下划线
        let width = (kScreenW - 60)/12
        layer1.frame = CGRect(x: 30 + width * 3.5, y: 42, width: width, height: 4)
        layer1.cornerRadius = 2
        layer1.backgroundColor = kLowOrangeColor.cgColor
        typeBar.layer.addSublayer(layer1)
        typeBar.yoga.applyLayout(preservingOrigin: true)
        self.view.addSubview(typeBar)
        // 淘宝
        searchPageView = SearchPageView(frame: CGRect(x: 0, y: 46, width: kScreenW, height: kScreenH - 46), nav: navigationController!)
        view.addSubview(searchPageView!)
        viewArr.append(searchPageView!)
        // 拼多多
        pddSearchPageView = PddSearchPageView(frame: CGRect(x: 0, y: 46, width: kScreenW, height: kScreenH - 46), nav: navigationController!)
        pddSearchPageView!.isHidden = true
        view.addSubview(pddSearchPageView!)
        viewArr.append(pddSearchPageView!)
        // 京东
        jdSearchPageView = JdSearchPageView(frame: CGRect(x: 0, y: 46, width: kScreenW, height: kScreenH - 46), nav: navigationController!)
        jdSearchPageView!.isHidden = true
        view.addSubview(jdSearchPageView!)
        viewArr.append(jdSearchPageView!)
        getHot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setNavC () {
//        navigationController?.navigationBar.isHidden = true
        navTopView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height:headerHeight))
        navTopView.backgroundColor = .white
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight))
        let navItem = UINavigationItem()
        navBar.backgroundColor = .clear
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.isTranslucent = false
        // 设置item的图片时 加上.withRenderingMode(.alwaysOriginal) 表示使用图片原来的颜色
        
        // 设置输入框
        let inputBox = UIView()
        inputBox.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenW * 0.65)
            make.height.equalTo(30)
        }
        
        let input = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.65, height: 30))
        input.backgroundColor = kBGGrayColor
        input.layer.cornerRadius = 15
        inputBox.addSubview(input)
        input.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenW * 0.65)
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(-20)
        }
        
        input.addSubview(inputControl)
        inputControl.placeholder = "粘贴宝贝标题，先领券再购买"
        inputControl.clearButtonMode = .whileEditing
        inputControl.keyboardType = .webSearch
        inputControl.delegate = self
        inputControl.becomeFirstResponder()
        inputControl.returnKeyType = UIReturnKeyType.done
        inputControl.resignFirstResponder()
        inputControl.font = FontSize(14)
        inputControl.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenW * 0.65 - 15)
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(12)
        }
        
//        inputBox.yoga.applyLayout(preservingOrigin: true)
//        navigationItem.titleView = inputBox
        // 设置右侧搜索按钮
        let rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.15, height: 30))
        rightBtn.addTarget(self, action: #selector(toSearch), for: .touchUpInside)
        rightBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        rightBtn.setTitle("搜索", for: .normal)
        rightBtn.setTitleColor(.white, for: .normal)
        rightBtn.titleLabel?.font = FontSize(14)
        rightBtn.layer.cornerRadius = 15
        rightBtn.layer.masksToBounds = true
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        navTopView.addSubview(navBar)
        self.view.addSubview(navTopView)
        let backBtn = UIBarButtonItem(image: UIImage(named: "arrow-back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: #selector(backAction(sender:)))
        navItem.titleView = inputBox
        navItem.setRightBarButton(UIBarButtonItem(customView: rightBtn), animated: true)
        navItem.setLeftBarButton(backBtn, animated: true)
        navBar.pushItem(navItem, animated: true)
        
    }
    
    // 获取热搜数据
    func getHot () {
        AlamofireUtil.post(url:"/product/public/hotSearch", param: [:],
        success:{(res,data) in
            if self.isCancel {
                return
            }
            var hotArr = [String]()
            for index in 0...9 {
                hotArr.append(data["data"][index]["keyword"].string!)
            }
            self.searchPageView!.setHotList(hotArr: hotArr)
            self.pddSearchPageView!.setHotList(hotArr: hotArr)
//            self.jdSearchPageView!.setHotList(hotArr: hotArr)
        },
        error:{
            
        },
        failure:{
            
        })
    }
    // 搜索按钮事件
    @objc func toSearch (_ btn : UIButton) {
        if inputControl.text != "" {
            let vc = SearchResultController()
            vc.platform = type
            searchStr = inputControl.text
            navigationController?.pushViewController(vc, animated: true)
        } else {
            IDToast.id_show(msg: "请输入要搜索的内容", success: .fail)
        }
    }
    //切换类型
    @objc func typeChange(_ btn: UIButton){
        typeArr[type].setTitleColor(kGrayTextColor, for: .normal)
        typeArr[btn.tag].setTitleColor(kLowOrangeColor, for: .normal)
        type = btn.tag
        UIView.animate(withDuration: 0.3) {
            let left = ((kScreenW - 60)/3) * CGFloat(self.type)
            self.layer1.frame.origin.x = 30 + (kScreenW - 60)/6 + (kScreenW - 60)/8 + left
        }
        viewArr[oldIndex].isHidden = true
        viewArr[btn.tag].isHidden = false
        oldIndex = btn.tag
    }
    // 键盘搜索点击事件
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if (inputControl.text?.count)! == 0 {
        IDToast.id_show(msg: "请输入要搜索的内容",success:.fail)
        return false
       
        }
        let search = SearchResultController()
        search.platform = type
        searchStr = inputControl.text
        textField.text = nil
        textField.resignFirstResponder()
        navigationController?.pushViewController(search, animated: true)
         return true
    }
}
