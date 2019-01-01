//
//  LoginModel.swift
//  FA-NOC-iOS
//
//  Created by joowon on 15/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit

class LoginModel: NSObject {

    private(set) var name: String!
    private(set) var password: String!
    private(set) var token: String!
    
    var isSuccess: Bool = false
    var message: String?
    
    var callParameters: [String:Any] {
        return ["name": name!,
                "pass": password!,
                "g-recaptcha-response": token!,
                "use_old_captcha": 0,
                "action": "login",
                "captcha": "",
                "login": "Login to FurAffinity"]
    }
    
    override init() {
        super.init()
    }
    
    convenience init(name:String?, password:String?, token:String?) {
        self.init()
        
        self.name = name ?? ""
        self.password = password ?? ""
        self.token = token ?? ""
    }
    
    func setResult(isSuccess:Bool, message:String? = nil) {
        
        self.isSuccess = isSuccess
        self.message = message
    }
}