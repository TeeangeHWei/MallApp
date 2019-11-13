//
//  articleBanner.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/29.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import LLCycleScrollView

class ArticleBanner: UIView {
    
    var imagesURLStrings = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imagesURLStrings = articelBannerImg
        self.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue((kScreenW - 20) * 0.408 + 20)
        }
        
        // --------轮播图--------
        let swiper = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect.init(x: 0, y: 0, width: kScreenW - 20, height: (kScreenW - 20) * 0.408), didSelectItemAtIndex: { index in
            print("当前点击图片的位置为:\(index)")
        })
        swiper.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 20)
            layout.height = YGValue((kScreenW - 20) * 0.408)
            layout.marginTop = 10
            layout.marginLeft = 10
        }
        
//        let imagesURLStrings = [
//            "mybanner-1"
//        ];
        
        swiper.imagePaths = imagesURLStrings
        // 是否自动滚动
        swiper.autoScroll = true
        // 是否无限循环，此属性修改了就不存在轮播的意义了 😄
        swiper.infiniteLoop = true
        // 滚动间隔时间(默认为2秒)
        swiper.autoScrollTimeInterval = 3.0
        // 等待数据状态显示的占位图
        //        bannerDemo.placeHolderImage = #UIImage
        // 如果没有数据的时候，使用的封面图
        //        bannerDemo.coverImage = #UIImage
        // 设置图片显示方式=UIImageView的ContentMode
        swiper.imageViewContentMode = .scaleToFill
        // 设置滚动方向（ vertical || horizontal ）
        swiper.scrollDirection = .horizontal
        // 设置当前PageControl的样式 (.none, .system, .fill, .pill, .snake)
        swiper.customPageControlStyle = .snake
        // 非.system的状态下，设置PageControl的tintColor
        swiper.customPageControlInActiveTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
        // 设置.system系统的UIPageControl当前显示的颜色
        swiper.pageControlCurrentPageColor = UIColor.white
        // 非.system的状态下，设置PageControl的间距(默认为8.0)
        swiper.customPageControlIndicatorPadding = 8.0
        // 设置PageControl的位置 (.left, .right 默认为.center)
        swiper.pageControlPosition = .center
        // 背景色
        swiper.backgroundColor = .white
        
        self.addSubview(swiper)
        
        self.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
