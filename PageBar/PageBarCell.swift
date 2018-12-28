//
//  PageBarCell.swift
//  DemoTest
//
//  Created by fumi on 2018/12/28.
//  Copyright © 2018 rayor. All rights reserved.
//

import UIKit

class PageBarCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomLine: UIView!
    
    var cellSelected:Bool = false {
        didSet {
            self.bottomLine.isHidden = !cellSelected
            self.titleLabel.textColor = cellSelected ? UIColor.red : UIColor.darkText
        }
    }
    var title:String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
