//
//  ExpertArticleView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/29.
//  Copyright © 2019 大杉网络. All rights reserved.
//


class ExpertArticleView : UIScrollView {
    var allHeight : Int = Int((kScreenW - 20) * 0.408) + 295
    let banner = ArticleBanner(frame: CGRect(x: 0, y: 0, width: kScreenW, height: (kScreenW - 20) * 0.408 + 20))
    let newThisWeek = NewThisWeek(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 0))
    let everyLook = EveryLook(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 0))
    var articleViewArr = [UIView]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.showsVerticalScrollIndicator = false
        self.configureLayout { (layout) in
            layout.isEnabled = true
        }
        self.addSubview(banner)
        self.addSubview(newThisWeek)
        self.addSubview(everyLook)
        for item in articleList {
            let articleItem = ArticleItem(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 120), data: item)
            self.addSubview(articleItem)
            articleViewArr.append(articleItem)
            allHeight += 120
        }
        
        everyLook.typeList.titleClickClosure = { index in
            print(index)
            self.removeArticle()
            self.update(talentcat : index)
        }
        
        self.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight), right: CGFloat(0))
        self.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func removeArticle () {
        for item in articleViewArr {
            item.removeFromSuperview()
            self.allHeight -= 120
        }
        articleViewArr = [UIView]()
    }
    
    func update (talentcat : Int) {
        AlamofireUtil.post(url: "/product/public/talentInfo", param: ["talentcat":talentcat],
           success:{(res,data) in
            // clickdata 大家都在看
            articleList = ArticleList.deserialize(from: data["data"].description)!.clickdata!
            for item in articleList {
                let articleItem = ArticleItem(frame: CGRect(x: 0, y: self.allHeight, width: Int(kScreenW), height: 120), data: item)
                self.addSubview(articleItem)
                self.articleViewArr.append(articleItem)
                self.allHeight += 120
            }
            self.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(self.allHeight), right: CGFloat(0))
        },
        error:{

        },
        failure:{

        })
    }
    
}
