//
//  UIViewLoadProtocol.swift
//  moigo_cs
//
//  Created by Twinny on 2018. 7. 9..
//  Copyright © 2018년 Twinny. All rights reserved.
//

import UIKit

protocol UIViewLoadProtocol {

    associatedtype View

    static var Nib:UINib { get }
    static func loadView() -> View
}

extension UIViewLoadProtocol {

    static func loadView() -> Self {
        return Nib.instantiate(withOwner: Self.self, options: nil)[0] as! Self
    }
}

extension UIView : UIViewLoadProtocol {

    static var Nib: UINib {
        return UINib(nibName: fileName, bundle: Bundle(for: self))
    }
}
