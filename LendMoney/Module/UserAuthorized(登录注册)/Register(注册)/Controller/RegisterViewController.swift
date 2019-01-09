//
//  RegisterViewController.swift
//  LendMoney
//
//  Created by lechech on 2018/12/17.
//  Copyright © 2018 CH. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var registerCode: UITextField!
    var mobilePhone:String = ""
    var passWord:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(endEdit))
        view.addGestureRecognizer(gesture)
        registerCode.delegate = self
    }


    //MARK: uiaction
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        
        guard registerCode.text?.count != 0 else {
            NetWorkHelper.showMsg(msg: "验证码不能为空")
            return
        }
        
        endEdit()
        let request = NetWorkRequest.init()
        request.requestUrl = .register
        request.requestParamters = ["account":mobilePhone,
                                    "password":passWord,
                                    "code":registerCode.text!]
        NetWorkHelper.request(request: request, success: { (response) in
            if let dic = response as? NSDictionary {
                let msg = NetWorkHelper.getJSONStringFromDictionary(dictionary: dic)
                NetWorkHelper.showMsg(msg: msg)
                let registerVC = RegisterViewController.init()
                self.navigationController?.pushViewController(registerVC, animated: true)
            }
        }) { (error) in
            NetWorkHelper.showMsg(msg: error.description)
        }

    }
    
    
    //MARK: gesture action
    @objc func endEdit() {
        view.endEditing(true)
    }
}
