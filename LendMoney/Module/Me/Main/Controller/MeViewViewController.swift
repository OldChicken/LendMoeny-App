//
//  MeViewViewController.swift
//  SwiftDemo
//
//  Created by lechech on 2018/7/5.
//  Copyright © 2018年 lichengchuan. All rights reserved.
//

import UIKit


class MeViewViewController: BaseViewController {
    
    // MARK: -🍇property
    var dataSourseArray : Array<[MeViewCellItem]>?
    
    
    // MARK: -🍉Lazy method
    fileprivate lazy var meView : UITableView = {
        let result = UITableView.init(frame: CGRect.init(x: 0, y: 0 , width: Global_ScreenWidth, height: Global_ScreenHeightEdit), style: UITableView.Style.grouped)
        result.backgroundColor = UIColor.lcc_colorWithHexString(hexadecimal:"EFEFF4")
        result.delegate = self
        result.dataSource = self
        return result
    }()

    // MARK: -🍎override method
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(meView)
        loadDataSourse()
    }
    
    // MARK: -🍌private method
    private func loadDataSourse() {
        
        let allCases = MeItemId.allCases
        var originSourseArray = [MeViewCellItem]()
        allCases.forEach { (itemKey) in
            let keyItem = MeViewCellItem.init()
            keyItem.keyId = itemKey
            originSourseArray.append(keyItem)
        }
        dataSourseArray = MeViewCellItem.sort(sortArray: originSourseArray) as? Array<[MeViewCellItem]>
        print(dataSourseArray!)
    }

}

extension MeViewViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSourseArray!.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return (dataSourseArray![section] as AnyObject).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = dataSourseArray![indexPath.section][indexPath.row]
        if model.style == MeViewCellStyle.headStyle {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: MeViewCellStyle.headStyle.rawValue) as? MeTableViewCell
            if cell == nil {
                cell = MeTableViewCell.init(meCellStyle: .headStyle, reuseIdentifier: MeViewCellStyle.headStyle.rawValue)
            }
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            //model映射
            cell?.textLabel?.text = model.title
            cell?.imageView?.image = UIImage.init(named: model.iconImageNamed)
            return cell!
            
        }else {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: MeViewCellStyle.normalStyle.rawValue) as? MeTableViewCell
            if cell == nil {
                cell = MeTableViewCell.init(meCellStyle: .normalStyle, reuseIdentifier: MeViewCellStyle.normalStyle.rawValue)
            }
            cell?.selectionStyle = UITableViewCell.SelectionStyle.gray
            //model映射
            cell?.textLabel?.text = model.title
            cell?.imageView?.image = UIImage.init(named: model.iconImageNamed)
            return cell!

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let cellItem = dataSourseArray![indexPath.section][indexPath.row]
 
        switch cellItem.keyId {
        case .Register?:
            let register = RegisterViewController()
            self.present(register, animated: true, completion: nil)
        case .Geofencing?:
            let geofencingVC = GeofencingViewController.init()
            geofencingVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(geofencingVC, animated: true)
        case .Setting? :
            let setVC = SetViewController.init()
            setVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(setVC, animated: true)
        default:
            break
        }
     
    }
    
}

extension MeViewViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSourseArray![indexPath.section][indexPath.row]

        guard model.style == MeViewCellStyle.headStyle else {
            return 44
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let result = UIView.init()
        return result
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let result = UIView.init()
        return result
    }
    
}
