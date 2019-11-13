//
//  saveMoneyTableViewCell.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/2.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class saveMoneyTableViewCell: UITableViewCell {
    fileprivate static let cellID = "saveMoneyTableViewCellID"
    fileprivate var saveMoneyCollView : UICollectionView!
    weak var naviController : UINavigationController?
    var rollView : YPRollNoticeView?
    var modelArr : Array<String>! {
        didSet {
            rollView?.rollArray = self.modelArr
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
    class func dequeue(_ tableView : UITableView) -> saveMoneyTableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? saveMoneyTableViewCell {
            return cell
        }
        let cell = saveMoneyTableViewCell.init(style: .default, reuseIdentifier: cellID)
        return cell
    }
    
}

@available(iOS 11.0, *)
extension saveMoneyTableViewCell{
     fileprivate func makeUI(){
        rollView = YPRollNoticeView.init()
        // 此处 点击回调
        rollView!.clickBlock = {model in
            let vc = DetailController()
            detailId = Int(pamaid[model])!
            self.naviController?.pushViewController(vc, animated: true)
        }
        let savemoneycontentview = contentView
        // 在这个cell 里面  添加个  collectionView
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let  saveView = UIView.init()
        saveView.backgroundColor = .white
        saveView.layer.masksToBounds = true
        saveView.layer.cornerRadius = 4
        savemoneycontentview.addSubview(saveView)
        saveView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
        let saveimg = UIImageView.init()
        saveimg.image = UIImage(named: "save_fast")
        savemoneycontentview.addSubview(saveimg)
        saveimg.contentMode = .scaleAspectFit
        saveimg.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(9)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(18)
            make.width.equalTo(83)
        }

        savemoneycontentview.addSubview(rollView!)
        rollView!.snp.makeConstraints { (make) in
            make.left.equalTo(saveimg.snp.right).offset(9)
            make.top.equalTo(4)
            make.width.equalToSuperview().offset(-148)
            make.height.equalTo(30)

        }
        let rightbtn = UIButton.init()
        rightbtn.setImage(UIImage(named: "right_save"), for: .normal)
        savemoneycontentview.addSubview(rightbtn)
        rightbtn.snp.makeConstraints { (make) in
            make.right.equalTo(-18)
            make.top.equalTo(4)
            make.height.equalTo(5)
            make.width.equalTo(15)
            make.bottom.equalTo(0)
        }
        let grayline = UIView.init(frame: CGRect(x: 9, y: 0, width: kScreenW - 17, height: 1))
        grayline.backgroundColor = colorwithRGBA(241, 241, 241, 1)
        savemoneycontentview.addSubview(grayline)
        
        
    }
    
}
