//
//  LCLocationHelper.h
//  SwiftDemo
//
//  Created by lechech on 2018/11/13.
//  Copyright © 2018 lichengchuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface LCLocationHelper : NSObject<CLLocationManagerDelegate>


/**
 单例
 */
+ (instancetype)sharedInstance;


/**
 是否始终允许定位
 */
- (BOOL)isAlwaysAllowLocation;


/**
 判断、申请位置权限
 
 @param always 为true时，申请始终获取位置权限;为false时，app运行时获取位置，系统会弹框确认
 @param completion grand为YES时表示有权限，NO表示无权限
 */
- (void)requestAlwaysLocationPermissions:(BOOL)always completion:(void (^)(BOOL granted))completion;


/**
 添加地理围栏
 
 @longitude     围栏中心点经度
 @latitude      围栏中心点维度
 @radius        围栏半径
 @identifier    ID
 @completion    结果回调
 */
- (void)addGeofence:(double)longitude
           latitude:(double)latitude
             radius:(long)radius
         identifier:(NSString *)identifier
         completion:(void (^)(BOOL granted))completion;


/**
 删除地理围栏
 
 @identifier    ID
 */
- (void)removeGeofence:(NSString *)identifier;



/**
 发送地理围栏推送
 
 @enterFence    是否进入围栏
 */
- (void)sendLocalNoticeEnterGeofence:(BOOL)enterFence;


/**
 注册本地推送
 
 @enterFence    是否进入围栏
 */
- (void)registerAPN;
@end
