//
//  HTTPCookiePropertyKeyExt.swift
//  FA-NOC-iOS
//
//  Created by joowon on 12/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import Foundation

extension HTTPCookieStorage {
    static func clear(){
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
            save()
        }
    }
    static func save(){
        var cookies = [Any]()
        if let newCookies = HTTPCookieStorage.shared.cookies {
            for newCookie in newCookies {
                var cookie = [HTTPCookiePropertyKey : Any]()
                cookie[.name] = newCookie.name
                cookie[.value] = newCookie.value
                cookie[.domain] = newCookie.domain
                cookie[.path] = newCookie.path
                cookie[.version] = newCookie.version
                if let date = newCookie.expiresDate {
                    cookie[.expires] = date
                }
                cookies.append(cookie)
            }
            UserDefaults.standard.setValue(cookies, forKey: "cookies")
            UserDefaults.standard.synchronize()
        }
        
    }
    static func restore(){
        if let cookies = UserDefaults.standard.value(forKey: "cookies") as? [[HTTPCookiePropertyKey : Any]] {
            
            var allowCookie = false
            
            for cookie in cookies {
                
                if let oldCookie = HTTPCookie(properties: cookie) {
//                    print("cookie loaded:\(oldCookie)")
                    HTTPCookieStorage.shared.setCookie(oldCookie)
                }
                
                if let name = cookie[.name] as? String, name == "cc",
                    let domain = cookie[.domain] as? String, domain.contains("www.furaffinity.net") {
                    allowCookie = true
                }
            }
            
            if !allowCookie {
    
                HTTPCookieStorage.shared
                    .setCookie(HTTPCookie(properties: [.name:"cc",
                                                       .value:"1",
                                                       .domain:"www.furaffinity.net",
                                                       .path:"/",
                                                       .expires:Date(timeIntervalSinceNow: 60*60*24*365)])!)
                save()
            }
        }
    }
}
