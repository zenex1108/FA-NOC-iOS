//
//  UITableViewEx.swift
//  FA-NOC-iOS
//
//  Created by joowon on 07/11/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit

extension UITableView {
    
    func reloadDataWithTransition(_ completion:((_ success:Bool)->Void)?=nil) {
        UITableView.reloadDataWithTransition(tableview: self, completion)
    }
    
    static func reloadDataWithTransition(tableview:UITableView, _ completion:((_ success:Bool)->Void)?=nil) {
        
        UIView.transition(
            with: tableview,
            duration: 0.25,
            options: .transitionCrossDissolve,
            animations: {
                tableview.reloadData()
        }, completion: { success in
            completion?(success)
        })
    }
    
    func headerFooter<T:UITableViewHeaderFooterView>(_ identifier:String) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: identifier) as! T
    }

    func cell<T:UITableViewCell>(_ identifier:String, for indexPath:IndexPath?=nil) -> T {
        if let indexPath = indexPath {
            return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
        }
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
