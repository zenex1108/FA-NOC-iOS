//
//  UIViewEx.swift
//  FA-NOC-iOS
//
//  Created by joowon on 31/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit

@IBDesignable extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    
    @IBInspectable var shadowOffset: CGPoint {
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor.init(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    @IBInspectable var outlineWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var outlineColor: UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor.init(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat, size: CGSize?=nil) {
        maskPath(roundCornersBezierPath(corners, radius: radius, size: size))
    }
    
    func maskPath(_ path:UIBezierPath) {
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func roundCornersBezierPath(_ corners: UIRectCorner, radius: CGFloat, size: CGSize?=nil) -> UIBezierPath {
        return UIBezierPath(roundedRect: CGRect(origin: .zero,
                                                size: (size ?? self.bounds.size)),
                            byRoundingCorners: corners,
                            cornerRadii: CGSize(width: radius, height: radius))
    }
}
