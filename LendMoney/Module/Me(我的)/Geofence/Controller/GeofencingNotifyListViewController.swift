//
//  GeofencingNotifyListViewController.swift
//  LeChangeOverseas
//
//  Created by lechech on 2019/3/8.
//  Copyright © 2019 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

import UIKit


class GeofencingNotifyListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    // MARK: property
    private var dateSource = [Any]()
    private var table: UITableView = UITableView(frame: .zero, style: .grouped)
    private var type = ""
    public var presetId = ""
    public var isInside = false {
        didSet{
            title =  isInside ? "Inside" : "Outside"
            type =  isInside ? "home" : "away"
        }
    }
    
    
    // MARk : override method
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(table)
//        defaultDateSource()
        setNav()
        setTable()
//        getGeofenceActionFromServer()

    }
    
    deinit {
        print("GeofenceNotifyListVC has release!")
    }
    
    // MARk : server method
    func setNav() {
        
        let rightBtn = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: #selector(setGeofenceActionToServer))
        self.navigationItem.rightBarButtonItem = rightBtn
        
    }
    
    func setTable() {
        
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Global_ScreenWidth, height: 60))
        header.backgroundColor = UIColor.clear
        let headerLabel = UILabel(frame: CGRect.init(x: 15, y: 0, width: Global_ScreenWidth - 30, height: 60))
        headerLabel.numberOfLines = 0
        headerLabel.text = isInside ? "Please select the device which one will accept notification When you inside of the Geofence" : "Please select the device which one will accept notification When you outside of the Geofence"
        headerLabel.font = UIFont.systemFont(ofSize: 16)
        headerLabel.textColor = UIColor.black
        header.addSubview(headerLabel)
        table.tableHeaderView = header
        table.delegate = self
        table.dataSource = self
        table.snp.makeConstraints({ (maker) in
            maker.edges.equalTo(view)
        })
    }
    
//    func defaultDateSource() {
//        if let channelList =  MMDeviceManager.sharedInstance()?.getAllChannels() as? [MMChannel] {
//            for channel in channelList {
//                let actionInfo = LCGeofenceDeviceActionInfo()
//                actionInfo.channelId = "\(channel.mNum)"
//                actionInfo.channelName = channel.mDevice?.mMultichannelDevice == true ? channel.mName : ""
//
//                actionInfo.deviceId = channel.mDevice.mSN
//                actionInfo.deviceName = channel.mDevice.mDeviceName
//                actionInfo.enable = isInside ? false : true
//                dateSource.append(actionInfo)
//            }
//        }
//    }
    
//    func getGeofenceActionFromServer() {
//
//        // 从平台拉取数据和本地的设备列表对比。平台没有的设备，根据围栏内外默认展示状态
//        if let serverAction = isInside ? LCLocationHelper.sharedInstance()?.homeActions : LCLocationHelper.sharedInstance()?.awayActions {
//
//            dateSource.forEach { (localActionInfo) in
//                serverAction.forEach({ (serverActionInfo) in
//                    if localActionInfo.deviceId == serverActionInfo.deviceId,
//                        localActionInfo.channelId == serverActionInfo.channelId{
//                        localActionInfo.enable = serverActionInfo.enable
//                    }
//                })
//            }
//        }
//
//    }
    
    @objc func setGeofenceActionToServer() {

    }
    
    // MARK: - table view datasouce & delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell:UITableViewCell = UITableViewCell.init()
        let cellInfo = dateSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    

}
