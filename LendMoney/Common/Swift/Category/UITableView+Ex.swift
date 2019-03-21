//
//  UITableView+Extension.swift
//  LCIphone
//
//  Created by Jimmy Mu on 3/13/17.
//  Copyright © 2017 dahua. All rights reserved.
//

import UIKit

protocol IDHTableViewCell {
    static func dh_cellID() -> String
}

extension IDHTableViewCell {
    static func dh_cellID() -> String {
        return String(describing: Self.self)
    }
}


// MARK: - Section

extension UITableView {

    
    private func dh_registerCell<T:UITableViewCell>(cellClass:T.Type)where T: IDHTableViewCell
    {
        let nibName = String(describing: cellClass.self)
        print(nibName)
        let nib = UINib(nibName: nibName, bundle: nil)
        if nib.instantiate(withOwner: nil, options: nil).count != 0
        {
            self.register(nib, forCellReuseIdentifier: cellClass.dh_cellID())
        }
        else
        {
            self.register(cellClass, forCellReuseIdentifier: cellClass.dh_cellID())
        }
    }
    
    func dh_dequeueReusableCell<T:UITableViewCell>
        () -> T where T: IDHTableViewCell
    {
        var cell:UITableViewCell? = self.dequeueReusableCell(withIdentifier: T.dh_cellID())
        if cell == nil
        {
            self.dh_registerCell(cellClass: T.self)
            cell = self.dequeueReusableCell(withIdentifier: T.dh_cellID());
        }
        return cell! as! T
    }
    
}
