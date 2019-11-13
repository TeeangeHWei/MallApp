//
//  HomeClassiewCell.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/11/6.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

import UIKit
@available(iOS 11.0, *)
protocol HomeClassiewCellDelegate : NSObjectProtocol {
    /// 内容点击回调
    func commentClickDelegate(_ cell : HomeClassiewCell, withModel model : goodsItem)
}

@available(iOS 11.0, *)
class HomeClassiewCell: UITableViewCell {
    
    fileprivate static let cellID = "HomeClassiewCellID"
    weak var Home_delegate : HomeClassiewCellDelegate?
    
    fileprivate var ClassheadView : UIView!
    var firstCard : Bool = false    // 是否 第一张卡片
    fileprivate var ClasscardView : NewGoodsItemView!
    var model : goodsItem! {
        didSet {
            if self.firstCard {
                self.ClassheadView.isHidden = false
                self.ClasscardView.frame = CGRect.init(x: 10, y: 5, width: ScreenW - 20, height: 120)
            }else {
                self.ClassheadView.isHidden = true
                self.ClasscardView.frame = CGRect.init(x: 10, y: 5, width: ScreenW - 20, height: 120)
            }
            self.ClasscardView.getDataToView(model)
            
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
    class func dequeue(_ tableView : UITableView) -> HomeClassiewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? HomeClassiewCell {
            return cell
        }
        let cell = HomeClassiewCell.init(style: .default, reuseIdentifier: cellID)
        return cell
    }
    
    
    
}
@available(iOS 11.0, *)
extension HomeClassiewCell {
    fileprivate func makeUI(){
        let recommendview = self.contentView
        
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 0))
        headerView.backgroundColor = .white
        recommendview.addSubview(headerView)
        self.ClassheadView = headerView

        
        let goodsItem = NewGoodsItemView(frame: CGRect(x: 0, y: 50, width: kScreenW, height: 100))
        
        recommendview.addSubview(goodsItem)
        self.ClasscardView = goodsItem
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(itemClick(_:)))
        goodsItem.addGestureRecognizer(tap)
    }
    // goodsItem 视图 点击 回调
    @objc func itemClick(_ tap : UITapGestureRecognizer) {
        if let delegate = self.Home_delegate {
            delegate.commentClickDelegate(self, withModel: self.model)
        }
    }
}

