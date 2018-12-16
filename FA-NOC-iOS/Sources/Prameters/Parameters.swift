//
//  Parameters.swift
//  FA-NOC-iOS
//
//  Created by joowon on 13/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import Foundation

enum FaStrRefUrl: String {
    
    case login = "/login/"
    
    case logout = "/logout/"
    
    case browse = "/browse/"
    case search = "/search/"
    
    case notes = "/msg/pms/"
    case submissions = "/msg/submissions/"
    case others = "/msg/others"
}

struct FaUrl {
    
    static private func makeURL(_ ref:FaStrRefUrl) -> URL {
        return makeURL(strRef: ref.rawValue)
    }
    
    static private func makeURL(strRef:String) -> URL {
        return URL(string: "https://www.furaffinity.net\(strRef)")!
    }
    
    static let login = makeURL(.login)
    static let logout = makeURL(.logout)
    
    static let browse = makeURL(.browse)
    static let search = makeURL(.search)
    
    static let notes = makeURL(.notes)
    static let submissions = makeURL(.submissions)
    static let others = makeURL(.others) //journals+watches
    
    static func user(_ name:String) -> URL {
        return makeURL(strRef: "/user/\(name)")
    }
}
