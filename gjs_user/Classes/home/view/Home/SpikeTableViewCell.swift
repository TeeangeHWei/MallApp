//
//  SpikeTableViewCell.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/26.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class SpikeTableViewCell: UITableViewCell {
    fileprivate static let cellID = "SpikeTableViewCellID"
    fileprivate var SpikeCollView : UICollectionView!
    weak var naviController : UINavigationController?
    // 原价label 富文本中划线
    fileprivate var oriprice : UILabel!
    var dataArr : Array<SpikeModel>! {
        didSet{
            self.SpikeCollView.reloadData()
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
    // 自己定义方法 初始化cell 复用
    class func dequeue(_ tableView : UITableView) -> SpikeTableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? SpikeTableViewCell {
            return cell
        }
        let cell = SpikeTableViewCell.init(style: .default, reuseIdentifier: cellID)
        return cell
    }
}


@available(iOS 11.0, *)
extension SpikeTableViewCell {
    fileprivate func makeUI(){
        
        let spikeView = self.contentView
        
        // 此处搭建 任何 视图
        
        // 在这个cell 里面  添加个  collectionView
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 100, height: 90)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        // 设置横向滑动
        layout.scrollDirection = .horizontal
        
        let SpicollView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        SpicollView.delegate = self
        SpicollView.dataSource = self
        SpicollView.layer.masksToBounds = true
        SpicollView.layer.cornerRadius = 4
        SpicollView.backgroundColor = UIColor.white
        SpicollView.showsVerticalScrollIndicator = false
        SpicollView.showsHorizontalScrollIndicator = false
        
        self.SpikeCollView = SpicollView
        spikeView.addSubview(SpicollView)
        SpicollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(0)
            
        }
        //赶紧秒杀图片
        let hurryImg = UIImageView.init()
        hurryImg.image = UIImage(named: "home_Spike")
        spikeView.addSubview(hurryImg)
        hurryImg.snp.makeConstraints { (make) in
            make.width.equalTo(85)
            make.height.equalTo(20)
            make.leftMargin.equalTo(11)
            make.topMargin.equalTo(12)
        }
        
        
        // 更多秒杀按钮
        let MoreSpikebtn = UIButton.init()
        MoreSpikebtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        MoreSpikebtn.setTitle("更多秒杀", for: .normal)
        // 根据按钮偏移量 调换按钮与图片位置
        MoreSpikebtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -140)
        MoreSpikebtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
        MoreSpikebtn.setTitleColor(colorwithRGBA(248, 14, 0, 0.8), for: .normal)
        MoreSpikebtn.setImage(UIImage(named: "Spike_right"), for: .normal)
        MoreSpikebtn.addTarget(self, action: #selector(moreclick), for: .touchUpInside)
        spikeView.addSubview(MoreSpikebtn)
        MoreSpikebtn.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.right.equalTo(-25)
            make.top.equalTo(12)
        }
        // collView 视图 距离上下左右边距
        SpicollView.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 5)
        
        // 注册cell
        SpicollView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "spicollCellID")
        SpicollView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "spicollBtnCellID")
    }
    @objc func moreclick(){
        naviController?.pushViewController(NewListController(), animated: true)
    }
}

@available(iOS 11.0, *)
extension SpikeTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource{
    // collectionview 分组
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    // 根据section 组数显示数据
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return self.dataArr.count
        }else{
            return 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spicollCellID", for: indexPath)
            // 商品图片
            let CommodityimgView : UIImageView!
            // 优惠价
            let SalePriceLabel : UILabel!
            
            if cell.contentView.subviews.count > 0 {
                // 防止复用
                CommodityimgView = cell.contentView.subviews[0] as? UIImageView
                SalePriceLabel = cell.contentView.subviews[1] as? UILabel
                oriprice = cell.contentView.subviews[2] as? UILabel
            }else {
                CommodityimgView = UIImageView.init()
                cell.contentView.addSubview(CommodityimgView)
                CommodityimgView.layer.cornerRadius = 5
                CommodityimgView.layer.masksToBounds = true
                CommodityimgView.snp.makeConstraints { (make) in
                    make.size.equalTo(70)
                    make.width.equalToSuperview().offset(-6)
                    make.top.equalToSuperview().offset(-10)
                    make.centerY.equalToSuperview().offset(-12)
                }
                SalePriceLabel = UILabel.init()
                SalePriceLabel.font = UIFont.systemFont(ofSize: 15)
                SalePriceLabel.textColor = UIColor.red
                SalePriceLabel.textAlignment = .center
                cell.contentView.addSubview(SalePriceLabel)
                SalePriceLabel.snp.makeConstraints { (make) in
                    make.left.equalTo(22)
                    make.top.equalTo(CommodityimgView.snp.bottom).offset(5)
                }
                
                
                let priceString = NSMutableAttributedString.init(string: "")
                priceString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: priceString.length))
                oriprice = UILabel.init()
                oriprice.font = UIFont.systemFont(ofSize: 12)
                oriprice.textColor = UIColor.gray
                oriprice.textAlignment = .center
                oriprice.attributedText = priceString
                cell.contentView.addSubview(oriprice)
                oriprice.snp.makeConstraints { (make) in
                    make.left.equalTo(27)
                    make.top.equalTo(SalePriceLabel.snp.bottom).offset(5)
                }
            }
            
            let model = self.dataArr[indexPath.row]
            if model.itemendprice != nil  {
                SalePriceLabel.text = "¥" + model.itemendprice!
                let imgUrl = URL.init(string: model.itempic ?? "")
                CommodityimgView.kf.setImage(with: imgUrl)
                let priceString = NSMutableAttributedString.init(string: "¥" + model.itemprice!)
                priceString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: priceString.length))
                self.oriprice.attributedText = priceString
                
                
            }
            return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spicollBtnCellID", for: indexPath)
            
            var morebtn : UIButton!
            var moreTitle : UILabel!
            var moreimg : UIImageView!
            
            if cell.contentView.subviews.count > 0 {
                
                morebtn = cell.contentView.subviews[0] as? UIButton
                moreTitle = cell.contentView.subviews[1] as? UILabel
                moreimg = cell.contentView.subviews[2] as? UIImageView
            }else {
                morebtn = UIButton.init()
                morebtn.layer.masksToBounds = true
                morebtn.layer.cornerRadius = 4
                morebtn.backgroundColor = colorwithRGBA(247, 247, 247, 1)
                cell.contentView.addSubview(morebtn)
                morebtn.snp.makeConstraints { (make) in
                    make.height.equalTo(130)
                    make.width.equalTo(45)
                    make.top.equalToSuperview().offset(10)
                }
                
                moreTitle = UILabel.init()
                moreTitle.font = UIFont.systemFont(ofSize: 13)
                moreTitle.textColor = colorwithRGBA(156, 156, 156, 1)
                moreTitle.numberOfLines = 0
                moreTitle.textAlignment = .center
                cell.contentView.addSubview(moreTitle)
                moreTitle.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(30)
                    make.centerX.equalToSuperview()
                    make.width.equalTo(14)
                }
                
                moreimg = UIImageView.init()
                moreimg.image = UIImage(named: "morebtn")
                cell.contentView.addSubview(moreimg)
                moreimg.snp.makeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.top.equalTo(moreTitle.snp.bottom).offset(10)
                    make.width.height.equalTo(15)
                    make.height.equalTo(15)
                }
            }
            
            moreTitle.text = "查看更多"
            morebtn.addTarget(self, action: #selector(moreBtnClick(_:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let model = self.dataArr[indexPath.row]
            
            let vc = DetailController()
            detailId = Int(model.itemid!)!
            naviController?.pushViewController(vc, animated: true)
        }else {
            // 不需要做操作
        }
        
    }
    
    
    @objc func moreBtnClick(_ btn : UIButton) {
        // 查看更多
        naviController?.pushViewController(NewListController(), animated: true)
    }
    
}

@available(iOS 11.0, *)
extension SpikeTableViewCell : UICollectionViewDelegateFlowLayout {
    // 每个layout 大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize.init(width: 100, height: 90)
        }else {
            return CGSize.init(width: 45, height: 135)
        }
    }
}
