//
//  DetailController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/5.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import WebKit

@available(iOS 11.0, *)
class PddDetailController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {
    
    var goodsInfo : PddDetailData?
    var detailView : PddDetailView?
    var footer = PddDetailFooter(frame: CGRect(x: 0, y: kScreenH - 60, width: kScreenW, height: 60))
    let taobaoWebView = UIWebView()
    var couponUrl : String?
    var detailImg = [String]()
    var hasDetail = false
    var shopId = 1
    
    let coustomNavView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height:headerHeight))
    let navBar = UINavigationBar(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight))
    let navItem = UINavigationItem()
    var backBtn = UIBarButtonItem(image: UIImage(named: "detail-return")?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: #selector(backAction(sender:)))
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        title.text = "订单详情"
        title.textColor = .clear
        title.textAlignment = .center
        navItem.titleView = title
        // 滚动距离不可为负数
        if scrollView.contentOffset.y <= 0 {
            var offset = scrollView.contentOffset
            offset.y = 0
            scrollView.contentOffset = offset
        }
        // 根据滚动修改顶栏样式
        if scrollView.contentOffset.y > 10 {
            coustomNavView.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
            title.textColor = .white
            backBtn = UIBarButtonItem(image: UIImage(named: "left-arrow-white")?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: #selector(backAction(sender:)))
            navItem.setLeftBarButton(backBtn, animated: false)
        }else if scrollView.contentOffset.y <= 10 {
            coustomNavView.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), [colorwithRGBA(0, 0, 0, 0),colorwithRGBA(0, 0, 0, 0)])
            title.textColor = .clear
            backBtn = UIBarButtonItem(image: UIImage(named: "detail-return")?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: #selector(backAction(sender:)))
            navItem.setLeftBarButton(backBtn, animated: false)
        }
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpNavigation()
        // webView配置
        taobaoWebView.delegate = self
        self.view.backgroundColor = kBGGrayColor
        getData()
    }
    
    // 修改系统状态栏字颜色为白色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // 配置 NavigationBar
    func setUpNavigation(){
        detailView?.navigation = navigationController
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.backgroundColor = .clear
        navBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        navBar.pushItem(navItem, animated: true)
        coustomNavView.addSubview(navBar)
        self.view.addSubview(coustomNavView)
        navItem.setLeftBarButton(backBtn, animated: true)
    }
    
    // 获取宝贝信息
    func getData () {
        AlamofireUtil.post(url:"/ddk/public/pddGoodsDetail", param: ["goodsIdList" : goodsId!],
        success:{(res,data) in
            self.goodsInfo = PddDetailData.deserialize(from: data[0].description)!
            self.detailView = PddDetailView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - 60), data: self.goodsInfo!)
            self.detailView?.coupon.addTarget(self, action: #selector(self.getBatteryLevel), for: .touchUpInside)
            self.detailView!.delegate = self
            self.view.addSubview(self.detailView!)
            self.footer = PddDetailFooter(frame: CGRect(x: 0, y: kScreenH - 60, width: kScreenW, height: 60), data: self.goodsInfo!, nav: self.navigationController!)
            self.footer.shareBtn.addTarget(self, action: #selector(self.toShare), for: .touchUpInside)
            self.footer.getBtn.addTarget(self, action: #selector(self.getBatteryLevel), for: .touchUpInside)
            self.view.addSubview(self.footer)
            self.setUpNavigation()
        },
        error:{
                            
        },
        failure:{
                            
        })
    }
    
    // 获取店铺信息
    func getShop (name: String) {
        AlamofireUtil.post(url:"/taobao/public/searchTBKShop", param: [
            "fields" : "user_id,shop_title,shop_type,seller_nick,pict_url,shop_url",
            "q" : name
        ],
        success:{(res,data) in
            if data[0]["pictUrl"].count > 0 {
                self.detailView!.setShopAvatar(shopAvatarS: data[0]["pictUrl"].string!)
            }
        },
        error:{
        
        },
        failure:{
        
        })
    }
    
    // 获取详情图(较大概率没有)
//    func getDetailPic1 () {
//        AlamofireUtil.post(url:"/dtk/public/getItemDetail", param: ["goodsId" : detailId!],
//        success:{(res,data) in
//            if data["code"].int! == 0 {
//                let goodsInfo = DetailData2.deserialize(from: data["data"].description)!
//                self.detailView!.setDetailPic(data: goodsInfo)
//            }
//        },
//        error:{
//
//        },
//        failure:{
//
//        })
//    }
    
    // 返回上一页
    @objc func backAction(sender:UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 全部店铺宝贝
    @objc func toShopGoods (_ btn : UIButton) {
        if self.shopId == 1 {
            var tag = btn.tag
            let vc = ShopGoodsController()
            vc.shopId = tag
            navigationController?.pushViewController(vc, animated: true)
        } else {
            IDToast.id_show(msg: "店铺暂无更多优惠", success: .fail)
        }
    }
    
    // 领取优惠券
    @objc func getBatteryLevel(_ btn: UIButton) {
        // 获取优惠券链接
        self.getUrl(1)
    }
    
    // 获取rid
    func getRid (_ key : String) {
        
        AlamofireUtil.post(url:"/taobao/autho/saveRelationId", param: [
            "sessionKey" : key
        ],
        success:{(res,data) in
            //更新rid
            print("saveRelationId",data)
            var info = UserDefaults.getInfo()
            info["relationId"] = data.string
            UserDefaults.setInfo(value: info as! [String : String])
        },
        error:{
            
        },
        failure:{
            
        })
    }
    
    // 获取优惠券链接
    func getUrl (_ n : Int) {
        IDLoading.id_showWithWait()
        AlamofireUtil.post(url:"/ddk/pddDdkGoodsPromotionUrlGenerate", param: [
            "goodsId" : goodsId!,
            "generateShortUrl" : true,
            "generateWeappWebview" : true
        ],
        success:{(res,data) in
            self.couponUrl = data["goodsPromotionUrlList"][0]["weAppWebViewShortUrl"].string!
            let pddUrl = self.couponUrl!.replacingOccurrences(of: "https://", with: "")
            if n == 1 {
                IDLoading.id_dismissWait()
                // 打开优惠券页面
                var vc = PddCouponController()
                vc.webAddress = self.couponUrl!
                self.navigationController?.pushViewController(vc, animated: true)
//                }
            } else {
                IDLoading.id_dismissWait()
                // 分享
                let vc = PddGoodsShareController()
                vc.goodsInfo = self.goodsInfo
                vc.shareLink = self.couponUrl!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        },
        error:{
            IDLoading.id_dismissWait()
        },
        failure:{
            IDLoading.id_dismissWait()
        })
    }
    
    // 监听webView加载
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        // 截取链接中的sessionKey并传后台
        let url = request.url
        let urlStr = request.url?.absoluteString
        if urlStr!.contains("ganjinsheng.com/user/blank#access_token") {
            let startIndex = ("https://ganjinsheng.com/user/blank#access_token=").count
            let endIndex = urlStr!.positionOf(sub: "&token_type", backwards: false)
            let sessionKey = urlStr!.id_subString(from: startIndex, offSet: endIndex - startIndex)
            self.getRid(sessionKey)
        }
        
        return true
        
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        // js 模拟点击授权
        webView.stringByEvaluatingJavaScript(from: "document.querySelector('.button-submit').click()")
        
    }
    
    // 分享商品
    @objc func toShare(_ btn : UIButton){
        getUrl(2)
    }
    
}
