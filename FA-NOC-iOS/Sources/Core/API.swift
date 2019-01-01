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
            .request(.post, FaUrl.login, parameters: model.callParameters)
            .responseString(encoding: .utf8)
            .do(onNext: {_ in HTTPCookieStorage.save()})
    }
    
    static func browse(_ page:Int) -> Observable<(HTTPURLResponse, String)> {
        var parameters = Settings.getBrowse()
        parameters["page"] = page.description
        parameters["go"] = "Apply"
        
        //temp
        parameters["rating_mature"] = "on"
        parameters["rating_adult"] = "on"
        
        return SessionManager.default.rx
            .request(.post, FaUrl.browse, parameters: parameters)
            .responseString()
    }
    
}
