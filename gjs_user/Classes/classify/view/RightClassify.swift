//
//  RightClassify.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/4.
//  Copyright © 2019 大杉网络. All rights reserved.
//


@available(iOS 11.0, *)
class RightClassify: UIView {
    
    var dataList : [rightItemModel]?
    
    private var littleClassify = [Dictionary<String, Any>]()
    private var rightHeight = 0
    private var nav : UINavigationController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, data: [rightItemModel], Nav: UINavigationController?) {
        self.init(frame: frame)
        self.nav = Nav
        self.dataList = data
        self.backgroundColor = .white
        self.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.width = YGValue(kScreenW * 0.75)
            layout.height = YGValue(kScreenH)
            layout.marginLeft = YGValue(kScreenW * 0.25)
            layout.position = .relative
        }
        let rightPage = setRightPage(data: data[0])
        self.addSubview(rightPage)
        
        
        self.yoga.applyLayout(preservingOrigin: true)
//        self.bringSubviewToFront(self.pageList[0])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 分类页
    func setRightPage (data: rightItemModel) -> UIScrollView {
        
        rightHeight = 0
        let right = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.75, height: kScreenH))
        right.showsVerticalScrollIndicator = false
        right.backgroundColor = .white
        right.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.width = YGValue(kScreenW * 0.75)
            layout.height = YGValue(kScreenH)
            layout.position = .absolute
            layout.top = 0
            layout.left = 0
        }
        
        for item in data.data! {
            let nextView = UIView()
            nextView.configureLayout { (layout) in
                layout.isEnabled = true
                layout.flexDirection = .column
            }
            let nextTitle = setNextTitle(titleS: item.next_name!)
            nextView.addSubview(nextTitle)
            rightHeight += 40
            let nextImg = nextImgList(imgArr: item.info!)
            nextView.addSubview(nextImg)
            right.addSubview(nextView)
        }
        right.yoga.applyLayout(preservingOrigin: true)
        right.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(rightHeight + 200), right: CGFloat(0))
        return right
    }
    
    // 次级标题
    func setNextTitle (titleS: String) -> UIView {
        // 标题
        let titleView = UIView()
        titleView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .center
            layout.alignItems = .center
            layout.width = YGValue(kScreenW * 0.75)
            layout.height = YGValue(30)
            layout.marginTop = 10
        }
        let titleImg = UIImage(named: "title")
        let leftView = UIView()
        leftView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 24
            layout.height = 9.2
        }
        let leftImg = UIImageView(image: titleImg)
        leftImg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 24
            layout.height = 9.2
        }
        leftView.addSubview(leftImg)
        let rightView = UIView()
        rightView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 24
            layout.height = 9.2
        }
        let rightImg = UIImageView(image: titleImg)
        rightImg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 24
            layout.height = 9.2
        }
        rightImg.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        rightView.addSubview(rightImg)
        let title = UILabel()
        title.textColor = colorwithRGBA(247,51,47,1)
        title.textAlignment = .center
        title.text = titleS
        title.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginLeft = 5
            layout.marginRight = 5
        }
        titleView.addSubview(leftView)
        titleView.addSubview(title)
        titleView.addSubview(rightView)
        
        return titleView
    }
    
    // 一个次级类目下的图片
    func nextImgList (imgArr: [rightItem]) -> UIView {
        
        let imgList = UIView()
        imgList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.flexWrap = .wrap
            layout.width = YGValue(kScreenW * 0.75)
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        let itemW = (kScreenW * 0.75 - 30)/3
        let itemH = 34 + itemW * 0.8
        let count = Int(ceil(Double(imgArr.count) / 3.0))
        let imgListH = count * Int(itemH)
        rightHeight += imgListH
        for item in imgArr {
            let imgItem = ClassifyButton(frame: CGRect(x: 0, y: 0, width: itemW, height: itemH), data: item, navC: nav)
            //            imgItem.tagStr = item.son_name!
            //            imgItem.addTarget(self, action: #selector(toGoodsList), for: .touchUpInside)
            //            imgItem.configureLayout { (layout) in
            //                layout.isEnabled = true
            //                layout.flexDirection = .column
            //                layout.alignItems = .center
            //                layout.width = YGValue(itemW)
            //                layout.paddingTop = 10
            //            }
            imgList.addSubview(imgItem)
            //            let icon = UIImageView()
            //            icon.configureLayout { (layout) in
            //                layout.isEnabled = true
            //                layout.width = YGValue(itemW * 0.8)
            //                layout.height = YGValue(itemW * 0.8)
            //            }
            //            ADPhotoLoader.share.loadImage(url: item.imgurl!, complete: {[weak self](data: Data?, url: String) in
            //                if data != nil {
            //                    // 处理图片
            //                    icon.image = UIImage(data: data!)
            //                }
            //            })
            //            imgItem.addSubview(icon)
            //            let name = UILabel()
            //            name.text = item.son_name!
            //            name.font = FontSize(14)
            //            name.textAlignment = .center
            //            name.textColor = kMainTextColor
            //            name.configureLayout { (layout) in
            //                layout.isEnabled = true
            //                layout.width = YGValue(itemW)
            //                layout.height = 24
            //            }
            //            imgItem.addSubview(name)
        }
        
        return imgList
    }
    
    func changePage (index: Int) {
        self.clearAll2()
        let rightPage = setRightPage(data: self.dataList![index])
        self.addSubview(rightPage)
    }
    
    @objc func toGoodsList (_ btn: ClassifyButton) {
        var name = btn.tagStr!
        classifyTitle = name
        self.nav!.pushViewController(ClassifyGoodsListView(), animated: true)
    }
}
