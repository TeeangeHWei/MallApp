//
//  MenuTableViewCell.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/22.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class MenuTableViewCell: UITableViewCell,UIScrollViewDelegate{
    private var pageView : UIView!
    private var rollLine : UIView!
    var iconwidth : Int?
    private var itemWidth: CGFloat {
        get {
            return CGFloat(kScreenW / 5) //item 宽度
        }
    }
    private var itemHeight: CGFloat {
        get {
            return CGFloat(self.itemWidth * 1.17) //item 高度
        }
    }
    fileprivate static let cellID = "MenuTableViewCellID"
    fileprivate var collectionView : UICollectionView!
    weak var naviController: UINavigationController?
    
    func getUnitWidth(count:Int,width:CGFloat) ->CGFloat {
        let page = (CGFloat(count) / CGFloat(9))
        let rollWidth = CGFloat(width) / page
        return rollWidth
    }
    let PageViewWidth:CGFloat = 60
    var iconArr : Array<homeiconModel>!{
        didSet{
            var rollWidth = getUnitWidth(count: self.iconArr.count, width:PageViewWidth)
            if self.iconArr.count > 0 {
                let arrC = self.iconArr.count
                if (arrC % 10) != 0 {
                    let yy = arrC % 10
                    let xx = 10 - yy
                    for _ in 1...xx {
                        var model = homeiconModel()
                        self.iconArr.append(model)
                    }
                }
                let view = self.contentView
                let pageV = UIView()
                pageV.layer.cornerRadius = 2
                pageV.layer.masksToBounds = true
                pageV.backgroundColor = colorwithRGBA(255, 236, 244, 2)
                addSubview(pageV)
                self.pageView = pageV
                pageV.snp.makeConstraints { (make) in
                    make.top.equalTo(view.snp.bottom).offset(-5)
                    make.centerX.equalToSuperview()
                    make.width.equalTo(PageViewWidth)
                    make.height.equalTo(4)
                }
                let rollV = UIView()
                rollV.layer.cornerRadius = 2
                rollV.layer.masksToBounds = true
                rollV.backgroundColor = colorwithRGBA(252, 124, 98, 1)
                pageV.addSubview(rollV)
                self.rollLine = rollV
                rollV.snp.makeConstraints { (make) in
                    make.top.left.bottom.equalToSuperview()
                    make.width.equalTo(rollWidth)
                }
                if self.iconArr.count <= 10{
                    pageView.isHidden = true
                    rollLine.isHidden = true
                }
                self.collectionView.reloadData()
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.1) {
            let offset: CGPoint = scrollView.contentOffset
            var frame : CGRect   = self.rollLine.frame
            
            frame.origin.x = 0 + offset.x * (self.pageView.frame.size.width - self.rollLine.frame.size.width) / (scrollView.contentSize.width - scrollView.frame.size.width)
            
            self.rollLine.frame = frame
            
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        self.makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func dequeue(_ tableView : UITableView) -> MenuTableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? MenuTableViewCell {
            return cell
        }
        let cell = MenuTableViewCell.init(style: .default, reuseIdentifier: cellID)
        return cell
    }
    
    
    
}

@available(iOS 11.0, *)
extension MenuTableViewCell {
    fileprivate func makeUI(){
        var rollWidth = getUnitWidth(count: self.iconwidth ?? 12, width:PageViewWidth)
//        print("itemsize::",rollWidth)

        
        let view = self.contentView
        pageView = UIView.init(frame: CGRect(x: 0, y: 0, width: PageViewWidth, height: 4))
        addSubview(pageView)
        rollLine = UIView.init()
        pageView.addSubview(rollLine)
        // 此处搭建 任何 视图
        // 在这个cell 里面  添加个  collectionView
        let layout = DFHorizontalPageLayout()
        layout.itemCountPerRow = 5
        layout.rowCount = 2
        
        layout.itemSize = CGSize(width: itemWidth - 6, height: itemHeight)
        
        print("itemsize::",layout.itemSize)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets.init(top: 1, left: 1, bottom: 1, right: 1)
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.delegate = self
        collView.dataSource = self
        collView.backgroundColor = UIColor.white
        collView.bounces = false
        collView.alwaysBounceHorizontal = true
        collView.alwaysBounceVertical = false
        collView.showsHorizontalScrollIndicator = false
        collView.showsVerticalScrollIndicator = false
//        collView.isScrollEnabled = true
        collView.backgroundColor = UIColor.clear
        self.collectionView = collView
//        let viewHeight = (kScreenW / 5 * 1.3)
        view.addSubview(collView)
        let viewHeight = (kScreenW / 5 * 1.3)
        collView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(viewHeight * 2)
        }
        
        
        
        // collView 视图 距离上下左右边距
        collView.contentInset = UIEdgeInsets.init(top: 5, left: 15, bottom: 5, right: 2)
        
        // 注册cell
        collView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collCellID")
    }
}
@available(iOS 10.2.0, *)
@available(iOS 11.0, *)
extension MenuTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.iconArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 创建 UICollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCellID", for: indexPath)

        let imgView : UIImageView!
        let titleLab : UILabel!
        
        // 避免重用
        if cell.contentView.subviews.count > 0 {
            imgView = cell.contentView.subviews[0] as? UIImageView
            titleLab = cell.contentView.subviews[1] as? UILabel
        }else {
            
            imgView = UIImageView.init()	
            imgView.backgroundColor = UIColor.clear
            imgView.layer.masksToBounds = true
            imgView.layer.cornerRadius = 20
            cell.contentView.addSubview(imgView)
            imgView.snp.makeConstraints { (make) in
                make.size.equalTo(45)
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            
            
            titleLab = UILabel.init()
            titleLab.font = UIFont.systemFont(ofSize: 13)
            titleLab.textColor = UIColor.black
            titleLab.textAlignment = .center
            cell.contentView.addSubview(titleLab)
            titleLab.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(imgView.snp.bottom).offset(10)
            }
        }
        let model = self.iconArr[indexPath.row]
        if model.iconName != nil {
            titleLab.isHidden = false
            imgView.isHidden = false
            titleLab.text = model.iconName
            if let icon =  model.iconUrl {
                let imgUrl = URL.init(string: AlamofireUtil.BASE_IMG_URL + icon )!
                imgView.af_setImage(withURL: imgUrl)
            }
        }else {
            titleLab.isHidden = true
            imgView.isHidden = true
        }
        return cell
    }
    //MARK:-- Swift4中String转为控制器的方法
    func stringToViewController(_ controllerName:String) -> UIViewController{
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        
        let cls:AnyClass = NSClassFromString(namespace + "." + controllerName)!
        
        let vcCls = cls as! UIViewController.Type
        
        let vc = vcCls.init()
        
        return vc
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.iconArr[indexPath.row]
        print("选中了 \(model.iconName) \(indexPath.row)个")
        
        // 点击 事件处理
        if let link = iconArr[indexPath.row].link {
            let jhs = stringToViewController(link)
            naviController?.pushViewController(jhs, animated: true)
        }
    }
}
