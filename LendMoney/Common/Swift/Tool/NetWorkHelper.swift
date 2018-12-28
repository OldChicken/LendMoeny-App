//
//  NetWorkHelper.swift
//  LendMoney
//
//  Created by lechech on 2018/12/18.
//  Copyright © 2018 CH. All rights reserved.
//

import AFNetworking
import MBProgressHUD
class NetWorkHelper: AFHTTPSessionManager {
    
    static let shareInstance : NetWorkHelper = {
        let baseUrl = NSURL(string: "xxxxxx")!
        let manager = NetWorkHelper.init(baseURL: baseUrl as URL, sessionConfiguration: URLSessionConfiguration.default)
        //manager.requestSerializer.acceptableContentTypes = NSSet(objects: "application/json")
        return manager
    }()
    
    /**
     get请求
     
     @ parameter urlString:  请求的url
     @ parameter parameters: 请求的参数
     @ parameter success:    请求成功回调
     @ parameter failure:    请求失败回调
     */
    class func get(urlString:String,parameters:AnyObject?,success:((_ responseObject:AnyObject?) -> Void)?,failure:((_ error:NSError) -> Void)?) -> Void {
        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: true)
        NetWorkHelper.shareInstance.get(urlString, parameters: parameters, progress: { (progress) in }, success: { (task, responseObject) in
            hud?.hide(true)
            //如果responseObject不为空时
            if responseObject != nil {
                success!(responseObject as AnyObject?)
            }
        }, failure: { (task, error) in
            hud?.hide(true)
            failure!(error as NSError)
        })
    }
    
    
    /**
     post请求
     
     @ parameter urlString:  请求的url
     @ parameter parameters: 请求的参数
     @ parameter success:    请求成功回调
     @ parameter failure:    请求失败回调
     */
    class func post(urlString:String,parameters:AnyObject?,success:((_ responseObject:AnyObject?) -> Void)?,failure:((_ error:NSError) -> Void)?) -> Void {
        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: true)
        NetWorkHelper.shareInstance.post(urlString, parameters: parameters, progress: { (progress) in
        }, success: { (task, responseObject) in
            hud?.hide(true)
            //如果responseObject不为空时
            if responseObject != nil {
                success!(responseObject as AnyObject?)
            }
        }) { (task, error) in
            hud?.hide(true)
            failure!(error as NSError)
        }
        
    }
    
    /**
     显示信息
     
     @ parameter msg:  内容
     */
    class func showMsg(msg:String) {
        
        guard msg.count != 0 else {
            return
        }
        
        let msgHud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: true)
        msgHud?.mode = .text
        msgHud?.labelColor = .white
        msgHud?.detailsLabelText = msg
        msgHud?.margin = 10
        msgHud?.yOffset = 0
        msgHud?.minShowTime = 1
        msgHud?.removeFromSuperViewOnHide = true
        msgHud?.hide(true, afterDelay: 3)
    }
    
    /**
     字典转字符串
     
     @ parameter dictionary:  字典
     @ return : json字符串
     */
    class func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
    
}

