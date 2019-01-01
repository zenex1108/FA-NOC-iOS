//
//  LoginViewController.swift
//  FA-NOC-iOS
//
//  Created by joowon on 06/11/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import RxAnimated
import NSObject_Rx
import Alamofire
import SnapKit
import LGButton
import PKHUD
import WeakableSelf

class LoginViewController: UIViewController, ReCaptchaDelegate, UIBarTextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak private var recaptchView: ReCaptcha!
    
    @IBOutlet weak private var reCaptchaGuideBasic: UIView!
    @IBOutlet weak private var reCaptchaGuideTest: UIView!
    @IBOutlet weak var reCaptchaCancelButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UIBarTextField!
    @IBOutlet weak var passwordTextField: UIBarTextField!
    
    @IBOutlet weak var loginButton: LGButton!
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var token = BehaviorRelay<String?>(value: nil)
    
    private var reCaptchatExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recaptchView.delegate = self
        recaptchView.initWebView()
        
        usernameTextField.barDelegate = self
        passwordTextField.barDelegate = self
        
        reCaptchaCancelButton.rx.tap
            .subscribe(onNext: weakify { strongSelf, _ in
                strongSelf.recaptchView.initWebView()
            }).disposed(by: rx.disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: weakify { strongSelf, height in
                
                strongSelf.loginButtonBottomConstraint.constant = height
                UIView.animate(withDuration: 0, animations: strongSelf.view.layoutIfNeeded)
            }).disposed(by: rx.disposeBag)
        
        Observable.combineLatest(usernameTextField.rx.text.orEmpty, passwordTextField.rx.text.orEmpty, token) { name, password, token -> Bool in
            return (name.count==0 || password.count==0 || (token ?? "").count==0)
            }.bind(to: loginButton.rx.animated.fade(duration: 0.25).isHidden)
            .disposed(by: rx.disposeBag)
        
        loginButton.rx.controlEvent(.touchUpInside)
            .flatMap{ [weak self] () -> Observable<LoginModel> in
                guard let strongSelf = self else { return Observable.empty() }
                strongSelf.view.endEditing(true)
                HUD.show(.progress)
                let model = LoginModel(name: strongSelf.usernameTextField.text,
                                       password: strongSelf.passwordTextField.text,
                                       token: strongSelf.token.value)
                return Service.login(model)
            }
            .subscribe(onNext: weakify { strongSelf, result in
                HUD.hide(afterDelay: 0.25)
                
                if result.isSuccess {
                    print("Login: login success!")
                    strongSelf.performSegue(withIdentifier: "toMainSegue", sender: nil)
                }else{
                    UIAlertController.showAlert("Error: \(result.message ?? "Unknown")", strongSelf) { action in
                        
                        //init recaptcha
                        if strongSelf.reCaptchatExpanded || strongSelf.token.value == nil {
                            strongSelf.recaptchView.initWebView()
                        }
                    }
                }
            }).disposed(by: rx.disposeBag)
    }
    
    func reCaptchaDidLoad(_ view: UIView) {
        
        token.accept(nil)
        reCaptchatExpanded = false
        setBasicConstraint(view)
    }
    
    func reCaptchaWillTest(_ view: UIView) {
        
        reCaptchatExpanded = true
        self.view.endEditing(true)
        setExpandConstraint(view)
    }
    
    func reCaptchaDidSolved(_ view: UIView, _ token: String) {
        
        setBasicConstraint(view)
        self.token.accept(token)
        print("token:\(token)")
    }
    
    func reCaptchaExpired(_ view: UIView) {
        
        token.accept(nil)
    }
    
    func reCaptchaError(_ view: UIView) {
        
        setBasicConstraint(view)
    }
    
    func setBasicConstraint(_ view:UIView){
        
        reCaptchaCancelButton.isHidden = true
        
        view.snp.removeConstraints()
        view.snp.makeConstraints { make in
            make.leading.equalTo(reCaptchaGuideBasic)
            make.trailing.equalTo(reCaptchaGuideBasic)
            make.top.equalTo(reCaptchaGuideBasic)
            make.bottom.equalTo(reCaptchaGuideBasic)
        }
    }
    
    func setExpandConstraint(_ view:UIView){
        
        reCaptchaCancelButton.isHidden = false
        
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
