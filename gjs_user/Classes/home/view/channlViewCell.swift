//
//  channlViewCell.swift
//  test
//
//  Created by 大杉网络 on 2019/8/5.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class channlViewCell: UICollectionViewCell {
//    var label : UILabel!
    
    @IBOutlet weak var channlImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var channlLabel: UILabel!
    
    
     var ClassfiyModelTitle: HWGeneralModel! {
        didSet{
            
            self.channlLabel.text = ClassfiyModelTitle.main_name
        }
    }
    
    var ClassfiyModelImg : HWInfoListModel!{
        didSet{
            
            let url = URL(string: ClassfiyModelImg.imgurl ?? "")
            self.channlImage.kf.setImage(with: url)
        }
    }
    
    

}
