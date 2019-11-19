//
//  DetailController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/5.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import WebKit

@available(iOS 11.0, *)
class DetailController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {
    
    var isCancel = false
    var goodsInfo : DetailData?
    var detailView : DetailView?
    var footer = DetailFooter(frame: CGRect(x: 0, y: kScreenH - 60, width: kScreenW, height: 60))
    let taobaoWebView = UIWebView()
    var couponUrl : String?
    var detailImg = [String]()
    var hasDetail = false
    var shopId = 1
    var tPwd = ""
    
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
        // 滚动加载详情图
        let loadDetailLength = detailView!.allHeight - Int(kScreenH) - 200
        if Int(scrollView.contentOffset.y) > loadDetailLength && !hasDetail {
            hasDetail = true
            getDetailPic()
        }
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
    func dissmissRootViewController()  {
        // 获取根VC
        var rootVC = self.presentingViewController
        while let parent = rootVC?.presentingViewController {
            rootVC = parent
        }
        // 释放所有下级视图
        rootVC?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // webView配置
        taobaoWebView.delegate = self
        self.view.backgroundColor = kBGGrayColor
        getData()
        setUpNavigation()
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
    
    // 配置 NavigationBar
    func setUpNavigation(){
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
        AlamofireUtil.post(url:"/product/public/detail", param: ["itemid" : detailId!],
        success:{(res,data) in
            if self.isCancel {
                return
            }
            print("detaildata::",detailId!)
            print("detaildata::",data)
            self.goodsInfo = DetailData.deserialize(from: data["data"].description)!
            self.detailView = DetailView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - 60), data: self.goodsInfo!)
            self.detailView?.coupon.addTarget(self, action: #selector(self.getBatteryLevel), for: .touchUpInside)
            self.detailView!.delegate = self
            self.view.addSubview(self.detailView!)
            self.footer = DetailFooter(frame: CGRect(x: 0, y: kScreenH - 60, width: kScreenW, height: 60), data: self.goodsInfo!, nav: self.navigationController!)
            self.footer.shareBtn.addTarget(self, action: #selector(self.toShare), for: .touchUpInside)
            self.footer.getBtn.addTarget(self, action: #selector(self.getBatteryLevel), for: .touchUpInside)
            self.view.addSubview(self.footer)
            if let shopid = self.goodsInfo!.shopid {
                self.detailView!.allShopBtn.tag = Int(shopid)!
            } else {
                self.shopId = 2
            }
            self.detailView!.allShopBtn.addTarget(self, action: #selector(self.toShopGoods), for: .touchUpInside)
            self.getShop(name: self.goodsInfo!.shopname!)
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
    
    // 获取详情图(高级，要钱的)
    func getDetailPic () {
        AlamofireUtil.post(url:"/taobao/public/productGet", param: ["itemId" : detailId!],
        success:{(res,data) in
            if let imgArr = data["mobile_desc_info"]["desc_list"]["desc_fragment"].array {
                for item in imgArr {
                    self.detailImg.append(item["content"].string!)
                }
                self.detailView!.setDetailPic(data: self.detailImg)
            }
        },
        error:{

        },
        failure:{

        })
    }
    
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
    
    // 淘宝授权
    func accredit () {
        if !(ALBBSession.sharedInstance()?.isLogin())! {
            ALBBSDK.sharedInstance()?.setAuthOption(NormalAuth)
            ALBBSDK.sharedInstance()?.auth(DetailController(), successCallback: { (session) in
                IDLoading.id_dismissWait()
//                wkwebview部分
//                let vc = AccreditPageController()
//                self.navigationController?.pushViewController(vc, animated: true)
//                self.taobaoWebView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
//                self.taobaoWebView.backgroundColor = .white
//                self.view.addSubview(self.taobaoWebView)
//                UIWebView部分
                accreditTwo(url: "https://oauth.taobao.com/authorize?response_type=token&client_id=27483814&redirect_uri=https://ganjinsheng.com/user/blank&view=wap", nav: self.navigationController!, VC: DetailController(), webView: self.taobaoWebView)
            }, failureCallback: { (session, Error) in
                print("失败了")
            })
        } else {
            IDLoading.id_dismissWait()
            let session = ALBBSession.sharedInstance()
            IDToast.id_show(msg: "已授权", success: .fail)
        }
    }
    
    // 领取优惠券
    @objc func getBatteryLevel(_ btn: UIButton) {
        // 高佣转链
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
    
    // 高佣转链
    func getUrl (_ n : Int) {
        IDLoading.id_showWithWait()
        if let rid = UserDefaults.getInfo()["relationId"] {
            AlamofireUtil.post(url:"/product/public/ratesurl", param: [
                "itemid" : detailId!,
                "relation_id" : rid
            ],
            success:{(res,data) in
                if data["code"] != nil && data["code"] == 1 {
                    // 好单库接口
                    
                } else {
                    if data["tbk_privilege_get_response"]["result"]["data"]["coupon_click_url"] != nil {
                        if data["tbk_privilege_get_response"]["result"]["data"]["coupon_total_count"] != nil {
                            self.couponUrl = data["tbk_privilege_get_response"]["result"]["data"]["coupon_click_url"].string!
                        } else {
                            self.couponUrl = data["tbk_privilege_get_response"]["result"]["data"]["item_url"].string!
                        }
                    } else {
                        if data["msg"] == "您淘宝未授权，请到好单库放单后台授权页面授权！" {
                            IDToast.id_show(msg: "您淘宝未授权", success: .fail)
                        } else {
                            IDToast.id_show(msg: "该宝贝已下架", success: .fail)
                        }
                        return
                    }
                }
                if n == 1 {
                    // 打开淘宝优惠券
                    IDLoading.id_dismissWait()
                    showTaoBaoDetail(url: self.couponUrl!)
                } else {
                    // 分享
                    self.getTpwd(self.couponUrl!)
                }
            },
            error:{
                IDLoading.id_dismissWait()
            },
            failure:{
                IDLoading.id_dismissWait()
            })
        } else {
            print("没有rid")
            self.accredit()
        }
    }
    
    // 生成淘口令
    func getTpwd (_ url : String) {
        AlamofireUtil.post(url:"/taobao/public/getTPwd", param: [
            "text" : self.goodsInfo!.itemtitle!,
            "url" : url,
            "logo" : self.goodsInfo!.itempic!
        ],
        success:{(res,data) in
            self.tPwd = data["model"].string!
            let shareLink = "https://www.ganjinsheng.com/user/inviteShare?id=\(detailId!)&invite=\(UserDefaults.getInfo()["inviteCode"]!)&tbPwd=\(self.tPwd)"
            self.getShortUrl(shareLink)
        },
        error:{
            IDLoading.id_dismissWait()
        },
        failure:{
            IDLoading.id_dismissWait()
        })
    }
    
    // 长链转短链
    func getShortUrl (_ url : String) {
        AlamofireUtil.post(url:"/comm/public/createShortUrl", param: [
            "url" : url
        ],
        success:{(res,data) in
            IDLoading.id_dismissWait()
            let vc = GoodsShareController()
            vc.goodsInfo = self.goodsInfo
            if let url = data.string {
                vc.shortUrl = url
            }
            vc.tPwd = self.tPwd
            self.navigationController?.pushViewController(vc, animated: true)
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
