//
//  Parser.swift
//  FA-NOC-iOS
//
//  Created by joowon on 04/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import Foundation
import SwiftSoup

class Parser: NSObject {
    
    static func login(_ response:HTTPURLResponse, _ html:String, _ model:LoginModel) -> LoginModel {
        
        if let strUrl = response.url?.absoluteString,
            !strUrl.contains(FaStrRefUrl.login.rawValue) {
            
            model.setResult(isSuccess: true)
        }else{
            
            do {
                let document: Document = try SwiftSoup.parse(html)
                let elements: Elements = try document.select(".error-msg-box")
                
                if let element = elements.first() {
                    model.setResult(isSuccess: false, message: try element.text())
                }
            } catch {
                model.setResult(isSuccess: false, message: "error")
            }
        }
        
        return model
    }
}
