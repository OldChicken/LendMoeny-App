//
//  AdCarouselTableViewCell.swift
//  LendMoney
//
//  Created by lechech on 2019/1/9.
//  Copyright © 2019 CH. All rights reserved.
//

import UIKit

class AdCarouselTableViewCell: UITableViewCell {
    
    class var cellIdentifier: String  {
        return "CarouselCell"
    }
    static var test123 = "CarouselCell"
    
    // 数据源
    let pictures: [String] = ["http://pic29.nipic.com/20130512/12428836_110546647149_2.jpg", "http://pic29.nipic.com/20130512/12428836_110546647149_2.jpg"]

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.createCyclePicture1()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createCyclePicture1() {
        
        
        let caruselView: JCyclePictureView = JCyclePictureView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height), pictures: pictures)
        self.addSubview(caruselView)
        caruselView.direction = .left
        caruselView.autoScrollDelay = 3
        caruselView.pageControlStyle = .center
        caruselView.placeholderImage = #imageLiteral(resourceName: "me_icon_setting")
        caruselView.didTapAtIndexHandle = { index in
            print("点击了第 \(index + 1) 张图片")
        }
        
    }
}
