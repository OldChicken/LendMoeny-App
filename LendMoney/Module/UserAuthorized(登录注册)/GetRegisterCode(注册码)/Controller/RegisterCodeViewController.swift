//
//  RegisterViewController.swift
//  LendMoney
//
//  Created by lechech on 2018/12/17.
//  Copyright © 2018 CH. All rights reserved.
//

import UIKit

class RegisterCodeViewController: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var passwordFiled: UITextField!
    @IBOutlet weak var mobileFiled: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(endEdit))
        view.addGestureRecognizer(gesture)
        passwordFiled.delegate = self
        mobileFiled.delegate = self
    }


    //MARK: uiaction
    @IBAction func cancalButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func getCodeButtonAction(_ sender: UIButton) {
        
     
        guard mobileFiled.text?.count != 0 else {
            NetWorkHelper.showMsg(msg: "手机号或密码不能为空")
            return
        }

        guard passwordFiled.text?.count != 0 else {
            NetWorkHelper.showMsg(msg: "手机号或密码不能为空")
            return
        }

        endEdit()
        let request = NetWorkRequest.init()
        request.requestUrl = .getcode
        request.requestParamters = ["user_phone":mobileFiled.text!,
                                    "type":"register"]
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
