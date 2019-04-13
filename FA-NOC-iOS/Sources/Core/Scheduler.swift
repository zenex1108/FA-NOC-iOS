//
//  Scheduler.swift
//  FA-NOC-iOS
//
//  Created by joowon on 06/01/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import Foundation
import Queuer

class Scheduler: NSObject {

    private let queue = Queuer(name: "com.zenex.FA-NOC-iOS."+String(describing: self) , maxConcurrentOperationCount: 1, qualityOfService: .background)
    private let semaphore = Semaphore(poolSize: 0)
    
    func add(_ block: @escaping (@escaping ()->Void)->Void) {
        queue.addOperation {
            block { self.semaphore.continue() }
            self.semaphore.wait()
        }
    }
    
    func clear() {
        queue.cancelAll()
    }
}
