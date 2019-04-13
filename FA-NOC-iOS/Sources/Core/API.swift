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
            .request(.post, FaUrl.login, parameters: model.requestModel.toJSON())
            .responseString(encoding: .utf8)
            .do(onNext: {_ in HTTPCookieStorage.save()})
    }
    
    static func browse(_ page:Int) -> Observable<(HTTPURLResponse, String)> {
        
        let requestModel = Settings.getBrowse()
        requestModel.page = page.description
        print(requestModel.toJSON())
        
        return SessionManager.default.rx
            .request(.post, FaUrl.browse, parameters: requestModel.toJSON())
            .timeout(10, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .responseString()
    }
    
    static func view(_ id:String) -> Observable<(HTTPURLResponse, String)> {
        return SessionManager.default.rx
            .request(.get, FaUrl.view(id))
            .timeout(10, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .responseString()
    }
}
