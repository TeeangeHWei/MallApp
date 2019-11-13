//
//  PddSearchView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/11.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

//MARK: ------------------------顶部搜索view-----------------//
@available(iOS 11.0, *)
class PddSearchView: UIView,UITextFieldDelegate {
    weak var navigation : UINavigationController?
    
    
    lazy var textField : UITextField = { () -> UITextField in
        let textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = UIColor.clear
        textField.tintColor = UIColor.black
        textField.borderStyle = .none
        textField.font = FontSize(14)
        textField.textColor = kBlack
        textField.placeholder = "请输入搜索关键字"
        textField.clearButtonMode = .whileEditing
        textField.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(clicksearch)))
        return textField
        
    }()
    
    @objc func clicksearch(){
        print("click:::")
//        navigation?.navigationController?.pushViewController(SearchPageController(), animated: true)
        navigation?.navigationController?.present(SearchPageController(), animated: true, completion: {
            print("跳转了")
        })
    }
    var searchIcon : UIImageView = { () -> UIImageView in
        let searchIcon = UIImageView()
        searchIcon.image = UIImage(named: "home_newSeacrhcon")
        searchIcon.contentMode  = .center
        return searchIcon
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.green
        setUpChildView()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        navigation?.pushViewController(SearchPageController(), animated: true)
        return false
    }
    
    func setUpChildView() {
        self.addSubview(textField)
        self.addSubview(searchIcon)
        
        textField.snp.makeConstraints{ (make) in
            make.left.equalTo(self).offset(AdaptW(35))
            make.right.equalTo(self).offset(AdaptW(-35))
            make.height.equalTo(30)
            make.center.equalTo(self.snp.center)
        }
        
        searchIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(5)
            make.width.height.equalTo(AdaptW(30))
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

