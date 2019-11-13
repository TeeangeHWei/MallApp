import UIKit

//UIPickerView 的委托协议是 UIPickerViewDelegate，数据源是 UIPickerViewDataSource。我们需要在视图控制器中声明实现 UIPiekerViewDelegate 和 UIPickerViewDataSource 协议。
class SelectorController: ViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var pickerView: UIPickerView!
    var currentSelectRow : NSInteger = 0
    
    var pickerProvincesData: [String] = ["放假","旅游","上班","上班","上班"] //第一级数据
    var pickerCitiesData: [String] = ["写代码","玩游戏","泡妹子","泡妹子","泡妹子"]//第二级数据
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = colorwithRGBA(0, 0, 0, 0.5)
        self.view.isUserInteractionEnabled = true
        self.view.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH)
            layout.position = .relative
        }
        
        let selectorBox = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 190))
        selectorBox.addBorder(side: .top, thickness: 1, color: klineColor)
        selectorBox.backgroundColor = .white
        selectorBox.layer.mask = selectorBox.configRectCorner(view: selectorBox, corner: [.bottomLeft, .bottomRight], radii: CGSize(width: 10, height: 10))
        selectorBox.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = 190
            layout.position = .absolute
            layout.left = 0
            layout.top = 0
        }
        self.view.addSubview(selectorBox)
        // 按钮
        let selectorBtns = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 40))
        selectorBtns.addBorder(side: .bottom, thickness: 1, color: klineColor)
        selectorBtns.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.paddingLeft = 15
            layout.paddingRight = 15
            layout.height = 40
        }
        selectorBox.addSubview(selectorBtns)
        let cancel = UIButton()
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(kLowGrayColor, for: .normal)
        cancel.titleLabel?.font = FontSize(14)
        cancel.configureLayout { (layout) in
            layout.isEnabled = true
        }
        selectorBtns.addSubview(cancel)
        let select = UIButton()
        select.setTitle("确定", for: .normal)
        select.setTitleColor(kLowOrangeColor, for: .normal)
        select.titleLabel?.font = FontSize(14)
        select.configureLayout { (layout) in
            layout.isEnabled = true
        }
        selectorBtns.addSubview(select)
        
        // 选择器
        self.pickerView = UIPickerView(frame: CGRect(x:0, y: 0,width: kScreenW, height: 150))
        self.pickerView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = 150
        }
        //因为该Controller中实现了UIPickerViewDataSource接口所以将dataSource设置成自己
        self.pickerView.dataSource = self
        //将delegate设置成自己
        self.pickerView.delegate = self
        selectorBox.addSubview(self.pickerView)
        
        
        self.view.yoga.applyLayout(preservingOrigin: true)
        
    }
    
    // UIPickerView 有幾列可以選擇
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // UIPickerView 各列有多少行資料
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        // 設置第一列時
        if component == 0 {
            // 返回陣列 week 的成員數量
            return pickerProvincesData.count
        }

        // 否則就是設置第二列
        // 返回陣列 meals 的成員數量
        return pickerCitiesData.count
    }
    
    // UIPickerView 每個選項顯示的資料
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int, forComponent component: Int)
        -> String {
            // 設置第一列時
            if component == 0 {
                // 設置為陣列 week 的第 row 項資料
                return pickerProvincesData[row]
            } else {
                // 否則就是設置第二列
                // 設置為陣列 meals 的第 row 項資料
                return pickerCitiesData[row]
            }
    }
    
    // UIPickerView 改變選擇後執行的動作
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int, inComponent component: Int) {
        // 改變第一列時
        if component == 0 {

        } else {
            // 否則就是改變第二列

        }

        // 將改變的結果印出來
        print("選擇的是 \(pickerProvincesData[row]) ， \(pickerCitiesData[row])")
    }
}
