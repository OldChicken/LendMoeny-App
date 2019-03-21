//
//  GeofencingInfoView.swift
//  SwiftDemo
//
//  Created by lechech on 2018/11/12.
//  Copyright © 2018 lichengchuan. All rights reserved.
//

import UIKit

enum GeofencingStatus {
    case enable                   //有权限,使能打开
    case disable                  //有权限,使能关闭
    case editing                  //编辑状态
    case noPermissionEnable       //无权限,使能打开
    case noPermissionDisable      //无权限,使能关闭
}

protocol GeofencingInfoViewDelegate: class {
    //改变状态
    func transToStatus(status:GeofencingStatus)
    //跳转到围栏消息设置界面
    func pushToGeofenceActionSetting()
}

class GeofencingInfoView: UIView {

    //MARK: override method
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(enableInfoView)
        enableInfoView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self)
        }
        self.addSubview(disableInfoView)
        disableInfoView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self)
        }
        self.addSubview(enableButton)
        enableButton.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self).offset(-20)
            maker.leading.equalTo(self).offset(15)
            maker.trailing.equalTo(self).offset(-15)
            maker.height.equalTo(40 )
        }
        self.addSubview(disableButton)
        disableButton.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self).offset(-20)
            maker.leading.equalTo(self).offset(15)
            maker.trailing.equalTo(self).offset(-15)
            maker.height.equalTo(40 )
        }
        self.addSubview(modifyButton)
        modifyButton.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(disableButton.snp.top).offset(-10)
            maker.leading.equalTo(self).offset(15)
            maker.trailing.equalTo(self).offset(-15)
            maker.height.equalTo(40 )
        }
        self.addSubview(notifySetButton)
        notifySetButton.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(modifyButton.snp.top).offset(-10)
            maker.leading.equalTo(self).offset(15)
            maker.trailing.equalTo(self).offset(-15)
            maker.height.equalTo(40 )
        }
        self.addSubview(okButton)
        okButton.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self).offset(-20)
            maker.leading.equalTo(self).offset(15)
            maker.trailing.equalTo(self).offset(-15)
            maker.height.equalTo(40 )
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: property
    weak var delegate: GeofencingInfoViewDelegate?
    var locationInfoLabel: UILabel?
    var gesTipLabel: UILabel?
    var isOpen: Bool = false
    
    var status: GeofencingStatus = .disable {
        didSet{
            switch status {
                
            case .disable,.noPermissionDisable:
                //显示开启按钮，显示未开启信息
                disableInfoView.isHidden = false
                enableButton.isHidden = false
                enableInfoView.isHidden = true
                gesTipLabel?.isHidden = true
                disableButton.isHidden = true
                okButton.isHidden = true
                modifyButton.isHidden = true
                notifySetButton.isHidden = true
                isOpen = false
            case .enable,.noPermissionEnable:
                //显示关闭按钮，显示编辑按钮，显示开启信息
                disableInfoView.isHidden = true
                enableButton.isHidden = true
                enableInfoView.isHidden = false
                gesTipLabel?.isHidden = true
                disableButton.isHidden = false
                okButton.isHidden = true
                modifyButton.isHidden = false
                notifySetButton.isHidden = false
                isOpen = true
            case .editing:
                //显示编辑按钮，显示开启信息
                disableInfoView.isHidden = true
                enableButton.isHidden = true
                enableInfoView.isHidden = false
                gesTipLabel?.isHidden = false
                disableButton.isHidden = true
                okButton.isHidden = false
                modifyButton.isHidden = true
                notifySetButton.isHidden = true
                isOpen = true
            }
        }
    }

    lazy var enableInfoView: UIView = {
        let result = UIView.init()
        result.backgroundColor = UIColor.white
        result.isHidden = true
        
        //图标
        let locationLogo = UIImageView.init()
        locationLogo.image = UIImage.init(named: "genfence_icon_smallocation")
        result.addSubview(locationLogo)
        locationLogo.snp.makeConstraints { (maker) in
            maker.top.equalTo(result).offset(15)
            maker.leading.equalTo(result).offset(15)
            maker.height.width.equalTo(30)
        }
        
        //地址栏
        let locationInfoLabel = UILabel.init()
        self.locationInfoLabel = locationInfoLabel
        result.addSubview(locationInfoLabel)
        locationInfoLabel.snp.makeConstraints({ (maker) in
            maker.centerY.equalTo(locationLogo)
            maker.leading.equalTo(locationLogo.snp.trailing).offset(5)
            maker.trailing.equalTo(result).offset(-15)
        })
        locationInfoLabel.textColor = UIColor.lcc_colorWithHexString(hexadecimal: "#2c2c2c")
        locationInfoLabel.textAlignment = .left
        locationInfoLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        locationInfoLabel.text = "Loading Address..."
        result.isHidden = false
        
        //提示栏
        let gesTipLabel = UILabel.init()
        self.gesTipLabel = gesTipLabel
        result.addSubview(gesTipLabel)
        gesTipLabel.snp.makeConstraints({ (maker) in
            maker.top.equalTo(locationLogo.snp.bottom).offset(15)
            maker.leading.equalTo(result).offset(15)
            maker.trailing.equalTo(result).offset(-15)
        })
        gesTipLabel.textColor = UIColor.lcc_colorWithHexString(hexadecimal: "#8F8F8F")
        gesTipLabel.textAlignment = .left
        gesTipLabel.font = UIFont.systemFont(ofSize: 14.0)
        gesTipLabel.text = "Drag the map to adjust the location of the geographical fence,two-finger zoom map to adjust the size of the geographical fence"
        gesTipLabel.numberOfLines = 0
        gesTipLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
        result.isHidden = true
        
        return result
    }()
    
    lazy var disableInfoView: UIView = {
        let result = UIView.init()
        result.backgroundColor = UIColor.white
        let disableInfoLabel = UILabel.init()
        result.addSubview(disableInfoLabel)
        disableInfoLabel.snp.makeConstraints({ (maker) in
            maker.top.equalTo(result).offset(15)
            maker.leading.equalTo(result).offset(10)
            maker.trailing.equalTo(result).offset(-10)
        })
        disableInfoLabel.text = "开启Geofencing后,当您的手机进入设置的范围时，将自动切换至在家车房模式，当您的手机离开设置的范围时，将自动切换至离家布防模式。"
        disableInfoLabel.numberOfLines = 0
        disableInfoLabel.textAlignment = .left
        disableInfoLabel.font = UIFont.systemFont(ofSize: 15.0)
        result.isHidden = false
        return result
    }()
    
    lazy var enableButton: UIButton = {
        let result = UIButton.init(type: UIButton.ButtonType.custom)
        result.isAccessibilityElement = true;
        result.backgroundColor = UIColor.lcc_colorWithHexString(hexadecimal: "#25397e")
        result.layer.cornerRadius = 20
        result.layer.masksToBounds = true
        result.setTitle("Enable", for: UIControl.State.normal)
        result.addTarget(self, action: #selector(buttonClick(sender:)), for: .touchUpInside)
        result.isHidden = false
        return result
    }()
    
    lazy var disableButton: UIButton = {
        let result = UIButton.init(type: UIButton.ButtonType.custom)
        result.isAccessibilityElement = true
        result.backgroundColor = UIColor.lcc_colorWithHexString(hexadecimal: "#25397e")
        result.layer.cornerRadius = 20
        result.layer.masksToBounds = true
        result.setTitle("Disable", for: UIControl.State.normal)
        result.addTarget(self, action: #selector(buttonClick(sender:)), for: .touchUpInside)
        result.isHidden = true
        return result
    }()
    
    lazy var okButton: UIButton = {
        let result = UIButton.init(type: UIButton.ButtonType.custom)
        result.isAccessibilityElement = true;
        result.backgroundColor = UIColor.lcc_colorWithHexString(hexadecimal: "#25397e")
        result.layer.cornerRadius = 20
        result.layer.masksToBounds = true
        result.setTitle("Save", for: UIControl.State.normal)
        result.addTarget(self, action: #selector(buttonClick(sender:)), for: .touchUpInside)
        result.isHidden = true
        return result
    }()
    
    lazy var modifyButton: UIButton = {
        let result = UIButton.init(type: UIButton.ButtonType.custom)
        result.isAccessibilityElement = true;
        result.backgroundColor = UIColor.white
        result.setTitleColor(UIColor.lcc_colorWithHexString(hexadecimal: "#25397e"), for: UIControl.State.normal)
        result.layer.cornerRadius = 20
        result.layer.masksToBounds = true
        result.layer.borderWidth = 1
        result.layer.borderColor = UIColor.lcc_colorWithHexString(hexadecimal: "#25397e").cgColor
        result.layer.cornerRadius = 20
        result.layer.masksToBounds = true
        result.setTitle("Modify", for: UIControl.State.normal)
        result.addTarget(self, action: #selector(buttonClick(sender:)), for: .touchUpInside)
        result.isHidden = true
        return result
    }()
    
    lazy var notifySetButton: UIButton = {
        let result = UIButton.init(type: UIButtonType.custom)
        result.isAccessibilityElement = true;
        result.backgroundColor = UIColor.white
         result.setTitleColor(UIColor.lcc_colorWithHexString(hexadecimal: "#25397e"), for: UIControl.State.normal)
        result.layer.cornerRadius = 20
        result.layer.masksToBounds = true
        result.layer.borderWidth = 1
        result.layer.borderColor = UIColor.lcc_colorWithHexString(hexadecimal: "#25397e").cgColor
        result.layer.cornerRadius = 20
        result.layer.masksToBounds = true
        result.setTitle("Notification Settings", for: UIControlState.normal)
        result.addTarget(self, action: #selector(buttonClick(sender:)), for: .touchUpInside)
        result.isHidden = true
        return result
    }()


    //MARK: button action
    @objc func buttonClick(sender:UIButton) {
        if sender == enableButton {
            self.delegate?.transToStatus(status: .editing)
        }
        if sender == disableButton {
            self.delegate?.transToStatus(status: .disable)
        }
        if sender == okButton {
            self.delegate?.transToStatus(status: .enable)
        }
        if sender == modifyButton {
            self.delegate?.transToStatus(status: .editing)
        }
        if sender == notifySetButton{
            self.delegate?.pushToGeofenceActionSetting()
        }
    }
}
