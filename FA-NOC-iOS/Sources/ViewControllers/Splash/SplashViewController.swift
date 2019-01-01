//
//  SplashViewController.swift
//  FA-NOC-iOS
//
//  Created by joowon on 06/11/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx
import PKHUD
import Kingfisher

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        HTTPCookieStorage.restore()
        
        ImageCache.default.memoryStorage.config.totalCostLimit = 200 * 1024 * 1024
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Session.isValid {
            print("valid session")
            performSegue(withIdentifier: "toMainSegue", sender: nil)
        }else{
            performSegue(withIdentifier: "toLoginViewController", sender: nil)
        }
    }
    
}
