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
        return API.login(model)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map{Parser.login($0.0, $0.1, model)}
            .observeOn(MainScheduler.instance)
    }
    
    static func browse(_ page:Int) -> Observable<[GalleryItemModel]> {
        return API.browse(page)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map{Parser.browse($0.0, $0.1)}
            .observeOn(MainScheduler.instance)
    }
}
