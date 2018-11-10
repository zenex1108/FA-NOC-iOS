//
//  LoginViewController.swift
//  FA-NOC-iOS
//
//  Created by joowon on 06/11/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController, ReCaptchaDelegate {
    
    @IBOutlet weak private var recaptchView: ReCaptcha!
    
    @IBOutlet weak private var reCaptchaGuideBasic: UIView!
    @IBOutlet weak private var reCaptchaGuideTest: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recaptchView.delegate = self
        recaptchView.setupWebView(url: "https://www.furaffinity.net/login")
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
}
