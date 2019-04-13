//
//  LoginModel.swift
//  FA-NOC-iOS
//
//  Created by joowon on 15/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import Foundation

class LoginModel {
    
    var requestModel: LoginRequestModel!
    
    var isSuccess: Bool = false
    var message: String?
    
    init(name:String?, password:String?, token:String?) {
        
        requestModel = LoginRequestModel(name: name, password: password, token: token)
    }
    
    func setResult(isSuccess:Bool, message:String? = nil) {
        
        self.isSuccess = isSuccess
        self.message = message
    }
}
