//
//  GeofenceActionTableViewCell.swift
//  LeChangeOverseas
//
//  Created by lechech on 2019/3/11.
//  Copyright © 2019 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

import UIKit


class GeofenceActionTableViewCell: UITableViewCell,IDHTableViewCell {

    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var deviceImage: UIImageView!
    @IBOutlet weak var switchBtn: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
