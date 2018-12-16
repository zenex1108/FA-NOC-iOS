//
//  Service.swift
//  FA-NOC-iOS
//
//  Created by joowon on 14/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit
import RxSwift

class Service: NSObject {
    
    static func login(_ model:LoginModel) -> Observable<LoginModel> {
        return API.login(model).map{Parser.login($0.0, $0.1, model)}
    }
}
