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


#pragma mark - Geofence Authority
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



#pragma mark - Geofence Local Api
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


#pragma mark - Geofence Push
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



#pragma mark - Geofence Web Server
/**
 从平台拉取地理围栏信息
 
 @param presetId
 @param needAotuStart   获取成功后，是否需要自动开启监测
 @param completion isOpen为YES时表示围栏开启
 */
- (void)getGeofenceInfoFormServer:(NSString *)presetId
                    needAotuStart:(BOOL)needAotuStart
                     needAlertTip:(BOOL)needAletTip
                       completion:(void (^)(BOOL isOpen))completion;


/**
 保存地理围栏信息到平台
 
 @param presetId 围栏ID
 @param longitude 经度
 @param presetId 维度
 @param range 直径
 @param isOpen 使能
 @param completion success为YES时表示成功
 */
- (void)setGeoFencePreset:(NSString *)presetId
                longitude:(NSString *)longitude
                 latitude:(NSString*)latitude
                    range:(NSString*)range
                   isOpen:(BOOL)isOpen
               completion:(void (^)(BOOL))completion;


/**
 保存行为配置表到平台
 
 @param presetId 围栏ID
 @param completion success为YES时表示成功
 */
- (void)setGeofenceActionToServer:(NSString *)presetId
                       actionType:(NSString *)actionType
                        devAction:(NSArray *)devAction
                       completion:(void (^)(BOOL))completion;


/**
 地理围栏触发上报
 
 @param presetId 围栏ID
 @isinside       围栏内外，YES/NO:围栏内/围栏外
 @param completion success为YES时表示成功
 */
- (void)geofenceImplent:(NSString *)presetId isinside:(BOOL)inside completion:(void (^)(BOOL))completion;


/**
 清除某个设备配置
 
 @param presetId 围栏ID
 @param deviceId 设备ID
 @param completion success为YES时表示成功
 */
- (void)deleteDevice:(NSString *)deviceId;
@end
