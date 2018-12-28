//
//  LCLocationHelper.m
//  SwiftDemo
//
//  Created by lechech on 2018/11/13.
//  Copyright © 2018 lichengchuan. All rights reserved.
//

#import "LCLocationHelper.h"

@interface LCLocationHelper ()<CLLocationManagerDelegate>

@end

@implementation LCLocationHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static LCLocationHelper *sharedInstance;
    
    dispatch_once(&once, ^ {
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)requestAlwaysLocationPermissions:(BOOL)always completion:(void (^)(BOOL granted))completion {
    //先判断定位服务是否可用
    if (![CLLocationManager locationServicesEnabled]) {
        NSAssert([CLLocationManager locationServicesEnabled], @"Location service enabled failed");
        return;
    }
    BOOL locationEnable = [CLLocationManager locationServicesEnabled];
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!locationEnable || (status < 3 && status > 0)) {
            if (completion) {
                completion(NO);
            }
        } else if (status == kCLAuthorizationStatusNotDetermined){
            //获取授权认证
            if (always) {
                [_locationManager requestAlwaysAuthorization];
            } else {
                [_locationManager requestWhenInUseAuthorization]; //使用时开启定位
            }
        } else {
            if (always) {
                if (status == kCLAuthorizationStatusAuthorizedAlways) {
                    if (completion) {
                        completion(YES);
                    }
                } else {
                    if (completion) {
                        completion(NO);
                    }
                }
            } else {
                if (completion) {
                    completion(YES);
                }
            }
        }
    });
}

- (void)startLoadLocation {
    if (!self.locationManager) {
        return;
    }
    //设置代理
    _locationManager.delegate = self;
    //设置定位精度
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //定位频率,每隔多少米定位一次
    CLLocationDistance distance = 10.0;//十米定位一次
    _locationManager.distanceFilter = distance;
    //启动跟踪定位
    [_locationManager startUpdatingLocation];
}

- (void)stopLoadLocation {
    if (!self.locationManager) {
        return;
    }
    [_locationManager stopUpdatingLocation];
}






@end
