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
    
    static var baseURL = URL(string: "https://www.furaffinity.net")!
    static var sessionManager:SessionManager = {
        
        HTTPCookieStorage.restore()
        SessionManager.default.delegate.taskWillPerformHTTPRedirection = {
            session, task, response, request -> URLRequest? in
            print(response.allHeaderFields)
            return request
        }
        
        return SessionManager.default
    }()
    
    static func login(name:String, password:String, token:String) -> Observable<(HTTPURLResponse, String)> {
        let url = baseURL.appendingPathComponent("/login/")
        return sessionManager.rx.request(.post, url,
                                         parameters: ["name": name,
                                                      "pass": password,
                                                      "g-recaptcha-response": token,
                                                      "use_old_captcha": 0,
                                                      "action": "login",
                                                      "captcha": "",
                                                      "login": "Login to FurAffinity"]).responseString(encoding: .utf8)
            .map{ result -> String in
                
                HTTPCookieStorage.save()
                print(HTTPCookieStorage.shared.cookies)
                
                do {
                    let doc: Document = try SwiftSoup.parse(result.1)
                    let body = try doc.body()
                    
                    return doc
                } catch Exception.Error(let type, let message) {
                    print(message)
                } catch {
                    print("error")
                }
                
                return ""
            }
    }
}
