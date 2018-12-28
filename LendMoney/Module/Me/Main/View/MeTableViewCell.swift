//
//  MeTableViewCell.swift
//  SwiftDemo
//
//  Created by lechech on 2018/7/9.
//  Copyright © 2018年 lichengchuan. All rights reserved.
//

import UIKit

class MeTableViewCell: UITableViewCell {
    
    
    //MARK: -🍇property
    public var style : MeViewCellStyle = MeViewCellStyle.normalStyle {
        didSet{
            print("lcc123")
        }
    }


    //Mark: -🍍convenience initializer
    public convenience init(meCellStyle: MeViewCellStyle, reuseIdentifier: String?) {
        if meCellStyle == MeViewCellStyle.normalStyle {
            self.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        }else {
            self.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        }
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
    }
    
 
    //Mark: -🍎override method
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
