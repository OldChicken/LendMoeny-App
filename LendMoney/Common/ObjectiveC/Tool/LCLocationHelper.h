//
//  LCLocationHelper.h
//  SwiftDemo
//
//  Created by lechech on 2018/11/13.
//  Copyright © 2018 lichengchuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LCLocationHelper : NSObject

@property (nonatomic, strong)CLLocationManager *locationManager;

//单例
+ (instancetype)sharedInstance;

/**
 判断、申请位置权限，结果通过completion回调出来
 @param always 为true时，申请始终获取位置权限;为false时，app运行时获取位置，系统会弹框确认
 @param completion grand为YES时表示有权限，NO表示无权限
 */
- (void)requestAlwaysLocationPermissions:(BOOL)always completion:(void (^)(BOOL granted))completion;

/**
 开启定位
 */
- (void)startLoadLocation;

/**
 停止定位
 */
- (void)stopLoadLocation;
@end
