//
//  RegisterViewController.swift
//  LendMoney
//
//  Created by lechech on 2018/12/17.
//  Copyright © 2018 CH. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController,UITextFieldDelegate {
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordFiled: UITextField!
    @IBOutlet weak var mobileFiled: UITextField!
    @IBOutlet weak var urlFiled: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(endEdit))
        view.addGestureRecognizer(gesture)
        passwordFiled.delegate = self
        mobileFiled.delegate = self
    }


    //MARK: uiaction
    @IBAction func cancalButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        
        endEdit()
        let url = urlFiled.text
        let requestUrl = url! + "?" + "account=\(mobileFiled.text!)" + "&" + "password=\(passwordFiled.text!)"
        NetWorkHelper.get(urlString: requestUrl, parameters: nil, success: { (response) in
            if let dic = response as? NSDictionary {
                let msg = NetWorkHelper.getJSONStringFromDictionary(dictionary: dic)
                NetWorkHelper.showMsg(msg: msg)
            }
        }) { (error) in
            NetWorkHelper.showMsg(msg: error.description)
        }
    }
    
    @IBAction func postButtonAction(_ sender: UIButton) {
     
        endEdit()
        let requestUrl = urlFiled.text
        let requestBody = ["account":mobileFiled.text,
                           "password":passwordFiled.text]
        NetWorkHelper.post(urlString: requestUrl!, parameters: requestBody as AnyObject, success: { (response) in
            if let dic = response as? NSDictionary {
                let msg = NetWorkHelper.getJSONStringFromDictionary(dictionary: dic)
                NetWorkHelper.showMsg(msg: msg)
            }
        }) { (error) in
            NetWorkHelper.showMsg(msg: error.description)
        }
        
    }
    
    //MARK: text filed delegate
    
    
    
    
    //MARK: gesture action
    @objc func endEdit() {
        view.endEditing(true)
    }
}
