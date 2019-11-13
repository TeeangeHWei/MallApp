//
//  ShareView.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/10/5.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

class ShareSdkView: UIView{
    
    private let typeArray = [
        ["img":"share-wechat","str":"微信","type":"wechat"],
        ["img":"share-friend-circle","str":"朋友圈","type":"friend_cricle"],
        ["img":"share-sina","str":"微博","type":"sina"],
        ["img":"share-qq","str":"QQ","type":"qq"],
        ["img":"share-zone","str":"QQ空间","type":"zone"],
    ]
    // 传递的内容参数
    private var model:ShareSdkModel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect,data:ShareSdkModel) {
        self.init(frame: frame)
        model = data
        let alert = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: UIScreen.main.bounds.size.height))
        alert.backgroundColor = colorwithRGBA(0, 0, 0, 0.3)
        self.addSubview(alert)
        
        // 取消按钮
        let cancelBtn = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW - 30, height: 40))
        alert.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(cancelShare), for: .touchUpInside)
        cancelBtn.setTitle("取 消", for: .normal)
        cancelBtn.backgroundColor = .white
        cancelBtn.setTitleColor(kLowOrangeColor, for: .normal)
        cancelBtn.titleLabel?.font = FontSize(16)
        cancelBtn.layer.masksToBounds = true
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenW - 30)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-25)
        }
        
        let shareBox = UIView()
        alert.addSubview(shareBox)
        shareBox.backgroundColor = .white
        shareBox.layer.masksToBounds = true
        shareBox.layer.cornerRadius = 10
        shareBox.snp.makeConstraints { (make) in
            make.bottom.equalTo(cancelBtn.snp.top).offset(-10)
            make.width.equalTo(kScreenW - 30)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        setItem(shareBox)
    }
    
    // 设置分享类型
    func setItem(_ parent:UIView){
        var tempTop:CGFloat = 20
        var tempLeft:CGFloat = 0
        let width:CGFloat = (kScreenW - 30)/4
        let height:CGFloat = 90
        for (index,item) in typeArray.enumerated(){
            let itemBox = UIView()
            itemBox.tag = 200+index
            itemBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareByType(sender:))))
            parent.addSubview(itemBox)
            itemBox.snp.makeConstraints { (make) in
                make.width.equalTo(width)
                make.height.equalTo(height)
                make.top.equalTo(tempTop)
                make.left.equalTo(tempLeft)
            }
            let img = UIImageView(image: UIImage(named: item["img"]!))
            itemBox.addSubview(img)
            img.layer.masksToBounds = true
            img.layer.cornerRadius = 20
            img.snp.makeConstraints { (make) in
                make.width.height.equalTo(40)
                make.centerX.equalToSuperview()
                make.top.equalTo(0)
            }
            let label = UILabel()
            itemBox.addSubview(label)
            label.text = item["str"]!
            label.textColor = kMainTextColor
            label.font = FontSize(14)
            label.textAlignment = .center
            label.snp.makeConstraints { (make) in
                make.width.equalToSuperview()
                make.height.equalTo(20)
                make.top.equalTo(50)
            }
            tempLeft += width
            if(tempLeft == width*4){
                tempTop += height
                tempLeft = 0
            }
        }
    }
    
    // 关闭分享页面
    @objc func cancelShare(){
        self.removeFromSuperview()
    }
    
    @objc func shareByType(sender:UITapGestureRecognizer){
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: model.content!,
                                          images : model.image ?? UIImage(named: "logo"),
                                          url : NSURL(string: model.url!)! as URL,
                                          title : model.title!,
                                          type : model.type!)

        // 筛选分享平台类型
        let typeStr:String = typeArray[sender.view!.tag - 200]["type"]!
        var type:SSDKPlatformType = SSDKPlatformType.typeWechat
        if(typeStr == "wechat"){
            type = SSDKPlatformType.typeWechat
        }else if(typeStr == "sina"){
            type = SSDKPlatformType.typeSinaWeibo
        }else if(typeStr == "qq"){
            type = SSDKPlatformType.subTypeQQFriend
        }else if(typeStr == "zone"){
            type = SSDKPlatformType.subTypeQZone
        }else if(typeStr == "friend_cricle"){
            type = SSDKPlatformType.subTypeWechatTimeline
        }else {
            IDToast.id_show(msg: "分享异常",success: .fail)
            return
        }
        
        //2.进行分享
        ShareSDK.share(type, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            switch state{
            case SSDKResponseState.success: IDToast.id_show(msg: "分享成功"); break
            case SSDKResponseState.fail:    IDToast.id_show(msg: "分享失败");print("授权失败,错误描述:\(String(describing: error))"); break
            case SSDKResponseState.cancel:  IDToast.id_show(msg: "已取消"); break
            default:
                break
            }
        }
    }
    
    // 单类型分享
    func shareByOneType(typeStr : String, data : ShareSdkModel){
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: data.content ?? "",
                                          images : data.image ?? UIImage(named: "logo"),
                                          url : URL.init(string: data.url ?? ""),
                                          title : data.title ?? "",
                                          type : data.type!)

        // 筛选分享平台类型
//        let typeStr:String = typeArray[sender.view!.tag - 200]["type"]!
        var type:SSDKPlatformType = SSDKPlatformType.typeWechat
        if(typeStr == "wechat"){
            type = SSDKPlatformType.typeWechat
        }else if(typeStr == "sina"){
            type = SSDKPlatformType.typeSinaWeibo
        }else if(typeStr == "qq"){
            type = SSDKPlatformType.subTypeQQFriend
        }else if(typeStr == "zone"){
            type = SSDKPlatformType.subTypeQZone
        }else if(typeStr == "friend_cricle"){
            type = SSDKPlatformType.subTypeWechatTimeline
        }else {
            IDToast.id_show(msg: "分享异常",success: .fail)
            return
        }
        
        //2.进行分享
        ShareSDK.share(type, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            switch state{
            case SSDKResponseState.success: IDToast.id_show(msg: "分享成功"); break
            case SSDKResponseState.fail:    IDToast.id_show(msg: "分享失败");print("授权失败,错误描述:\(String(describing: error))"); break
            case SSDKResponseState.cancel:  IDToast.id_show(msg: "已取消"); break
            default:
                break
            }
        }
    }
}
