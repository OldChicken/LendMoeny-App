//
//  SetViewController.swift
//  SwiftDemo
//
//  Created by lichengchuan on 2018/5/16.
//  Copyright © 2018年 lichengchuan. All rights reserved.
//

import UIKit

class SetViewCellItem: NSObject {
    
    
    // MARK: -🍇property
    public var title : String = "title"
    public var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 12)
    public var titleTextAlignment : NSTextAlignment = NSTextAlignment.left
    public var cellStyle: UITableViewCell.CellStyle = UITableViewCell.CellStyle.default
    public var cellAccessoryType : UITableViewCell.AccessoryType = UITableViewCell.AccessoryType.disclosureIndicator
}

class SetViewController: BaseViewController {
     // MARK: -🍇property
    var dataSourseArray : Array<[SetViewCellItem]>?
    
    // MARK: -🍉Lazy method
    fileprivate lazy var setView : UITableView = {
        let result = UITableView.init(frame: CGRect.init(x: 0, y: 0 , width: Global_ScreenWidth, height: Global_ScreenHeightEdit), style: UITableView.Style.grouped)
        result.backgroundColor = UIColor.lcc_colorWithHexString(hexadecimal:"EFEFF4")
        result.delegate = self
        result.dataSource = self
        result.register(UITableViewCell.self, forCellReuseIdentifier: "setCell")
        return result
    }()

    
    // MARK: -🍎override method
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        view.addSubview(setView)
        loadDataSourse()
    }

    // MARK: -🍌private method
    private func loadDataSourse() {

        //帐号与安全
        let safeModel = SetViewCellItem.init()
        safeModel.title = "帐号与安全"
        
        //新消息通知
        let newMessageModel = SetViewCellItem.init()
        newMessageModel.title = "新消息通知"
        
        //隐私
        let concealModel = SetViewCellItem.init()
        concealModel.title = "隐私"
        
        //通用
        let commonModel = SetViewCellItem.init()
        commonModel.title = "通用"
        
        //帮助与反馈
        let helpModel = SetViewCellItem.init()
        helpModel.title = "帮助与反馈"
        
        //关于
        let aboutModel = SetViewCellItem.init()
        aboutModel.title = "关于"
        
        //推出登陆
        let logoutModel = SetViewCellItem.init()
        logoutModel.title = "退出登陆"
        logoutModel.titleTextAlignment = NSTextAlignment.center
        logoutModel.cellAccessoryType = UITableViewCell.AccessoryType.none
        
        let section1 : Array = [safeModel]
        let section2 : Array = [newMessageModel,concealModel,commonModel]
        let section3 : Array = [helpModel,aboutModel]
        let section4 : Array = [logoutModel]
        
        dataSourseArray = [section1,section2,section3,section4]
    }
    


}


extension SetViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSourseArray!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSourseArray![section] as AnyObject).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "setCell")
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        
        //Item映射
        let model = dataSourseArray![indexPath.section][indexPath.row]
        cell?.textLabel?.text = model.title
        cell?.textLabel?.textAlignment = model.titleTextAlignment
        cell?.accessoryType = model.cellAccessoryType
       
        return cell!
    }
    
}

extension SetViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let result = UIView.init()
        result.backgroundColor = UIColor.clear
        return result
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let result = UIView.init()
        result.backgroundColor = UIColor.clear
        return result
    }
}
