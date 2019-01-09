//
//  ApplyViewController.swift
//  LendMoney
//
//  Created by lechech on 2019/1/8.
//  Copyright © 2019 CH. All rights reserved.
//

import UIKit

class ApplyViewController: BaseViewController {
    
    
    private var table: UITableView = {
        let result = UITableView(frame: .zero, style: .grouped)
        result.register(AdCarouselTableViewCell.self, forCellReuseIdentifier: AdCarouselTableViewCell.cellIdentifier)
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        table.snp.makeConstraints({ (maker) in
            maker.edges.equalTo(view)
        })
    }

}

extension ApplyViewController: UITableViewDelegate {
    
 
    
}



extension ApplyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: AdCarouselTableViewCell.cellIdentifier) as? AdCarouselTableViewCell
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 150
        case 1:
            return 200
        case 2:
            return 200
        case 3:
            return 80
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
}
