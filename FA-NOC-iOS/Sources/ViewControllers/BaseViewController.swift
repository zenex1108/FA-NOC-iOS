//
//  BaseViewController.swift
//  FA-NOC-iOS
//
//  Created by joowon on 13/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewContorller : UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        #if DEBUG
//        LogInfo("init UIViewController: \(description)")
//        LogInfo(self.description, "Rx Resources start total count: \(RxSwift.Resources.total)")
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        #if DEBUG
//        LogInfo(self.description, "Rx Resources afterStart total count: \(RxSwift.Resources.total)")
        #endif
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    deinit {
        #if DEBUG
//        let desc = description
        
//        LogInfo("deinit UIViewController: \(desc)")

//        LogInfo(desc, "Rx Resources end total count: \(RxSwift.Resources.total)")
//        DispatchUtil.Queue.async(scheduler: .global(.background), after: 0.1) {
//            LogInfo(desc, "Rx Resources end total count: \(RxSwift.Resources.total)")
//        }
        #endif
    }
}
