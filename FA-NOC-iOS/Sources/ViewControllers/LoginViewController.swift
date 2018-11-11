//
//  LoginViewController.swift
//  FA-NOC-iOS
//
//  Created by joowon on 06/11/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxKeyboard
import LGButton
import NSObject_Rx
import RxAnimated

class LoginViewController: UIViewController, ReCaptchaDelegate, UIBarTextFieldDelegate {
    
    @IBOutlet weak private var recaptchView: ReCaptcha!
    
    @IBOutlet weak private var reCaptchaGuideBasic: UIView!
    @IBOutlet weak private var reCaptchaGuideTest: UIView!
    
    @IBOutlet weak var usernameTextField: UIBarTextField!
    @IBOutlet weak var passwordTextField: UIBarTextField!
    
    @IBOutlet weak var loginButton: LGButton!
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recaptchView.delegate = self
//        recaptchView.setupWebView(url: "https://www.furaffinity.net/login")
        
        usernameTextField.barDelegate = self
        passwordTextField.barDelegate = self
        
        RxKeyboard.instance.visibleHeight.map{-$0}.asObservable()
            .bind(to: loginButtonBottomConstraint.rx.animated.layout(duration: 0.25).constant)
        .disposed(by: rx.disposeBag)
    }
    
    func reCaptchaDidLoad(_ view: UIView) {
        setBasicConstraint(view)
    }
    
    func reCaptchaWillTest(_ view: UIView) {
        setExpandConstraint(view)
    }
    
    func reCaptchaDidSolved(_ view: UIView, _ token: String) {
        
        setBasicConstraint(view)
        print("token:\(token)")
    }
    
    func reCaptchaError(_ view: UIView) {
        setBasicConstraint(view)
    }
    
    func setBasicConstraint(_ view:UIView){
        
        view.snp.removeConstraints()
        view.snp.makeConstraints { make in
            make.leading.equalTo(reCaptchaGuideBasic)
            make.trailing.equalTo(reCaptchaGuideBasic)
            make.top.equalTo(reCaptchaGuideBasic)
            make.bottom.equalTo(reCaptchaGuideBasic)
        }
    }
    
    func setExpandConstraint(_ view:UIView){
        
        view.snp.removeConstraints()
        view.snp.makeConstraints { make in
            make.leading.equalTo(reCaptchaGuideTest)
            make.trailing.equalTo(reCaptchaGuideTest)
            make.top.equalTo(reCaptchaGuideTest)
            make.bottom.equalTo(reCaptchaGuideTest)
        }
    }
    
    func textFieldShouldReturn(_ textField: UIBarTextField) -> Bool {
        
        if textField === usernameTextField {
            passwordTextField.becomeFirstResponder()
        }else if textField === passwordTextField {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
}
