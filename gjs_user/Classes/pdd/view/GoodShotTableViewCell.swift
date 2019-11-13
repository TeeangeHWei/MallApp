//
//  GoodShotTableViewCell.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/18.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class GoodShotTableViewCell: UITableViewCell {
    var titlelabel : UILabel?
    var themeimg : UIButton?
    var conrView : DropShadowView!
    
    weak var navi : UINavigationController?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        
        
        self.makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    fileprivate func makeUI(){
        let view = contentView
        conrView = DropShadowView.init()
        conrView?.layer.cornerRadius = 10
        conrView?.layer.masksToBounds = true
        conrView?.backgroundColor = .white
        view.addSubview(conrView!)
        conrView?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(kScreenW * 0.6)
            make.height.equalTo(220)
            
        })
        titlelabel = UILabel.init()
        titlelabel?.text = "潮袜专场"
        titlelabel?.font = UIFont.systemFont(ofSize: 15)
        conrView!.addSubview(titlelabel!)
        titlelabel?.snp.makeConstraints({ (make) in
            make.left.top.equalToSuperview().offset(10)
            make.height.equalTo(20)
            make.width.equalToSuperview()
        })
        themeimg = UIButton.init()
        themeimg?.backgroundColor = .lightGray
        conrView!.addSubview(themeimg!)
        themeimg?.snp.makeConstraints({ (make) in
            make.top.equalTo(titlelabel!.snp.bottom).offset(5)
            make.width.equalTo(kScreenW - 20)
            make.height.equalTo(370 * 0.5)
        })
    }

}
