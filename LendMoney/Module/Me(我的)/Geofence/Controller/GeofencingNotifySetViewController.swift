//
//  GeofenceNotifySettingViewController.swift
//  LeChangeOverseas
//
//  Created by lechech on 2019/3/8.
//  Copyright © 2019 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

import UIKit

class GeofencingNotifySetViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
 
    public var presetId = ""
    
    private var table: UITableView = {
        let result = UITableView(frame: .zero, style: .grouped)
        return result
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notification Settings"
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        table.snp.makeConstraints({ (maker) in
            maker.edges.equalTo(view)
        })
    }
    
    
    // MARK: - table view datasouse & delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "hehe")
        cell.textLabel?.text = indexPath.row == 0 ? "Notification Inside Geofence" : "Notification Outside Geofence"
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let geofenceNotifyListVC = GeofencingNotifyListViewController()
        geofenceNotifyListVC.isInside = indexPath.row == 0 ? true : false
        geofenceNotifyListVC.presetId = presetId
        self.navigationController?.pushViewController(geofenceNotifyListVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
 

}
