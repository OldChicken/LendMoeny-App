//
//  LCLocationHelper.m
//  SwiftDemo
//
//  Created by lechech on 2018/11/13.
//  Copyright © 2018 lichengchuan. All rights reserved.
//

#import "LCLocationHelper.h"
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
//虽然Apple没有对围栏设置最小值，但测试发现，围栏半径小于500米后，无法进入检测回调
#define GEOFENCE_MINIMUM_RADIUS 750
#define GEOFENCE_MAXIMUM_RADIUS 20000

#define GEOFENCE_LOCAL_ENTER_PUSH                       @"genfence_local_enter_push"
#define GEOFENCE_LOCAL_EXIT_PUSH                       @"genfence_local_exit_push"

@interface LCLocationHelper ()<UNUserNotificationCenterDelegate>

@property (nonatomic, strong)CLLocationManager *locationManager;

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

- (instancetype)init {
    
    if (self = [super init]) {
        

        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
    }
    return self;
}

#pragma mark - Geofence Authority
- (BOOL)isAlwaysAllowLocation {
    
    return CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ? YES : NO;
    
}

- (void)requestAlwaysLocationPermissions:(BOOL)always completion:(void (^)(BOOL granted))completion {
    //先判断总定位服务是否可用(设置-->隐私-->定位服务，而不是app自己的定位服务)
    if (![CLLocationManager locationServicesEnabled]) {
        if (completion) {
            completion(NO);
        }
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
                [self.locationManager requestAlwaysAuthorization];
            } else {
                [self.locationManager requestWhenInUseAuthorization]; //使用时开启定位
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


#pragma mark - Geofence Local Api
- (void)addGeofence:(double)longitude
           latitude:(double)latitude
             radius:(long)radius
         identifier:(NSString *)identifier
         completion:(void (^)(BOOL granted))completion {
    
    //每次开始监测新的围栏前，删除旧的围栏
    [self removeGeofence:identifier];
    
    //注册推送
    [self registerAPN];
    
    if([CLLocationManager locationServicesEnabled]) {
        
        if(radius > GEOFENCE_MAXIMUM_RADIUS) {
            radius = GEOFENCE_MAXIMUM_RADIUS;
            NSLog(@"radius is over limit!");
        }
        
        if(radius < GEOFENCE_MINIMUM_RADIUS) {
            radius = GEOFENCE_MINIMUM_RADIUS;
            NSLog(@"radius is over limit!");
        }
        
        if (![CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
            return;
        }
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude;
        coordinate.longitude = longitude;
        CLCircularRegion* region = [[CLCircularRegion alloc] initWithCenter:coordinate radius:radius identifier:identifier];
        region.notifyOnEntry = YES;
        region.notifyOnExit = YES;
        // 开始监听区域
        [_locationManager startMonitoringForRegion:region];
        // 请求区域状态(如果发生了进入或者离开区域的动作也会调用对应的代理方法)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.locationManager requestStateForRegion:region];
        });
        completion(YES);
        
    } else {
        NSLog(@"error:your phone not support!");
        completion(NO);
    }
    
}

- (void)removeGeofence:(NSString *)identifier {
    
    //移除围栏
    for (CLRegion *region in [[_locationManager monitoredRegions] allObjects]) {
        if (region.identifier == identifier) {
            [_locationManager stopMonitoringForRegion:region];
        }
    }
    
    //移除推送
    [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[GEOFENCE_LOCAL_ENTER_PUSH,GEOFENCE_LOCAL_EXIT_PUSH]];
    
}


#pragma mark - Geofence Push
// 注册通知
- (void)registerAPN {

    if (@available(iOS 10.0, *)) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            } else {
                // 点击不允许
                NSLog(@"注册失败");
            }
        }];
    } else if (@available(iOS 8.0, *)){
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

- (void)sendLocalNoticeEnterGeofence:(BOOL)enterFence {

    if (@available(iOS 10.0, *)) {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = @"地理围栏推送";
        content.body = enterFence == YES ? @"您已进入围栏" : @"您已离开围栏";
        content.sound = [UNNotificationSound defaultSound];
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1.0 repeats:NO];
        NSString *identifier = enterFence == YES ? GEOFENCE_LOCAL_ENTER_PUSH : GEOFENCE_LOCAL_EXIT_PUSH;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
            NSLog(@"添加推送成功,本地推送将在一秒后发送");
        }];
    }else if (@available(iOS 8.0, *)){
        UILocalNotification *notification = [UILocalNotification new];
        notification.alertTitle = @"地理围栏推送";
        notification.alertBody = enterFence == YES ? @"您已进入围栏" : @"您已离开围栏";;
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

#pragma mark - Geofence Alert
- (void)insideGeofenceAlert {
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        NSLog(@"进入监测区域!");
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Geofence Warning"
                                                                         message:@"Enter the Geofence"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        UIViewController *currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:confirmAction];
        
        [currentVC presentViewController:alertVC animated:YES completion:nil];
    }
}


- (void)outsideGeofenceAlert {
    
  if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
      NSLog(@"离开监测区域!");
      UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Geofence Warning"
                                                                       message:@"Outside the Geofence"
                                                                preferredStyle:UIAlertControllerStyleAlert];
      
      UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
      [alertVC addAction:confirmAction];
      
      UIViewController *currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
      [currentVC presentViewController:alertVC animated:YES completion:nil];
  }
    
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"开始监听");
}

// 进入指定区域
-(void)locationManager:(CLLocationManager *)manager
        didEnterRegion:(CLRegion *)region {
    
    NSLog(@"进入监测区域!");
    //执行设备行为
   
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [self insideGeofenceAlert];
    }else{
        [self sendLocalNoticeEnterGeofence:YES];
    }
    
}

// 离开指定区域
-(void)locationManager:(CLLocationManager *)manager
         didExitRegion:(CLRegion *)region {
    
    NSLog(@"离开监测区域!");
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [self outsideGeofenceAlert];
    }else{
        [self sendLocalNoticeEnterGeofence:NO];
    }
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"监听失败,error = %@",error.description);
}

//定位回调(每次添加围栏后，定位成功时会立即进入此方法，可以用于设置围栏成功后立即下发配置)
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    
    switch (state) {
        case CLRegionStateUnknown:
            break;
        case CLRegionStateInside:
        {
            //当前在围栏内部
            NSLog(@"当前在在监测区域内!");
            [self insideGeofenceAlert];
        }
            
            break;
        case CLRegionStateOutside:
        {
            //当前在围栏外部
            NSLog(@"当前在监测区域外!");
            [self outsideGeofenceAlert];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Geofence Web Server
- (void)getGeofenceInfoFormServer:(NSString *)presetId
                    needAotuStart:(BOOL)needAotuStart
                     needAlertTip:(BOOL)needAletTip
                       completion:(void (^)(BOOL isOpen))completion {
    
    
//    [LCUserInterface saas_getPresetDeviceActionConfig:presetId success:^(NSArray<LCGeofenceInfo *> * result) {
//
//        if (result.count > 0) {
//            //目前只有一个预置点
//            self.geofenceInfo = result.firstObject;
//            NSMutableArray *homeActions = [[NSMutableArray alloc]initWithCapacity:2];
//            NSMutableArray *awayActions = [[NSMutableArray alloc]initWithCapacity:2];
//            for (int i = 0; i < result.count; i++) {
//                //这个地方平台设计的有缺陷，需要优化，应该将home和away的行为表放在一起返回，不应该分开
//                LCGeofenceInfo *info = result[i];
//                for (int j = 0; j < info.devAction.count; j++) {
//                    if ([info.actionType  isEqual: GEOFENCE_ACTION_TYPE_HOME]) {
//                        [homeActions addObject:info.devAction[j]];
//                    }else if ([info.actionType  isEqual: GEOFENCE_ACTION_TYPE_AWAY]) {
//                        [awayActions addObject:info.devAction[j]];
//                    }
//                }
//                self.homeActions = homeActions;
//                self.awayActions = awayActions;
//            }
//        }else {
//            [self removeGeofence];
//            self.geofenceInfo = nil;
//            self.homeActions = nil;
//            self.awayActions = nil;
//        }
//
//        if ([self isAlwaysAllowLocation] && self.geofenceInfo.isOpen && needAotuStart) {
//            //如果已经开启定位，且已经设置过围栏，且需要自动开启监测
//            [self addGeofence:self.geofenceInfo.longitude.doubleValue
//                     latitude:self.geofenceInfo.latitude.doubleValue
//                       radius:self.geofenceInfo.range.doubleValue/2.0
//                   identifier:self.geofenceInfo.presetId completion:^(BOOL granted) {
//                       NSLog(@"开启地理围栏成功");
//                   }];
//        }
//
//        if (!self.geofenceInfo.isOpen) {
//            [self removeGeofence];
//        }
//
//        if (completion) {
//            completion(YES);
//        }
//    } failure:^(LCError *error) {
//        NSLog(@"%@", error);
//        if (completion) {
//            completion(NO);
//        }
//    }];
    
}


- (void)setGeoFencePreset:(NSString *)presetId
                longitude:(NSString *)longitude
                 latitude:(NSString*)latitude
                    range:(NSString*)range
                   isOpen:(BOOL)isOpen
               completion:(void (^)(BOOL))completion {
    
    
//    if(range.doubleValue  > GEOFENCE_MAXIMUM_RADIUS * 2) {
//        range = [NSString stringWithFormat:@"%d",GEOFENCE_MAXIMUM_RADIUS * 2];
//        NSLog(@"radius is over limit!");
//    }
//
//    if(range.doubleValue < GEOFENCE_MINIMUM_RADIUS * 2) {
//        range = [NSString stringWithFormat:@"%d",GEOFENCE_MINIMUM_RADIUS * 2];
//        NSLog(@"radius is over limit!");
//    }
//
//    [LCUserInterface saas_setGeoFencePreset:presetId longitude:longitude latitude:latitude range:range isOpen:isOpen success:^{
//
//        //开启弹框提示
//        self.needAlertTip = YES;
//
//        if (isOpen) {
//            //保存成功
//            [self addGeofence:longitude.doubleValue
//                     latitude:latitude.doubleValue
//                       radius:range.doubleValue/2.0
//                   identifier:presetId completion:^(BOOL granted) {
//                       NSLog(@"开启地理围栏成功,更新本地信息");
//                       LCGeofenceInfo *updateInfo =  [LCGeofenceInfo new];
//                       updateInfo.longitude = longitude;
//                       updateInfo.latitude = latitude;
//                       updateInfo.isOpen = isOpen;
//                       updateInfo.range = range;
//                       updateInfo.presetId = presetId;
//                       self.geofenceInfo = updateInfo;
//                   }];
//        }else {
//            [self removeGeofence];
//            self.geofenceInfo = nil;
//        }
//        if (completion) {
//            completion(YES);
//        }
//
//    } failure:^(LCError *error) {
//
//        NSLog(@"%@", error);
//        if (completion) {
//            completion(NO);
//        }
//
//    }];
    
}

- (void)setGeofenceActionToServer:(NSString *)presetId
                       actionType:(NSString *)actionType
                        devAction:(NSArray *)devAction
                       completion:(void (^)(BOOL))completion {
    
//    [LCUserInterface saas_setPresetDeviceActionConfig:presetId actionType:actionType devAction:devAction success:^{
//
//        if ([actionType  isEqual: GEOFENCE_ACTION_TYPE_AWAY]) {
//            self.awayActions = devAction;
//        }
//
//        if ([actionType  isEqual: GEOFENCE_ACTION_TYPE_HOME]) {
//            self.homeActions = devAction;
//        }
//        if (completion) {
//            completion(YES);
//        }
//
//
//    } failure:^(LCError *error) {
//
//        NSLog(@"%@", error);
//        if (completion) {
//            completion(NO);
//        }
//
//    }];
//
}

- (void)geofenceImplent:(NSString *)presetId isinside:(BOOL)inside completion:(void (^)(BOOL))completion {
    
//    NSString *type = inside == YES ? GEOFENCE_ACTION_TYPE_HOME : GEOFENCE_ACTION_TYPE_AWAY;
//    [LCUserInterface saas_implementPresetAction:presetId actionType:type success:^{
//        if (completion) {
//            completion(YES);
//        }
//    } failure:^(LCError *error) {
//        NSLog(@"%@", error);
//        if (completion) {
//            completion(NO);
//        }
//    }];
    
}

- (void)deleteDevice:(NSString *)deviceId {
    
    
//    NSArray *fitHomeArray = [self.homeActions monad_Filter:^BOOL(id _Nonnull obj) {
//
//        if ([obj isKindOfClass:LCGeofenceDeviceActionInfo.class]) {
//            LCGeofenceDeviceActionInfo *info = (LCGeofenceDeviceActionInfo*)obj;
//            if ([info.deviceId isEqualToString:deviceId] ) {
//                return false;
//            }
//        }
//        return true;
//    }];
//
//    NSArray *fitAwayArray = [self.awayActions monad_Filter:^BOOL(id _Nonnull obj) {
//
//        if ([obj isKindOfClass:LCGeofenceDeviceActionInfo.class]) {
//            LCGeofenceDeviceActionInfo *info = (LCGeofenceDeviceActionInfo*)obj;
//            if ([info.deviceId isEqualToString:deviceId] ) {
//                return false;
//            }
//        }
//        return true;
//    }];
//
//
//    [self setGeofenceActionToServer:self.geofenceInfo.presetId actionType:GEOFENCE_ACTION_TYPE_AWAY devAction:fitAwayArray completion:nil];
//
//    [self setGeofenceActionToServer:self.geofenceInfo.presetId actionType:GEOFENCE_ACTION_TYPE_HOME devAction:fitHomeArray completion:nil];
    
    
}



@end
