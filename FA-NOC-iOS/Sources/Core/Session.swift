//
//  Session.swift
//  FA-NOC-iOS
//
//  Created by joowon on 04/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit

class Session: NSObject {
    
    static var isValid: Bool {
        
        if let cookies = HTTPCookieStorage.shared.cookies?.filter({$0.path=="/" && $0.domain==".furaffinity.net"}) {
            
            let __cfduid = cookies.contains(where: {$0.name == "__cfduid"})
            let __qca = cookies.contains(where: {$0.name == "__qca"})
            let b = cookies.contains(where: {$0.name == "b"})
            let a = cookies.contains(where: {$0.name == "a"})
            
            return (__cfduid && __qca && b && a)
        }
        return false
    }
}
