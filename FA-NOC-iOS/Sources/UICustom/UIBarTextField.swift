//
//  UIBarTextField.swift
//  FA-NOC-iOS
//
//  Created by joowon on 06/11/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit

public enum UIBarTextFieldType : String {
    case top, bottom, left, right
}

// UITextFieldDelegate와 동일
@objc public protocol UIBarTextFieldDelegate {
    
    /// return NO to disallow editing.
    @objc optional func textFieldShouldBeginEditing(_ textField: UIBarTextField) -> Bool
    
    /// became first responder
    @objc optional func textFieldDidBeginEditing(_ textField: UIBarTextField)
    
    /// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    @objc optional func textFieldShouldEndEditing(_ textField: UIBarTextField) -> Bool
    
    /// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    @objc optional func textFieldDidEndEditing(_ textField: UIBarTextField)
    
    /// if implemented, called in place of textFieldDidEndEditing:
    @available(iOS 10.0, *)
    @objc optional func textFieldDidEndEditing(_ textField: UIBarTextField, reason: UITextField.DidEndEditingReason)
    
    /// return NO to not change text
    @objc optional func textField(_ textField: UIBarTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    
    /// called when clear button pressed. return NO to ignore (no notifications)
    @objc optional func textFieldShouldClear(_ textField: UIBarTextField) -> Bool
    
    /// called when 'return' key pressed. return NO to ignore.
    @objc optional func textFieldShouldReturn(_ textField: UIBarTextField) -> Bool
}

@IBDesignable
open class UIBarTextField : UITextField, UITextFieldDelegate {
    
    @IBInspectable
    open var barType: String = UIBarTextFieldType.bottom.rawValue {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    open var barDefaultColor: UIColor = .lightGray {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable
    open var barFocusingColor: UIColor = .black {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable
    open var barThickness: CGFloat = 1.0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable
    open var barOffset: CGRect = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable
    open var textInset: CGPoint = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    @available(iOS 8.0, *)
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setup()
        barSetup()
        setNeedsDisplay()
    }
    
    ///////////////////////////////////////////////////////////////////////////
    
    weak var barDelegate : UIBarTextFieldDelegate?
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        barSetup()
    }
    
    convenience public init() {
        self.init(frame: CGRect())
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        layerInit()
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layerInit()
        setup()
    }
    
    private let barLayer = CALayer()
    
    private func layerInit() {
        
        layer.addSublayer(barLayer)
    }
    
    private func setup() {
        borderStyle = .none
        clipsToBounds = false
        delegate = self
    }
    
    private var currentBarColor : CGColor! {
        didSet {
            barLayer.backgroundColor = currentBarColor
        }
    }
    
    private func barSetup() {
        
        currentBarColor = barDefaultColor.cgColor
        barLayer.frame = barFrame + barOffset
    }
    
    private var barFrame: CGRect {
        
        let width = bounds.width
        let height = bounds.height
        let lineWidth = max(0,barThickness)
        
        if let type = UIBarTextFieldType(rawValue: barType) {
            
            switch type {
            case .top: return CGRect(x: 0, y: 0, width: width, height: lineWidth)
            case .bottom: return CGRect(x: 0, y: height-lineWidth, width: width, height: lineWidth)
            case .left: return CGRect(x: 0, y: 0, width: lineWidth, height: height)
            case .right: return CGRect(x: width-lineWidth, y: 0, width: lineWidth, height: height)
            }
        }
        return .zero
    }
    
    ///////////////////////////////////////////////////////////////////////////
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        barAnimation(color: barFocusingColor.cgColor)
        return barDelegate?.textFieldShouldBeginEditing?(self) ?? true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        barDelegate?.textFieldDidBeginEditing?(self)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        barAnimation(color: barDefaultColor.cgColor)
        return barDelegate?.textFieldShouldEndEditing?(self) ?? true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        barDelegate?.textFieldDidEndEditing?(self)
    }
    
    @available(iOS 10.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        barDelegate?.textFieldDidEndEditing?(self, reason: reason)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return barDelegate?.textField?(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return barDelegate?.textFieldShouldClear?(self) ?? true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return barDelegate?.textFieldShouldReturn?(self) ?? true
    }
    
    ///////////////////////////////////////////////////////////////////////////
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: textInset.x, dy: textInset.y)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: textInset.x, dy: textInset.y)
    }
    
    ///////////////////////////////////////////////////////////////////////////
    
    private func barAnimation(color:CGColor) {
        
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        
        animation.fromValue = currentBarColor
        animation.toValue = color
        animation.duration = 0.15
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        
        barLayer.add(animation, forKey: "backgroundColor")
        currentBarColor = color
    }
}

extension CGRect {
    
    static func + (lhs: CGRect, rhs: CGRect) -> CGRect {
        return CGRect(x: lhs.origin.x + rhs.origin.x,
                      y: lhs.origin.y + rhs.origin.y,
                      width: lhs.size.width + rhs.size.width,
                      height: lhs.size.height + rhs.size.height)
    }
}
