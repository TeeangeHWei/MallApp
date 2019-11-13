//
//  recommendTableViewCell.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/3.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit
@available(iOS 11.0, *)
protocol recommendTableViewCellDelegate : NSObjectProtocol {
    /// 内容点击回调
    func commentClickDelegate(_ cell : recommendTableViewCell, withModel model : goodsItem)
}

@available(iOS 11.0, *)
class recommendTableViewCell: UITableViewCell {
    
    fileprivate static let cellID = "recommendViewCellID"
    weak var hw_delegate : recommendTableViewCellDelegate?
    
    fileprivate var headView : UIView!
    var firstCard : Bool = false    // 是否 第一张卡片
    fileprivate var cardView : goodsview!
    var model : goodsItem! {
        didSet {
            if self.firstCard {
                self.headView.isHidden = false
                self.cardView.frame = CGRect.init(x: 10, y: 60, width: ScreenW - 20, height: 120)
            }else {
                self.headView.isHidden = true
                self.cardView.frame = CGRect.init(x: 10, y: 5, width: ScreenW - 20, height: 120)
            }
            self.cardView.getDataToView(model)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
        makeUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 自己定义方法 初始化cell 复用
    class func dequeue(_ tableView : UITableView) -> recommendTableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? recommendTableViewCell {
            return cell
        }
        let cell = recommendTableViewCell.init(style: .default, reuseIdentifier: cellID)
        return cell
    }
    
    
    
}
@available(iOS 11.0, *)
extension recommendTableViewCell {
    fileprivate func makeUI(){
        let recommendview = self.contentView
        
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 50))
        headerView.backgroundColor = .white
        recommendview.addSubview(headerView)
        self.headView = headerView
        
        let commondImg = UIImageView.init()
        commondImg.image = UIImage(named: "recommend")
        headerView.addSubview(commondImg)
        commondImg.snp.makeConstraints { (make) in
            make.leftMargin.equalTo(16)
            make.topMargin.equalTo(10)
            make.height.equalTo(27)
            make.width.equalTo(29.7)
        }
        
        let commondTitle = UILabel.init()
        commondTitle.text = "推荐好券"
        commondTitle.textColor = colorwithRGBA(247, 55, 51, 1)
        commondTitle.font = UIFont.systemFont(ofSize: 15)
        headerView.addSubview(commondTitle)
        commondTitle.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(20)
            make.leftMargin.equalTo(commondImg.snp.right).offset(20)
            make.topMargin.equalTo(commondImg.snp.topMargin).offset(5)
        }
        
        let goodsItem = goodsview(frame: CGRect(x: 0, y: 50, width: kScreenW, height: 100))
        
        recommendview.addSubview(goodsItem)
        self.cardView = goodsItem
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(itemClick(_:)))
        goodsItem.addGestureRecognizer(tap)
    }
    // goodsItem 视图 点击 回调
    @objc func itemClick(_ tap : UITapGestureRecognizer) {
        if let delegate = self.hw_delegate {
            delegate.commentClickDelegate(self, withModel: self.model)
        }
    }
}
