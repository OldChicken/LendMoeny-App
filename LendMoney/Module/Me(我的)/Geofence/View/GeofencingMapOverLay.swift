//
//  GeofencingMapOverLay.swift
//  SwiftDemo
//
//  Created by lechech on 2018/11/15.
//  Copyright © 2018 lichengchuan. All rights reserved.
//

import UIKit
import SnapKit

class GeofencingMapOverLay: UIView {
    
    var cornerRadis: Int = 0 {
        didSet{
            if cornerRadis < 1000 {
                radiusLabel.text = "\(cornerRadis)" + "m"
            }else {
                radiusLabel.text = "\(cornerRadis/1000)" + "km"
            }
        }
    }
    
    lazy var radiusLabel: UILabel = {
        let result = UILabel.init()
        result.font = UIFont.systemFont(ofSize: 13)
        result.textAlignment = .center
        result.textColor = UIColor.lcc_colorWithHexString(hexadecimal: "#0B9C0d")
        result.text = ""
        return result
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0.5, alpha: 0.1)
        self.isUserInteractionEnabled = false
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lcc_colorWithHexString(hexadecimal: "#0B9C0d").cgColor
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        
        //圆心
        let circleCenter = UIImageView.init()
        circleCenter.image = UIImage.init(named: "genfence_icon_location")
        self.addSubview(circleCenter)
        circleCenter.snp.makeConstraints { (maker) in
            maker.height.equalTo(30)
            maker.width.equalTo(20)
            maker.centerX.equalTo(self)
            maker.bottom.equalTo(self.snp.centerY)
        }

        //半径线
        let radiusLine = UIView.init()
        self.addSubview(radiusLine)
        radiusLine.backgroundColor = UIColor.lcc_colorWithHexString(hexadecimal: "#0B9C0d")
        radiusLine.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(self)
            maker.height.equalTo(0.5)
            maker.centerY.equalTo(self)
            maker.width.equalTo(self).multipliedBy(0.5)
        }

        //半径显示器
        self.addSubview(radiusLabel)
        radiusLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(radiusLine)
            maker.bottom.equalTo(radiusLine).offset(-5)
        }
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cornerRadius = self.frame.width / 2
        self.layer.cornerRadius = cornerRadius
    }
    
    

}
