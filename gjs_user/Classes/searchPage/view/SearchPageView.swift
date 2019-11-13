//
//  searchPageView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/15.
//  Copyright © 2019 大杉网络. All rights reserved.
//

@available(iOS 11.0, *)
class SearchPageView: UIScrollView {

    var navc : UINavigationController?
    let hotList = UIView()
    let historyList = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, nav: UINavigationController) {
        self.init(frame: CGRect(x: 0, y: headerHeight + 46, width: kScreenW, height: kScreenH))
        navc = nav
        self.backgroundColor = .white
        self.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH)
        }
        // 标语
        let slogan = UILabel()
        slogan.text = "三步轻松获取优惠券/返现"
        slogan.textColor = kMainTextColor
        slogan.font = FontSize(14)
        slogan.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 15)
            layout.padding = 15
            layout.marginLeft = 15
        }
        self.addSubview(slogan)
        // banner
        let banner = UIImageView(image: UIImage(named: "search-banner"))
        banner.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenW * 0.22)
        }
        self.addSubview(banner)
        // 热门搜索
        let hotTitle = UILabel()
        hotTitle.text = "热门搜索"
        hotTitle.font = FontSize(14)
        hotTitle.textColor = kMainTextColor
        hotTitle.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 15)
            layout.padding = 15
            layout.marginLeft = 15
        }
        self.addSubview(hotTitle)
        // 热搜列表
        hotList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = 120
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        self.addSubview(hotList)
        // 搜索历史
        let historyTitle = UIView()
        historyTitle.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.width = YGValue(kScreenW)
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        self.addSubview(historyTitle)
        let historyTLabel = UILabel()
        historyTLabel.text = "搜索历史"
        historyTLabel.font = FontSize(14)
        historyTLabel.textColor = kMainTextColor
        historyTLabel.configureLayout { (layout) in
            layout.isEnabled = true
        }
        historyTitle.addSubview(historyTLabel)
        let emptyBtn = UIButton()
        emptyBtn.addTarget(self, action: #selector(clearHistory), for: .touchUpInside)
        emptyBtn.setImage(UIImage(named: "search-delete"), for: .normal)
        emptyBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 14
            layout.height = 14
        }
        historyTitle.addSubview(emptyBtn)
        // 历史列表
        historyList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.flexDirection = .row
            layout.flexWrap = .wrap
            layout.padding = 15
        }
        self.addSubview(historyList)
        let historyArr = UserDefaults.getHistory() as! [String]
        for item in historyArr {
            let historyItem = SearchBtn(frame: CGRect(x: 0, y: 0, width: 100, height: 24), labelS: item)
            if item != "暂无历史" {
                historyItem.addTarget(self, action: #selector(toSearch), for: .touchUpInside)
            }
            historyList.addSubview(historyItem)
        }
        
        
        
        
        self.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 设置热搜列表
    func setHotList (hotArr: [String]) {
        hotList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = 120
            layout.paddingLeft = 15
            layout.paddingRight = 15
            layout.flexDirection = .row
            layout.flexWrap = .wrap
        }
        for item in hotArr {
            let hotItem = SearchBtn(frame: CGRect(x: 0, y: 0, width: 100, height: 24), labelS: item)
            hotItem.addTarget(self, action: #selector(toSearch), for: .touchUpInside)
            hotList.addSubview(hotItem)
        }
        hotList.yoga.applyLayout(preservingOrigin: true)
    }
    
    // 搜索
    @objc func toSearch (_ btn : SearchBtn) {
        searchStr = btn.searchValue
        navc?.pushViewController(SearchResultController(), animated: true)
    }
    // 清空历史
    @objc func clearHistory (_ btn : UIButton) {
        IDDialog.id_show(title: "", msg: "是否确定清除历史记录？", leftActionTitle: "取消", rightActionTitle: "确定", leftHandler: {
            
        }) {
            UserDefaults.removeHistory()
            self.historyList.clearAll2()
            self.historyList.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(kScreenW)
                layout.paddingLeft = 15
                layout.paddingRight = 15
                layout.flexDirection = .row
                layout.flexWrap = .wrap
            }
            let historyItem = UIButton()
            historyItem.backgroundColor = kBGGrayColor
            historyItem.layer.cornerRadius = 12
            historyItem.layer.masksToBounds = true
            historyItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.maxWidth = YGValue(kScreenW * 0.25)
                layout.height = 24
                layout.paddingLeft = 10
                layout.paddingRight = 10
                layout.marginBottom = 10
                layout.marginRight = 10
            }
            self.historyList.addSubview(historyItem)
            let itemLabel = UILabel()
            itemLabel.text = "暂无历史"
            itemLabel.font = FontSize(12)
            itemLabel.textColor = kMainTextColor
            itemLabel.configureLayout { (layout) in
                layout.isEnabled = true
                layout.maxWidth = YGValue(kScreenW * 0.25 - 20)
                layout.height = 24
            }
            historyItem.addSubview(itemLabel)
            self.historyList.yoga.applyLayout(preservingOrigin: true)
        }
        
    }
    
}
