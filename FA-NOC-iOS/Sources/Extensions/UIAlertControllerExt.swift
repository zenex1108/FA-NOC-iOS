//
//  UIAlertControllerExt.swift
//  FA-NOC-iOS
//
//  Created by joowon on 15/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit

extension UIAlertController {
    static public func showAlert(_ message: String, _ controller: UIViewController, _ completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: completion))
        controller.present(alert, animated: true, completion: nil)
    }
}
