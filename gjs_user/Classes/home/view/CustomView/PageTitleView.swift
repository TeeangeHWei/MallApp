//
//  PageTitleView.swift
//  test
//
//  Created by 大杉网络 on 2019/7/30.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

// 代理
protocol PageTitleViewDelegate : class{
    
    func pageTitleView(titleView : PageTitleView, selectedIndex index: Int)
}


class PageTitleView: UIView{

    //代理协议
    weak var delegate1 : PageTitleViewDelegate?
    
    
    
    
    
    // 滚动 view
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
        

    }()
    
    // 底部滚动条
    private lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = option.kBotLineColor
        scrollLine.isHidden = false
        scrollLine.layer.cornerRadius = 14
        scrollLine.layer.masksToBounds = true
        return scrollLine
        
    }()
    
    
    // 底部分割线
    private lazy var bottomLine : UIView = {
       let botLine = UIView()
        let botH : CGFloat = 2
        botLine.backgroundColor = option.kBottomLineColor
        botLine.frame = CGRect(x:0, y: frame.height+botH, width: frame.width, height: botH)
        return botLine
    }()
    
    // 右部分隔线
//    private lazy var rightLine : UIView = {
//        let rigLine = UIView()
//         let rigH :CGFloat = 2
//         rigLine.backgroundColor = option.kRightLineColor
//         rigLine.frame = CGRect(x: 0, y: frame.width, width: frame.w, height: rigH)
//        return rigLine
//    }()
    
    private lazy var option : PageOptions = {
       let option = PageOptions()
        return option
    }()
    
    // 创建label数组
    private lazy var titleLabs : [UILabel] = [UILabel]()
    // 标题
    private var titles : [String]
    // 索引
    private var currentIndex : Int = 0
    
    init(frame: CGRect , titles : [String] , options : PageOptions? = nil) {
        
        self.titles = titles
        super.init(frame: frame)
        
        if options != nil{
            self.option = options!
        }
        setUpAllView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.titles = [String]()
        super.init(coder: aDecoder)
        self.option = PageOptions()
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLabelsLayout()
        setupBottomLineLayout()
    }
}

extension PageTitleView{
    
    func setUpBottomLine() {
        guard option.isShowBottomLine else { return }
        scrollView.insertSubview(scrollLine, at: 0)
        
        
    }
    
    private func setUpAllView(){
        
        // 添加scrollview
        addSubview(scrollView)
        scrollView.frame = bounds
        //添加 scrollline
        scrollView.addSubview(scrollLine)
        //添加对应的title
        setUpTitleLabel()
        
        setBottomMenuAndscrollLine()
        
        
    }
    
    private func setUpTitleLabel(){
        
        for (index,title) in titles.enumerated() {
            // 创建label
            let lab = UILabel()
            lab.text = title
            lab.tag = index
            
            lab.font = option.kIsNormalFontBold ? BoldFontSize(option.kTitleFontSize) : FontSize(option.kTitleFontSize)
            lab.textColor = colorwithRGBA(option.kNormalColor.0, option.kNormalColor.1, option.kNormalColor.2, 1.0)
            lab.textAlignment = .center
            
            // 添加lab
            scrollView.addSubview(lab)
            titleLabs.append(lab)
            
            //添加点击事件
            lab.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGesture:)))
            lab.addGestureRecognizer(tap)
            
        }
    }
    
    private func setBottomMenuAndscrollLine(){
        
        // 添加底部分割线和 滚动线
//        if option.kIsShowBottomBorderLine{
//            addSubview(scrollLine)
//        }
        
        // 如果没有就返回
        setUpBottomLine()
        
        guard let firstLab = titleLabs.first  else { return }
        firstLab.textColor = colorwithRGBA(option.kSelectColor.0, option.kSelectColor.1, option.kSelectColor.2, 1.0)
        if option.kTitleSelectFontSize != nil {
            firstLab.font = BoldFontSize(option.kTitleSelectFontSize!)
        }
        
        adjustLabelPosition(firstLab)
    }
    
    
    
}



// MARK: - layout

extension PageTitleView{
    private func setupLabelsLayout(){
        
        let labelH = frame.size.height
        let labelY : CGFloat = 0
        var labelW : CGFloat = 0
        var labelX : CGFloat = 0
        
        let count = titleLabs.count
        for (i, titleLabel) in titleLabs.enumerated() {
            if option.isTitleScrollEnable{
                
                labelW = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.init(kCTFontAttributeName as String) : titleLabel.font as Any], context: nil).width
                
                labelX = i == 0 ? option.kMarginW * 0.5 : (titleLabs[i-1].frame.maxX + option.kMarginW)
            } else if option.kItemWidth != 0 {
                labelW = option.kItemWidth
                labelX = labelW * CGFloat(i)
            }else{
                labelW = bounds.width / CGFloat(count)
                labelX = labelW * CGFloat(i)
            }
            titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW+Adapt(10), height: labelH)
        }
        if option.isTitleScrollEnable {
            guard let titleLabel = titleLabs.last else {return}
            scrollView.contentSize.width = titleLabel.frame.maxX + option.kMarginW * 0.5
            
        }
    }
    
    private func setupBottomLineLayout(){
        guard titleLabs.count - 1 >= currentIndex else  { return }
        let label = titleLabs[currentIndex]
        
        scrollLine.frame.origin.x = label.frame.origin.x
        scrollLine.frame.size.width = label.frame.width
        scrollLine.frame.size.height = option.kBotLineHeight - 8
        scrollLine.frame.origin.y = self.bounds.height - option.kBotLineHeight
        
        
    }
    private func adjustLabelPosition(_ targetLabel : UILabel){
        guard option.isTitleScrollEnable else { return }
        
        var offsetX = targetLabel.center.x - bounds.width * 0.5
        
        if offsetX < 0 {
            offsetX = 0
        }
        if offsetX > scrollView.contentSize.width - scrollView.bounds.width {
            offsetX = scrollView.contentSize.width - scrollView.bounds.width
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
    }
}

// MARK: - 对外暴露
extension PageTitleView{
    func setPageTitleWithProgress(progress : CGFloat, sourceIndex : Int, targetIndex : Int)  {
        // 取得lab
        let sourceLab = titleLabs[sourceIndex]
        let targetLab = titleLabs[targetIndex]
        
        //处理滑块
        let movtotalX = targetLab.frame.origin.x - sourceLab.frame.origin.x
        let movX = movtotalX * progress
        scrollLine.frame.origin.x = sourceLab.frame.origin.x + movX
        
        // 滑块的颜色渐变
        //取出颜色变化的范围
        let colorDelta = (option.kSelectColor.0 - option.kNormalColor.0, option.kSelectColor.1 - option.kNormalColor.1, option.kSelectColor.2 - option.kNormalColor.2)
        
        // 变化 sourceLab 的文字颜色
        sourceLab.textColor = colorwithRGBA(option.kSelectColor.0 - colorDelta.0 * progress, option.kSelectColor.1 - colorDelta.1 * progress, option.kSelectColor.2 - colorDelta.2 * progress, 1.0)
        
        
        // 变化 targetLab 的文字颜色
        targetLab.textColor = colorwithRGBA(option.kNormalColor.0 + colorDelta.0 * progress, option.kNormalColor.1 + colorDelta.1 * progress, option.kNormalColor.2 + colorDelta.2 * progress, 1.0)
        if option.kTitleSelectFontSize != nil{
            sourceLab.font = option.kIsNormalFontBold ? BoldFontSize(option.kTitleSelectFontSize! - (option.kTitleSelectFontSize! - option.kTitleFontSize) * progress) : FontSize(option.kTitleSelectFontSize! - (option.kTitleSelectFontSize! - option.kTitleFontSize) * progress)
            targetLab.font = BoldFontSize (option.kTitleSelectFontSize! + (option.kTitleSelectFontSize! - option.kTitleFontSize)  * progress)
            setupLabelsLayout()
        }
        adjustLabelPosition(targetLab)
        
        if option.isShowBottomLine {
            let deltaX = targetLab.frame.origin.x - sourceLab.frame.origin.x
            let deltaW = targetLab.frame.width - sourceLab.frame.width
            scrollLine.frame.origin.x = sourceLab.frame.origin.x + progress * deltaX
            scrollLine.frame.size.width = sourceLab.frame.width + progress * deltaW
        }
        // 记录
        currentIndex = targetIndex
    }
    
    
}



// MARK: - 监听label 的点击
extension PageTitleView{
    @objc fileprivate func titleLabelClick(tapGesture : UITapGestureRecognizer){
        
        // 如果下标相同，不作处理
        if tapGesture.view?.tag == currentIndex {
            return
        }
        // 获取当前lab的下标值
        let currentLab = tapGesture.view as? UILabel
        
        // 获取之前的label
        let oldLab = titleLabs[currentIndex]
        
        //切换文字颜色和字体大小
        currentLab?.textColor = colorwithRGBA(option.kSelectColor.0, option.kSelectColor.1, option.kSelectColor.2, 1.0)
        oldLab.textColor = colorwithRGBA(option.kNormalColor.0, option.kNormalColor.1, option.kNormalColor.2, 1.0)
        
        // 修改字体大小
        if option.kTitleSelectFontSize != nil {
            currentLab?.font = BoldFontSize(option.kTitleSelectFontSize!)
            oldLab.font = option.kIsNormalFontBold ? BoldFontSize(option.kTitleFontSize) : FontSize(option.kTitleFontSize)
            setupLabelsLayout()
        }
        
        // 保存最新lab的下标
        currentIndex = (currentLab?.tag)!
        
        //滚动条位置发生改变
        let scrollLineX = CGFloat((currentLab?.tag)!) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        adjustLabelPosition(currentLab!)
        
        if option.isShowBottomLine {
            UIView.animate(withDuration: 0.15, animations: {
                self.scrollLine.frame.origin.x = (currentLab?.frame.origin.x)!
                self.scrollLine.frame.size.width = (currentLab?.frame.width)!
            })
        }
        //通知代理
        delegate1?.pageTitleView(titleView: self, selectedIndex: currentIndex)
        
        
    }
}


