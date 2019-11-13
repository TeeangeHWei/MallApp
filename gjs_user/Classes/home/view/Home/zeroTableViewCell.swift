//
//  zeroTableViewCell.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/28.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit
import SwiftDate
@available(iOS 11.0, *)
class zeroTableViewCell: UITableViewCell {
    let countDownTimer = WMCountDown()
    fileprivate static let cellID = "zeroTableViewCellID"
    fileprivate var zeroCollView : UICollectionView!
    fileprivate var codeTimer:DispatchSourceTimer?
    var hourLabel : UILabel!
    var minLabel : UILabel!
    var secLabel : UILabel!
    var endtime : String!
    
    weak var naviController : UINavigationController?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    deinit {
        countDownTimer.stop()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
        makeUI()
        timer()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 自己定义方法 初始化cell 复用
    class func dequeue(_ tableView : UITableView) -> zeroTableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? zeroTableViewCell {
            return cell
        }
        let cell = zeroTableViewCell.init(style: .default, reuseIdentifier: cellID)
        return cell
    }
    
    
}

@available(iOS 11.0, *)
extension zeroTableViewCell{
    //日期 -> 字符串
    func date2String(_ date:Date, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
    
    //字符串 -> 日期
    func string2Date(_ string:String, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        return date!
    }
    //MARK: -时间转时间戳函数
    func timeToTimeStamp(time: String ,inputFormatter:String) -> Double {
        let dfmatter = DateFormatter()
       //设定时间格式,这里可以设置成自己需要的格式
        dfmatter.dateFormat = inputFormatter
        let last = dfmatter.date(from: time)
        let timeStamp = last?.timeIntervalSince1970
        return timeStamp!
    }
    
    fileprivate func timer(){
        countDownTimer.countDown = { [weak self] (d, h, m, s) in
            self?.hourLabel?.text = "\(h)"
            self?.minLabel?.text = "\(m)"
            self?.secLabel?.text = "\(s)"
        }
        
        //获取当前时间
        let date = Date()
        let dateYMD = date2String(date, dateFormat: "yyyy-MM-dd")
        let dateHMS = date2String(date,dateFormat: "HH:mm:ss")
        let time1 = date2String(date - 1.seconds, dateFormat: "HH:mm:ss")
        let dateStamp = timeToTimeStamp(time: dateHMS, inputFormatter: "HH:mm:ss")
        
        let EndTimeStamp10 = timeToTimeStamp(time: "10:00:00", inputFormatter: "HH:mm:ss")
        let EndTimeStamp12 = timeToTimeStamp(time: "12:00:00", inputFormatter: "HH:mm:ss")
        let EndTimeStamp15 = timeToTimeStamp(time: "15:00:00", inputFormatter: "HH:mm:ss")
        let EndTimeStamp20 = timeToTimeStamp(time: "20:00:00", inputFormatter: "HH:mm:ss")
        let EndTimeStamp24 = timeToTimeStamp(time: "23:59:59", inputFormatter: "HH:mm:ss")
        if dateStamp < EndTimeStamp10 {
            countDownTimer.resume()
            countDownTimer.start(with: nil, end: "\(dateYMD) 10:00:00")
        }else if dateStamp < EndTimeStamp12{
             countDownTimer.resume()
             countDownTimer.start(with: nil, end: "\(dateYMD) 12:00:00")
        }else if dateStamp < EndTimeStamp15{
            countDownTimer.resume()
            countDownTimer.start(with: nil, end: "\(dateYMD) 15:00:00")
        }else if dateStamp < EndTimeStamp20{
            countDownTimer.resume()
            countDownTimer.start(with: nil, end: "\(dateYMD) 20:00:00")
        }else if dateStamp < EndTimeStamp24{
            countDownTimer.resume()
            countDownTimer.start(with: nil, end: "\(dateYMD) 23:59:59")
        }
    }
    
    fileprivate func makeUI(){
        
        
         let zerocontentview = contentView
    
        // 在这个cell 里面  添加个  collectionView
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
       
        let zeroview = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        zeroview.backgroundColor = colorwithRGBA(245, 245, 245, 1)
        zeroview.showsVerticalScrollIndicator = false
        zeroview.showsHorizontalScrollIndicator = false
        zeroview.isScrollEnabled = false
        self.zeroCollView = zeroview
        zerocontentview.addSubview(zeroview)
        
        zeroview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let zerobuyView = UIView.init()
        zerobuyView.backgroundColor = .white
        self.zeroCollView.addSubview(zerobuyView)
        zerobuyView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview()
            make.width.equalTo(kScreenW * 0.42)
            make.height.equalTo(175)
        }
        
        
        let zeroRushBtn = UIButton.init()
        zeroRushBtn.setImage(UIImage(named: "guanfang") , for: .normal)
        zeroRushBtn.addTarget(self, action: #selector(toOfficial), for: .touchUpInside)
        zeroRushBtn.backgroundColor = UIColor.clear
        zerobuyView.addSubview(zeroRushBtn)
        zeroRushBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(25)
            make.width.equalTo(kScreenW * 0.3)
            make.height.equalTo((kScreenW * 0.3)/0.73)
            
            
        }
        
        let xianshiView = UIImageView.init()
        xianshiView.backgroundColor = .white
        let xianshiTapGesture = UITapGestureRecognizer(target: self, action: #selector(xianshiClick))
        xianshiView.addGestureRecognizer(xianshiTapGesture)
        xianshiView.isUserInteractionEnabled = true
        self.zeroCollView.addSubview(xianshiView)
        xianshiView.snp.makeConstraints { (make) in
            make.left.equalTo(zerobuyView.snp.right).offset(2)
            make.top.equalToSuperview().offset(5)
            make.width.equalTo(kScreenW * 0.58)
            make.height.equalTo(93.5)
        }
        
       
        let darenView = UIView.init()
        darenView.backgroundColor = .white
        self.zeroCollView.addSubview(darenView)
        darenView.snp.makeConstraints { (make) in
            make.left.equalTo(zerobuyView.snp.right).offset(2)
            make.top.equalTo(xianshiView.snp.bottom).offset(2)
            make.width.equalTo(kScreenW * 0.6)
            make.height.equalTo(80)
        }
        
        let countdownView = UIView.init()
        countdownView.backgroundColor = .clear
        xianshiView.addSubview(countdownView)
        countdownView.snp.makeConstraints { (make) in
            make.height.equalTo(93.5)
            make.width.equalTo(88)
            make.left.equalToSuperview()
            
        }
        
        let xsqgImg = UIImageView.init()
        xsqgImg.image = UIImage(named: "xsqg_01")
        xsqgImg.contentMode = .scaleAspectFit
        xsqgImg.backgroundColor = .white
        countdownView.addSubview(xsqgImg)
        xsqgImg.snp.makeConstraints { (make) in
            make.height.equalTo((kScreenW/6.23)-16)
            make.width.equalTo(kScreenW/6.23)
            make.top.equalTo(2)
            make.left.equalTo(10)
            
        }
        let xianshirightImg = UIImageView.init()
        xianshirightImg.contentMode = .scaleAspectFit
        xianshirightImg.backgroundColor = .white
        xianshirightImg.image = UIImage(named: "xsqg")
        xianshiView.addSubview(xianshirightImg)
        xianshirightImg.snp.makeConstraints { (make) in
            make.height.equalTo(65)
            make.width.equalTo(kScreenW * 0.3)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalTo(-15)
        }
        
        
        let darenBtn = UIButton.init()
        darenBtn.setImage(UIImage(named: "daren"), for: .normal)
        darenBtn.backgroundColor = UIColor.clear
        darenBtn.contentMode = .scaleAspectFit
        darenView.addSubview(darenBtn)
        darenBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.height.equalTo((kScreenW/4.5)-20)
            make.width.equalTo(kScreenW/4.5)
            make.left.equalToSuperview().offset(15)
        }
        darenBtn.addTarget(self, action: #selector(darenclick), for: .touchUpInside)
        
        let rankBtb = UIButton.init()
        rankBtb.setImage(UIImage(named: "renqirank"), for: .normal)
        rankBtb.contentMode = .scaleAspectFit
        rankBtb.backgroundColor = UIColor.clear
        darenView.addSubview(rankBtb)
        rankBtb.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo((kScreenW/4.5)-20)
            make.width.equalTo(kScreenW/4.5)
            
        }
         rankBtb.addTarget(self, action: #selector(rankclick), for: .touchUpInside)
        
        let verline = UIView.init()
        verline.backgroundColor = colorwithRGBA(241, 241, 241, 1)
        darenView.addSubview(verline)
        verline.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-5)
            make.top.equalToSuperview()
            make.width.equalTo(2)
            make.height.equalTo(80)
        }
        
        
        //MARK:-- 倒计时view
        // 时间
        let hourView = UIView.init()
        hourView.backgroundColor = .red
        hourView.layer.cornerRadius = 2
        hourView.layer.masksToBounds = true
        countdownView.addSubview(hourView)
        hourView.snp.makeConstraints { (make) in
            make.height.equalTo(18)
            make.width.equalTo(18)
            make.top.equalTo(xsqgImg.snp.bottom).offset(0)
            make.left.equalTo(8)
        }
        // 冒号
        let hourConLabel = UILabel.init()
        hourConLabel.textColor = .black
        hourConLabel.text = ":"
        hourConLabel.textAlignment = .center
        countdownView.addSubview(hourConLabel)
        hourConLabel.snp.makeConstraints { (make) in
            make.height.equalTo(18)
            make.width.equalTo(4)
            make.left.equalTo(hourView.snp.right).offset(1)
            make.top.equalTo(xsqgImg.snp.bottom).offset(0)
        }
        
        // 分
        let minView = UIView.init()
        minView.backgroundColor = .red
        minView.layer.cornerRadius = 2
        minView.layer.masksToBounds = true
        countdownView.addSubview(minView)
        minView.snp.makeConstraints { (make) in
            make.height.equalTo(18)
            make.width.equalTo(18)
            make.top.equalTo(xsqgImg.snp.bottom).offset(0)
            make.left.equalTo(hourConLabel.snp.right).offset(2)
        }
        // 冒号
        let minConLabel = UILabel.init()
        minConLabel.textColor = .black
        minConLabel.text = ":"
        hourConLabel.textAlignment = .center
        countdownView.addSubview(minConLabel)
        minConLabel.snp.makeConstraints { (make) in
            make.height.equalTo(18)
            make.width.equalTo(4)
            make.left.equalTo(minView.snp.right).offset(1)
            make.top.equalTo(xsqgImg.snp.bottom).offset(0)
        }
        // 秒
        let secView = UIView.init()
        secView.backgroundColor = .red
        secView.layer.cornerRadius = 2
        secView.layer.masksToBounds = true
        countdownView.addSubview(secView)
        secView.snp.makeConstraints { (make) in
            make.height.equalTo(18)
            make.width.equalTo(18)
            make.top.equalTo(xsqgImg.snp.bottom).offset(0)
            make.left.equalTo(minConLabel.snp.right).offset(2)
        }
        
        hourLabel = UILabel.init()
        hourLabel.backgroundColor = .clear
        hourLabel.text = "00"
        hourLabel.textColor = .white
        hourLabel.textAlignment = .center
        hourLabel.font = UIFont.boldSystemFont(ofSize: 12)
        hourView.addSubview(hourLabel)
        hourLabel.snp.makeConstraints { (make) in
            make.width.equalTo(18)
            make.height.equalTo(18)
            
        }
        minLabel = UILabel.init()
        minLabel.backgroundColor = .clear
        minLabel.text = "00"
        minLabel.textColor = .white
        minLabel.textAlignment = .center
        minLabel.font = UIFont.boldSystemFont(ofSize: 12)
        minView.addSubview(minLabel)
        minLabel.snp.makeConstraints { (make) in
            make.width.equalTo(18)
            make.height.equalTo(18)
            
        }
        secLabel = UILabel.init()
        secLabel.text = "00"
        secLabel.backgroundColor = .clear
        secLabel.textColor = .white
        secLabel.textAlignment = .center
        secLabel.font = UIFont.boldSystemFont(ofSize: 12)
        secView.addSubview(secLabel)
        secLabel.snp.makeConstraints { (make) in
            make.width.equalTo(18)
            make.height.equalTo(18)
        }
        
        
    }
    @objc func darenclick(){
        naviController?.pushViewController(ExpertArticleController(), animated: true)
    }
    @objc func rankclick(){
        naviController?.pushViewController(RankingListController(), animated: true)
    }
    @objc func xianshiClick(){
        naviController?.pushViewController(SeckillController(), animated: true)
    }
    @objc func toOfficial (_ btn : UIButton) {
        self.naviController?.pushViewController(OfficialController(), animated: true)
    }
}
