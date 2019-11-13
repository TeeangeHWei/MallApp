//
//  TimeListView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/29.
//  Copyright © 2019 大杉网络. All rights reserved.
//


class TimeListView: UIView {
    
    private var timeLabelArr = [UILabel]()
    private var statusLabelArr = [UILabel]()
    var changeIndex = 0
    var backFunc : ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, getData: @escaping(_ index : Int) -> Void) {
        self.init(frame: frame)
        
        backFunc = getData
        // 时间场次
        let timeList = self
        timeList.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        timeList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .center
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(70)
            layout.position = .absolute
            layout.top = 0
            layout.left = 0
        }
        // 时间点
        let hour = Int(Date().format("HH"))
        let timeArr = ["00:00", "10:00", "12:00", "15:00", "20:00"]
        var timeArr1:ArraySlice<String> = ["00:00", "10:00", "12:00", "15:00"]
        var timeIndex = 0
        if hour! < 10 {
            timeIndex = 0
        } else if hour! < 12 {
            timeIndex = 1
        } else if hour! < 15 {
            timeIndex = 2
        } else if hour! < 20 {
            timeIndex = 3
        } else if hour! >= 20 {
            timeIndex = 4
        }
        backFunc!(timeIndex + 6)
        if hour! >= 15 {
            timeArr1 = timeArr[1...4]
        } else {
            timeArr1 = timeArr[0...3]
        }
        // 时间点
        for (index, item) in timeArr1.enumerated(){
            if timeIndex > 2 {
                changeIndex = timeIndex - 1
            } else {
                changeIndex = timeIndex
            }
            let timeItem = UIButton()
            timeItem.addTarget(self, action: #selector(timeChange), for: .touchUpInside)
            timeItem.tag = index
            timeItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.flexDirection = .column
                layout.alignItems = .center
                layout.justifyContent = .center
                layout.width = YGValue((kScreenW - 30) * 0.25)
                layout.height = YGValue(70)
            }
            timeList.addSubview(timeItem)
            let itemTime = UILabel()
            itemTime.text = item
            itemTime.textAlignment = .center
            itemTime.font = FontSize(18)
            itemTime.layer.cornerRadius = 12
            itemTime.layer.masksToBounds = true
            timeLabelArr.append(itemTime)
            if index == changeIndex {
                itemTime.backgroundColor = .white
                itemTime.textColor = kLowOrangeColor
            } else {
                itemTime.backgroundColor = .clear
                itemTime.textColor = colorwithRGBA(255, 233, 219, 1)
            }
            itemTime.configureLayout { (layout) in
                layout.isEnabled = true
                layout.marginBottom = 5
                layout.height = 24
                layout.paddingLeft = 10
                layout.paddingRight = 10
            }
            timeItem.addSubview(itemTime)
            let itemStatus = UILabel()
            statusLabelArr.append(itemStatus)
            itemStatus.font = FontSize(12)
            if index == changeIndex {
                itemStatus.text = "抢购进行中"
                itemStatus.textColor = .white
            } else if index < changeIndex {
                itemStatus.text = "已开抢"
                itemStatus.textColor = colorwithRGBA(255, 233, 219, 1)
            } else if index > changeIndex {
                itemStatus.text = "即将开抢"
                itemStatus.textColor = colorwithRGBA(255, 233, 219, 1)
            }
            itemStatus.configureLayout { (layout) in
                layout.isEnabled = true
            }
            timeItem.addSubview(itemStatus)
        }
        timeList.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func timeChange (_ btn: UIButton) {
        let tag = btn.tag
        timeLabelArr[tag].backgroundColor = .white
        timeLabelArr[tag].textColor = kLowOrangeColor
        timeLabelArr[changeIndex].backgroundColor = .clear
        timeLabelArr[changeIndex].textColor = colorwithRGBA(255, 233, 219, 1)
        statusLabelArr[tag].textColor = .white
        statusLabelArr[changeIndex].textColor = colorwithRGBA(255, 233, 219, 1)
        changeIndex = tag
        backFunc!(tag + 6)
    }
    
}
