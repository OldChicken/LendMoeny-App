//
//  MKMapView+ZoomLevel.swift
//  SwiftDemo
//
//  Created by lechech on 2018/11/16.
//  Copyright © 2018 lichengchuan. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    //缩放级别
    var zoomLevel: Double {
        //获取缩放级别
        get {
            return Double(log2(360 * Double(self.frame.size.width/256)
                / self.region.span.longitudeDelta) )
        }
        //设置缩放级别
        set (newZoomLevel){
            setCenterCoordinate(coordinate: self.centerCoordinate, zoomLevel: newZoomLevel,
                                animated: false)
        }
    }
    
    
    //设置缩放级别时调用
    private func setCenterCoordinate(coordinate: CLLocationCoordinate2D, zoomLevel: Double,
                                     animated: Bool){
        
        let span = MKCoordinateSpan(latitudeDelta: 0,
                                    longitudeDelta: 360 / pow(2, Double(zoomLevel)) * Double(self.frame.size.width) / 256)
        setRegion(MKCoordinateRegion(center: centerCoordinate, span: span), animated: animated)
    }
    
    
    //根据围栏半径、围栏中心设置缩放比例
    public func catelateZoomLevel(geofenceCenter:CLLocationCoordinate2D,geofenceRadius:Double) -> Double {
        
        let distance = 4 * geofenceRadius
        let region = MKCoordinateRegionMakeWithDistance(geofenceCenter, distance ,distance)
        let zoomLevel = Double(log2(360 * Double(self.frame.size.width/256)
            / region.span.longitudeDelta) )
        print(zoomLevel)
        return zoomLevel
    }
    
}
