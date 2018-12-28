//
//  Global.swift
//  SwiftDemo
//
//  Created by lichengchuan on 2018/5/26.
//  Copyright © 2018年 lichengchuan. All rights reserved.
//

import UIKit


//屏宽
let Global_ScreenHeight = UIScreen.main.bounds.size.height
//屏高
let Global_ScreenWidth = UIScreen.main.bounds.size.width
//状态栏高
let Global_StatusHeight = UIApplication.shared.statusBarFrame.size.height
//导航栏高
let Global_NavigitionBarHeight : CGFloat = 44
//标签栏高
let Global_TabbarHeight : CGFloat = isX_Model ? 49 + 34 : 49
//除去导航栏、状态栏、标签栏的屏幕高度
let Global_ScreenHeightEdit = Global_ScreenHeight - Global_StatusHeight - Global_NavigitionBarHeight
//除去导航栏、状态栏的屏幕高度
let Global_ScreenHeightEditWithOutTab = Global_ScreenHeight - Global_StatusHeight - Global_NavigitionBarHeight - Global_TabbarHeight


//是否X类机型
var isX_Model: Bool {
    get {
        return (Global_ScreenWidth == 375.0 && Global_ScreenHeight == 812.0) ||
            (Global_ScreenWidth == 414.0 && Global_ScreenHeight == 896)
    }
}
