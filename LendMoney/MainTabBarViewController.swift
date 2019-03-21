//
//  MainTabBarViewController.swift
//  SwiftDemo
//
//  Created by lechech on 2018/5/16.
//  Copyright © 2018年 lechech. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
//    let nameArrary = ["借款","我"]
    
    //MARK: - 🍎override method
    override func viewDidLoad() {
        super.viewDidLoad()
        createControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //MARK: - 🍌private method
    private func createControllers() {
        
        //借款
        let applyVC = ApplyViewController.init()
        applyVC.title = "借款"
        
        //我
        let meVC = MeViewViewController.init()
        meVC.title = "我"
        let meNav = UINavigationController.init(rootViewController: meVC)
        meNav.navigationItem.title = "返回"
        meNav.navigationBar.tintColor = UIColor.black
        
  
        viewControllers = [meNav]
        
        
        
    }

    
   

}
