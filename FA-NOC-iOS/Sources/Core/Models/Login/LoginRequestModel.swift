//
//  LoginRequestModel.swift
//  FA-NOC-iOS
//
//  Created by joowon on 05/01/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginRequestModel: Mappable {
    
    var name: String?
    var password: String?
    var token: String?
    
    var useOldCaptcha = 0
    var action = "login"
    var captcha = ""
    var login = "Login to FurAffinity"
    
    init(name:String?, password:String?, token:String?) {
        
        self.name = name
        self.password = password
        self.token = token
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        name            <- map["name"]
        password        <- map["pass"]
        token           <- map["g-recaptcha-response"]
        
        useOldCaptcha   <- map["use_old_captcha"]
        action          <- map["action"]
        captcha         <- map["captcha"]
        login           <- map["login"]
    }
}
