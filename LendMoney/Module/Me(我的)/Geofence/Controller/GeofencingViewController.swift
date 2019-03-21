//
//  GeofencingViewController.swift
//  SwiftDemo
//
//  Created by lechech on 2018/11/12.
//  Copyright © 2018 lichengchuan. All rights reserved.
//

import UIKit
import MapKit

class GeofencingInfo: NSObject {
    var isOpen: Bool = false
    var cornerRadius: Double = 0
    var latitude: Double = 0
    var longitude: Double = 0
    var zoomLevel: Double = 0
}

class GeofencingViewController: BaseViewController,GeofencingMapViewDelegate,GeofencingInfoViewDelegate {

    //MARK: property
    var locationHelper = LCLocationHelper.sharedInstance()
    
    lazy var geofencingMap: GeofencingMapView = {
        let result = GeofencingMapView.init(frame: CGRect.init(x: 0, y: 0, width: Global_ScreenWidth, height: Global_ScreenWidth))
        self.view.addSubview(result)
        return result
    }()
    
    lazy var geofencingInfo: GeofencingInfoView = {
        let result = GeofencingInfoView.init()
        result.layer.shadowColor = UIColor.lightGray.cgColor
        result.layer.shadowOpacity = 0.5//不透明度
        result.layer.shadowRadius = 5.0//设置阴影所照射的范围
        result.layer.shadowOffset = CGSize.init(width: 0, height: 0)// 设置阴影的偏移量
        result.layer.cornerRadius = 5
        self.view.addSubview(result)
        result.snp.makeConstraints { (maker) in
            maker.top.equalTo(geofencingMap.snp.bottom)
            maker.trailing.leading.equalTo(self.view)
            maker.bottom.equalTo(self.view)
        }
        return result
    }()
    
    
    //MARK: override method
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Geofence"
        print(geofencingMap)
        //地图模块代理，用于监听地图交互事件
        geofencingMap.delegate = self
        //信息模块代理，用于监听用户交互事件
        geofencingInfo.delegate = self
        //获取权限
        checkAndGetPermission()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //app激活通知，当同意权限弹框时，app也会触发此通知
        NotificationCenter.default.addObserver(self, selector: #selector(checkAndGetPermission), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: private method
    @objc func checkAndGetPermission() {
        //获取定位权限
        locationHelper?.requestAlwaysLocationPermissions(true) { (isGrand) in
            if isGrand {
                //有权限
                if let saveInfo = self.getGeofencingDate() {
                    if saveInfo.isOpen {
                        //使能开启
                        self.geofencingMap.status = .enable
                        self.geofencingInfo.status = .enable
                        self.geofencingMap.setCenterAndZoomLevel(center: CLLocationCoordinate2D.init(latitude: saveInfo.latitude, longitude: saveInfo.longitude), level: saveInfo.zoomLevel)
                    }else {
                        //使能关闭
                        self.geofencingMap.status = .disable
                        self.geofencingInfo.status = .disable
                        self.geofencingMap.setCenterAndZoomLevel(center: CLLocationCoordinate2D.init(latitude: saveInfo.latitude, longitude: saveInfo.longitude), level: saveInfo.zoomLevel)
                    }
                }else {
                    //第一次设置
                    self.geofencingMap.status = .disable
                    self.geofencingInfo.status = .disable
                }
            }else {
                //无权限
                if let saveInfo = self.getGeofencingDate() {
                    if saveInfo.isOpen{
                        //使能打开
                        self.geofencingMap.status = .noPermissionEnable
                        self.geofencingInfo.status = .noPermissionEnable
                    }else {
                        //使能关闭
                        self.geofencingMap.status = .noPermissionDisable
                        self.geofencingInfo.status = .noPermissionDisable
                    }
                }
            }
        }
    }
    
    func getGeofencingDate() -> GeofencingInfo? {
        //获取数据,模拟接口
        if var geoData = UserDefaults.standard.value(forKey: "geofencing") as? [String:Any] {
            let info = GeofencingInfo.init()
            info.isOpen = (geoData["isOpen"] as? Bool)!
            info.zoomLevel = (geoData["zoomLevel"] as? Double)!
            info.cornerRadius = (geoData["cornerRadius"] as? Double)!
            info.latitude = (geoData["latitude"] as? Double)!
            info.longitude = (geoData["longitude"] as? Double)!
            return info
        }
        return nil
    }
    
    func saveGeofencingDate() {
        //更新数据,模拟接口
        var saveDic = [String : Any]()
        saveDic["isOpen"] = geofencingInfo.isOpen
        saveDic["zoomLevel"] = geofencingMap.map.zoomLevel
        saveDic["latitude"] = geofencingMap.map.centerCoordinate.latitude
        saveDic["longitude"] = geofencingMap.map.centerCoordinate.longitude
        saveDic["cornerRadius"] = geofencingMap.mapOverLay.cornerRadis
        UserDefaults.standard.set(saveDic, forKey: "geofencing")
        print(saveDic)
        

        //开启/关闭地理围栏监测
        let longitude = geofencingMap.map.centerCoordinate.longitude
        let latitude = geofencingMap.map.centerCoordinate.latitude
        let radius = geofencingMap.mapOverLay.cornerRadis
        let identifier = "geofencing"
        
        if geofencingInfo.isOpen {
            //添加围栏
            locationHelper?.addGeofence(longitude, latitude: latitude, radius: radius, identifier: identifier, completion: { (success) in
                if !success {
                    print("error:radius is over limit!")
                }
            })
        }else {
            //删除围栏
            locationHelper?.removeGeofence(identifier)
        }
    }
    
    func updateGeofenceStatus() {
        //更新开关,模拟接口
        if var saveDic = UserDefaults.standard.value(forKey: "geofencing") as? [String:Any] {
            saveDic["isOpen"] = geofencingInfo.isOpen
            UserDefaults.standard.set(saveDic, forKey: "geofencing")
        }
    }
    
    //MARK: geofencingmapview delegate
    func mapDidUpdate(map: GeofencingMapView) {
        //更新map的半径
        let startPoint = map.mapOverLay.center
        let endPoint = CGPoint.init(x: map.mapOverLay.center.x + map.mapOverLay.frame.width / 2, y: map.mapOverLay.center.y)
        let distance = map.cacluteDistance(startPoint: startPoint, endPoint: endPoint)
        map.mapOverLay.cornerRadis = Int(distance)
        
        
        //用反地理编码器更新位置
        let location = CLLocation(latitude: map.map.centerCoordinate.latitude, longitude: map.map.centerCoordinate.longitude)
        let geoCoder = CLGeocoder.init()
        geoCoder.reverseGeocodeLocation(location) { (pls: [CLPlacemark]?, error: Error?)  in
            if error == nil {
                guard let plsResult = pls else {return}
                let firstPL = plsResult.first
                self.geofencingInfo.locationInfoLabel?.text = firstPL?.name
            }else {
                print(error?.localizedDescription as Any)
                self.geofencingInfo.locationInfoLabel?.text = "Load Fail"
            }
        }
    }
    
    func userLocationDidUpdate(map: GeofencingMapView, userLocation: MKUserLocation) {
        
        guard map.overLayFollowMe else {
            return
        }
        map.setCenterAndZoomLevel(center: userLocation.coordinate, level: 15)
    }
    
    func fixToUserLocation(map: GeofencingMapView, userLocation: MKUserLocation) {
        map.setCenter(center: userLocation.coordinate)
    }
    

    //MARK: geofencinginfoview delegate
    func transToStatus(status: GeofencingStatus) {
        
        locationHelper?.requestAlwaysLocationPermissions(true) { (isGrand) in
            if isGrand {
                //更新地图视图的状态
                self.geofencingMap.status = status
                //更新信息视图的状态
                self.geofencingInfo.status = status
                
                //手动开启/关闭Geofencing
                if status == .enable  {
                    self.saveGeofencingDate()
                    if let saveInfo = self.getGeofencingDate() {
                        self.geofencingMap.setCenterAndZoomLevel(center: CLLocationCoordinate2D.init(latitude: saveInfo.latitude, longitude: saveInfo.longitude), level: saveInfo.zoomLevel)
                    }
                }else if status == .disable  {
                    self.saveGeofencingDate()
                }
                
            }else {
                
                if status == .disable {
                    //无权限时，可以关闭使能
                    self.geofencingMap.status = .noPermissionDisable
                    self.geofencingInfo.status = .noPermissionDisable
                    self.updateGeofenceStatus()
                }
                
                if status == .editing || status == .enable {
                    //无权限时,不允许编辑,不允许开启
                    let alertVC = UIAlertController.init(title: "Update location setting", message: "To enable Geofencing with your phone,please go to you phone Setting->Lorex,Then change the location setting to Always", preferredStyle: .alert)
                    let okAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                    let setAction = UIAlertAction.init(title: "Setting", style: UIAlertAction.Style.default, handler: { (action) in
                        let url = URL.init(string: UIApplicationOpenSettingsURLString)
                        if UIApplication.shared.canOpenURL(url!) {
                            UIApplication.shared.openURL(url!)
                        }
                    })
                    alertVC.addAction(okAction)
                    alertVC.addAction(setAction)
                    self .present(alertVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func pushToGeofenceActionSetting() {
        
        let genfenceNotifyVC = GeofencingNotifySetViewController()
        genfenceNotifyVC.presetId = "testId"
        self.navigationController?.pushViewController(genfenceNotifyVC, animated: true)
        
        
    }
    
}
