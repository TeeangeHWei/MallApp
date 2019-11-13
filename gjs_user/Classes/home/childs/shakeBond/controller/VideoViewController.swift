//
//  VideoViewController.swift
//  TikTok
//
//  Created by 刘冲 on 2018/12/24.
//  Copyright © 2018 lc. All rights reserved.
//

import UIKit

class VideoViewController: ViewController {
    open var videoIndex : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = customNav(titleStr: "", titleColor: kMainTextColor, border: false)
        self.view.addSubview(nav)
        let label : UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH))
        label.backgroundColor = UIColor.red
        label.textAlignment = NSTextAlignment.center
        label.text = "第\(String(describing: self.videoIndex!))条抖音视频"
        self.view .addSubview(label)
    }
    
    func videoUI(){
        
    }
    


}
