//
//  PddRedPacTableViewCell.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/10/14.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class PddRedPacTableViewCell: UITableViewCell {
    var leftImageView : UIImageView?
    var topnameLabel  : UILabel?
    var subNameLabel  : UILabel?
    var rightbtn     : UIButton?
    var bottomLabel   : UILabel?
    var bottomLine : UIView?
    weak var navi : UINavigationController?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        
        
        self.makeUI()
    }
    
    fileprivate func makeUI(){
        let view = contentView
        bottomLine = UIView.init()
        bottomLine?.backgroundColor = colorwithRGBA(241, 241, 241, 1)
        view.addSubview(bottomLine!)
        bottomLine?.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview()
            make.width.equalTo(kScreenW)
            make.height.equalTo(4)
        })
        leftImageView = UIImageView.init()
        view.addSubview(leftImageView!)
        leftImageView?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(50)
            make.width.equalTo(70)
            make.height.equalTo(70)
        })
        topnameLabel = UILabel.init()
        view.addSubview(topnameLabel!)
        topnameLabel?.font = UIFont.systemFont(ofSize: 17)
        topnameLabel?.textColor = .black
        topnameLabel?.text = "天天拆红包"
        topnameLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo((leftImageView?.snp.right)!).offset(15)
            make.top.equalToSuperview().offset(50)
            make.width.equalTo(100)
            make.height.equalTo(30)
        })
        subNameLabel = UILabel.init()
        view.addSubview(subNameLabel!)
        subNameLabel?.font = UIFont.systemFont(ofSize: 13)
        subNameLabel?.textColor = .lightGray
        subNameLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        subNameLabel?.numberOfLines = 0
        subNameLabel?.text = "天天拆红包"
        subNameLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo((leftImageView?.snp.right)!).offset(15)
            make.top.equalTo((topnameLabel?.snp.bottom)!).offset(1)
            make.width.equalTo(kScreenW * 0.4)
            make.height.equalTo(40)
        
        })
        
        rightbtn = UIButton.init()
        view.addSubview(rightbtn!)
        rightbtn?.setTitle("一键推广", for: .normal)
        rightbtn?.setTitleColor(.white, for: .normal)
        rightbtn?.layer.cornerRadius = 5
        rightbtn?.layer.masksToBounds = true
        rightbtn?.snp.makeConstraints({ (make) in
            make.width.equalTo(80)
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(50)
        })
        rightbtn?.gradientColor(CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0), kCGGradientColors)
//        rightbtn?.addTarget(self, action: #selector(Spread), for: .touchUpInside)
        
        bottomLabel = UILabel.init()
        view.addSubview(bottomLabel!)
        bottomLabel?.font = UIFont.systemFont(ofSize: 12)
        bottomLabel?.textColor = .lightGray
        bottomLabel?.text = "最高赚90%"
        bottomLabel?.snp.makeConstraints({ (make) in
            make.height.equalTo(20)
            make.width.equalTo(70)
            make.top.equalTo((rightbtn?.snp.bottom)!).offset(2)
            make.right.equalToSuperview().offset(-29)
        })
        
    }
//    @objc func Spread(){
//        navi?.pushViewController(PddSpreadViewController(), animated: true)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
