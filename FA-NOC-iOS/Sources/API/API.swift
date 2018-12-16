//
//  API.swift
//  FA-NOC-iOS
//
//  Created by joowon on 04/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit
import RxSwift
import RxAlamofire
import Alamofire

class API: NSObject {
    
    static func login(_ model:LoginModel) -> Observable<(HTTPURLResponse, String)> {
        return SessionManager.default.rx
            .request(.post, FaUrl.login,
                     parameters: ["name": model.name!,
                                  "pass": model.password!,
                                  "g-recaptcha-response": model.token!,
                                  "use_old_captcha": 0,
                                  "action": "login",
                                  "captcha": "",
                                  "login": "Login to FurAffinity"])
            .responseString(encoding: .utf8)
            .do(onNext: { _ in
                HTTPCookieStorage.save()
            })
    }
    
}
