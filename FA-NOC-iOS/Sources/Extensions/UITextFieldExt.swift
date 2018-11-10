//
//  UITextFieldExt.swift
//  FA-NOC-iOS
//
//  Created by joowon on 07/11/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit

extension UITextField {
    
    @IBInspectable
    var placeholderColor: UIColor {
        set {
            if let text = placeholder {
                attributedPlaceholder = NSAttributedString(string:text, attributes:[.foregroundColor:newValue])
            }
        }
        get {
            return (attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor) ?? .darkGray
        }
    }
}
