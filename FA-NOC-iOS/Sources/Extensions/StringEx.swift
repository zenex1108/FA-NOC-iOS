//
//  StringEx.swift
//  FA-NOC-iOS
//
//  Created by joowon on 31/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import Foundation

extension Array where Element == String {
    
    func cleanDescription() -> String {
        return reduce("", {$0+"\n"+$1})
    }
    
    func reduce(_ nextPartialResult:(_ result:String,_ string:String)->String) -> String {
        guard self.count > 0 else { return "" }
        guard self.count > 1 else { return self[0] }
        
        let selfWithoutFirst = Array(self[1...(count-1)])
        return selfWithoutFirst.reduce(self[0], nextPartialResult)
    }
}
