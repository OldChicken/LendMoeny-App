//
//  MeViewCellItem.swift
//  LendMoney
//
//  Created by lechech on 2018/12/17.
//  Copyright © 2018 CH. All rights reserved.
//

public enum MeViewCellStyle : String {
    case headStyle = "headStyleCell"
    case normalStyle = "normalStyleCell"
}

public enum MeItemId : String,CaseIterable {
    case Header = "头像"
    case Geofencing = "地理围栏"
    case Register = "注册"
    case Setting = "设置"
}

class MeViewCellItem: NSObject,ItemSortProtocol {
    
    // MARK: property
    public var keyId : MeItemId! {
        //cell唯一标示
        didSet{
            switch keyId {
            case .Header? :
                iconImageNamed = "me_default_head"
                sortIndex = IndexPath.init(row: 0, section: 0)
                title = keyId.rawValue
                style = .headStyle
                break
            case .Geofencing?:
                iconImageNamed = "me_icon_download"
                sortIndex = IndexPath.init(row: 0, section: 1)
                title = keyId.rawValue
                style = .normalStyle
                break
            case .Setting?:
                iconImageNamed = "me_icon_setting"
                sortIndex = IndexPath.init(row: 1, section: 1)
                title = keyId.rawValue
                style = .normalStyle
                break
            case .Register?:
                iconImageNamed = "me_icon_file"
                sortIndex = IndexPath.init(row: 0, section: 2)
                title = keyId.rawValue
                style = .normalStyle
                break
            default:
                iconImageNamed = ""
                sortIndex = IndexPath.init(row: 0, section: 0)
                title = keyId.rawValue
                style = .normalStyle
                break
            }
        }
    }
    public var subTitle : String = "subTitle"                //cell副标题,读写
    private(set) var style = MeViewCellStyle.normalStyle     //cell类型,只读，由keyId唯一确定
    private(set) var title  = ""                             //cell标题,只读，由keyId唯一确定
    private(set) var iconImageNamed  = ""                    //cellicon,只读，由keyId唯一确定
    private(set) var sortIndex = IndexPath(row: 0, section: 0)   //cell排序索引,只读，由keyId唯一确定
    
    //MARK: class function
    class func sort(sortArray: [ItemSortProtocol]) -> [Any]? {
        
        var sectionCount = 1
        sortArray.forEach { (item) in
            if sectionCount < item.sortIndex.section + 1 {
                sectionCount = item.sortIndex.section + 1
            }
        }
        
        if sectionCount == 1 {
            //一维数组
            var result = sortArray
            result.sort { (item1, item2) -> Bool in
                return item1.sortIndex.row < item2.sortIndex.row
            }
            return result
        }else if sectionCount > 1 {
            //二维数组
            var result = [[ItemSortProtocol]]()
            for _ in 0...sectionCount - 1 {
                let section = [ItemSortProtocol]()
                result.append(section)
            }
            sortArray.forEach { (item) in
                result[item.sortIndex.section].append(item)
            }
            for section in 0...result.count - 1 {
                result[section].sort { (item1, item2) -> Bool in
                    return item1.sortIndex.row < item2.sortIndex.row
                }
            }
            return result
        }else {
            return nil
        }

    }
    
}
