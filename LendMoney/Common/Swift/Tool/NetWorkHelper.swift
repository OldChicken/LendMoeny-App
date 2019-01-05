//
//  NetWorkHelper.swift
//  LendMoney
//
//  Created by lechech on 2018/12/18.
//  Copyright © 2018 CH. All rights reserved.
//

import AFNetworking
import MBProgressHUD

public enum NetWorkRequestUrl : String,CaseIterable {
    case none = ""
    case getcode = "http://127.0.0.1:1024/getcode"
    case register = "http://127.0.0.1:1024/register"
}

public enum NetWorkRequestType {
    case get
    case post
}

class NetWorkRequest : NSObject {
    var requestUrl: NetWorkRequestUrl = .none
    var requestParamters:Dictionary<String, String>?
    var requestType: NetWorkRequestType = .post
    convenience init(requestType:NetWorkRequestType,requestUrl:NetWorkRequestUrl,requestParamters:Dictionary<String, String>) {
        self.init()
        self.requestUrl = requestUrl
        self.requestType = requestType
        self.requestParamters = requestParamters
    }
}


class NetWorkHelper: AFHTTPSessionManager {
    
    static let shareInstance : NetWorkHelper = {
        let baseUrl = NSURL(string: "xxxxxx")!
        let manager = NetWorkHelper.init(baseURL: baseUrl as URL, sessionConfiguration: URLSessionConfiguration.default)
        //manager.requestSerializer.acceptableContentTypes = NSSet(objects: "application/json")
        return manager
    }()
    
    /**
     发起请求
     
     @ parameter request:  请求对象
     */
    class func request(request:NetWorkRequest,success:((_ responseObject:AnyObject?) -> Void)?,failure:((_ error:NSError) -> Void)?) -> Void {
        
        if request.requestType == .get {
            NetWorkHelper.get(urlString: request.requestUrl.rawValue, parameters: request.requestParamters as AnyObject, success: success, failure: failure)
        }
        
        if request.requestType == .post {
            NetWorkHelper.post(urlString: request.requestUrl.rawValue, parameters: request.requestParamters as AnyObject, success: success, failure: failure)
        }
    }

    
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

