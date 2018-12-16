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

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Session.isValid {
            print("valid session")
        }else{
            performSegue(withIdentifier: "toLoginViewController", sender: nil)
        }
    }

}
