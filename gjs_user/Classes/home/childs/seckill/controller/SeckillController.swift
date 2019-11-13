//
//  seckillController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/28.
//  Copyright © 2019 大杉网络. All rights reserved.
//

@available(iOS 11.0, *)
class SeckillController : ViewController {
    
    var isCancel = false
    private var hourType = 8
    private var minId = 1
    private var allHeight = 0
    
    let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight+70, width: kScreenW, height: kScreenH - headerHeight - 70))
    let loadingView = UIActivityIndicatorView(style: .white)
    
    override func viewDidLoad() {
        let navView = customNav(titleStr: "限时抢购", titleColor: .white, border: false)
        navView.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        self.view.addSubview(navView)
        view.backgroundColor = kBGGrayColor
        let timeListView = TimeListView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: 70), getData: { index in
            self.getData(hourType: index)
        })
        view.addSubview(timeListView)
        setLoading()
        view.addSubview(body)
    }
    
    // 修改系统状态栏字颜色为白色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isCancel = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isCancel = true
    }
    
    func getData (hourType : Int) {
        AlamofireUtil.post(url:"/product/public/fastBuy", param: [
            "hour_type" : hourType,
            "min_id" : 1
        ],
        success:{(res,data) in
            if self.isCancel {
                return
            }
            self.body.clearAll()
            self.allHeight = 0
            let goodsList = goodsItemDataList.deserialize(from: data.description)!.data!
            for item in goodsList {
                let goodsItem = GoodsItemView(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW - 20), height: 130), data: item, nav: self.navigationController!)
                self.body.addSubview(goodsItem)
                self.allHeight += 130
            }
            // 没有更多了
            let noMore = UILabel(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 50))
            noMore.text = "没有更多了～"
            noMore.textAlignment = .center
            noMore.font = FontSize(14)
            noMore.textColor = kGrayTextColor
            self.body.addSubview(noMore)
            self.body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(self.allHeight + 60), right: CGFloat(0))
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
        loadingView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 50)
        loadingView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = 50
        }
        loadingView.startAnimating()
        body.addSubview(loadingView)
    }

}
