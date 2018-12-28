//
//  ItemSortProtocol.swift
//  LendMoney
//
//  Created by lechech on 2018/12/17.
//  Copyright © 2018 CH. All rights reserved.
//

protocol ItemSortProtocol {
    
    //排序索引
    var sortIndex : IndexPath {get}
    
    //无序数组排序,返回二维数组
    static func sort(sortArray:[ItemSortProtocol]) -> [Any]?
    
    
}
