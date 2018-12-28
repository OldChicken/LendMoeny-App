//
//  GeofencingMapView.swift
//  SwiftDemo
//
//  Created by lechech on 2018/11/12.
//  Copyright © 2018 lichengchuan. All rights reserved.
//

import UIKit
import MapKit

class DHAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var title: String?
    var subtitle: String?
}

protocol GeofencingMapViewDelegate: class {
    //地图发生了改变
    func mapDidUpdate(map: GeofencingMapView)
    //用户位置发生了改变
    func userLocationDidUpdate(map: GeofencingMapView,userLocation: MKUserLocation)
    //用户修正了地理围栏
    func fixToUserLocation(map: GeofencingMapView,userLocation: MKUserLocation)
}

//围栏占地图的比例
fileprivate let geofencingRangeRadio: CGFloat = 0.5

class GeofencingMapView: UIView,MKMapViewDelegate {
    
    
    //MARK: override method
    override init(frame: CGRect) {
        super.init(frame: frame)
        map.delegate = self
        mapfix.isHidden = false
        mapMask.isHidden = false
        mapOverLay.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: property
    weak var delegate: GeofencingMapViewDelegate?
    var overLayFollowMe:Bool = true
    var maskTip:UILabel?
    
    lazy var map: MKMapView = {
        //地图
        let result = MKMapView.init()
        self.addSubview(result)
        result.snp.makeConstraints({ (maker) in
            maker.edges.equalTo(self)
        })
        result.mapType = .standard
        result.userTrackingMode = .none
        result.showsUserLocation = true
        return result
    }()
    
    lazy var mapOverLay: GeofencingMapOverLay = {
        //围栏
        let result = GeofencingMapOverLay.init()
        self.addSubview(result)
        result.snp.makeConstraints { (maker) in
            maker.center.equalTo(self)
            maker.height.width.equalTo(self).multipliedBy(0.5)
        }
        return result
    }()
    
    lazy var mapfix: UIButton = {
        //修正按钮
        let result = UIButton.init()
        result.setImage(UIImage.init(named: "genfence_btn_melocation"), for: .normal)
        result.addTarget(self, action: #selector(fixGeofence(sender:)), for: .touchUpInside)
        self.addSubview(result)
        result.snp.makeConstraints { (maker) in
            maker.right.equalTo(self).offset(-7.5)
            maker.top.equalTo(self).offset(7.5)
            maker.width.height.equalTo(60)
        }
        return result
    }()
    
    
    lazy var mapMask: UIView = {
        //遮罩
        let result = UIView.init()
        self.addSubview(result)
        result.backgroundColor = .white
        result.alpha = 0.85
        result.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self)
        }
        
        let maskLogo = UIImageView.init()
        maskLogo.backgroundColor = UIColor.orange
        result.addSubview(maskLogo)
        maskLogo.snp.makeConstraints({ (maker) in
            maker.centerX.equalTo(result)
            maker.centerY.equalTo(result).offset(-50)
            maker.width.height.equalTo(50)
        })
        
        let maskTipLabel = UILabel.init()
        maskTip = maskTipLabel
        result.addSubview(maskTipLabel)
        maskTipLabel.snp.makeConstraints({ (maker) in
            maker.top.equalTo(maskLogo.snp.bottom).offset(10)
            maker.leading.equalTo(result).offset(30)
            maker.trailing.equalTo(result).offset(-30)
        })
        maskTipLabel.text = ""
        maskTipLabel.textColor = UIColor.gray
        maskTipLabel.numberOfLines = 0
        maskTipLabel.textAlignment = .center
        maskTipLabel.font = UIFont.systemFont(ofSize: 15.0)
        return result
    }()
    
    
    
    
    var status: GeofencingStatus = .enable {
        didSet{
            switch status {
            case .disable:
                mapMask.isHidden = true
                maskTip?.text = ""
                map.isZoomEnabled = false
                map.isScrollEnabled = false
                map.isRotateEnabled = false
                map.showsUserLocation = true
                mapOverLay.isHidden = true
                mapfix.isHidden = true
            case .enable:
                mapMask.isHidden = true
                maskTip?.text = ""
                map.isZoomEnabled = false
                map.isScrollEnabled = false
                map.isRotateEnabled = false
                map.showsUserLocation = true
                mapOverLay.isHidden = false
                mapfix.isHidden = true
            case .editing:
                mapMask.isHidden = true
                maskTip?.text = ""
                map.isZoomEnabled = true
                map.isScrollEnabled = true
                map.isRotateEnabled = true
                map.showsUserLocation = true
                mapOverLay.isHidden = false
                mapfix.isHidden = false
            case .noPermissionEnable,.noPermissionDisable:
                //无权限，地图不可操作
                mapMask.isHidden = false
                maskTip?.text = status == .noPermissionEnable ? "Geofence relys on location services,please go to you phone Setting->Lorex,Then change the location setting to Always" : "To enable Geofencing with your phone,please go to you phone Setting->Lorex,Then change the location setting to Always"
                map.isZoomEnabled = false
                map.isScrollEnabled = false
                map.isRotateEnabled = false
                map.showsUserLocation = false
                mapOverLay.isHidden = true
                mapfix.isHidden = true
            }
        }
    }
    
    
    //MARK: public method
    public func setCenterAndZoomLevel(center:CLLocationCoordinate2D,level:Double) {
        //设置中心以及缩放级别
        map.setCenter(center, animated: false)
        map.zoomLevel = level
        overLayFollowMe = false
    }
    
    public func setCenter(center:CLLocationCoordinate2D) {
        //设置中心
        map.setCenter(center, animated: false)
    }
    
    
    public func addOverLayCirCle(center: CLLocationCoordinate2D,radius:CLLocationDistance) {
        let circle = MKCircle.init(center: center, radius: radius)
        map.add(circle, level: .aboveLabels)
    }
    
    public func addAnnotation(center: CLLocationCoordinate2D) {
        let annotation = DHAnnotation.init()
        annotation.coordinate = center
        annotation.title = "lcc点了这里"
        annotation.subtitle = "lcc click here"
        map.addAnnotation(annotation)
    }
    
    public func cacluteDistance(startPoint:CGPoint,endPoint:CGPoint) ->Double {
        
        //计算地图上两点的实际距离
        let starthMapCoordinate = map.convert(startPoint, toCoordinateFrom: map)
        let endMapCoordinate = map.convert(endPoint, toCoordinateFrom: map)
        let startLocation = CLLocation.init(latitude: starthMapCoordinate.latitude, longitude: starthMapCoordinate.longitude)
        let endLocation = CLLocation.init(latitude: endMapCoordinate.latitude, longitude: endMapCoordinate.longitude)
        let result = startLocation.distance(from: endLocation)
        return result
    }
    

    //MARK: mkmapview delegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = overlay as! MKCircle
        let circleRend = MKCircleRenderer.init(circle: circle)
        circleRend.alpha = 0.3;
        circleRend.fillColor = UIColor.blue
        circleRend.strokeColor = UIColor.red
        circleRend.lineWidth = 1.0
        return circleRend;
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        print("regionDidChangeAnimated")
        self.delegate?.mapDidUpdate(map: self)
        
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//        print("regionWillChangeAnimated")
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("mapViewDidFinishLoadingMap")
    }
    
    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
        print("mapViewDidFinishRenderingMap")
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        print("mapViewDidFinishRenderingMap")
    }
    
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.delegate?.userLocationDidUpdate(map: self, userLocation: userLocation)
    }
    
    
    //MARK: gesture action
    @objc func mapLongGesAction(gesture:UILongPressGestureRecognizer) {
        
        //移除旧的大头针和覆盖图
        map.removeOverlays(map.overlays)
        map.removeAnnotations(map.annotations)
        
        let touchPoint = gesture.location(in: map)
        let touchMapCoordinate = map.convert(touchPoint, toCoordinateFrom: map)
        print(touchMapCoordinate.latitude,touchMapCoordinate.longitude)
        
        //添加新的大头针和覆盖图
        self.addAnnotation(center: touchMapCoordinate)
        self.addOverLayCirCle(center: touchMapCoordinate, radius: 800)
        
    }
    
    //MARK: button action
    @objc func fixGeofence(sender:UIButton) {
       self.delegate?.fixToUserLocation(map: self, userLocation: self.map.userLocation)
    }
    

}
