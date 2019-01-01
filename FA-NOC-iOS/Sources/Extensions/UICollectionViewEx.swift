//
//  UICollectionViewEx.swift
//  FA-NOC-iOS
//
//  Created by joowon on 07/11/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func cell<T:UICollectionViewCell>(_ identifier:String, for indexPath:IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
}

