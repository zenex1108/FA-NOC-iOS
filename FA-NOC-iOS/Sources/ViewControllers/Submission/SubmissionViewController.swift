//
//  SubmissionViewController.swift
//  FA-NOC-iOS
//
//  Created by joowon on 13/04/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx

class SubmissionViewController: BaseViewContorller {

    var galleryModel: GalleryItemModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
}

extension SubmissionViewController {
    
    func bind(){
        
        Service.view(galleryModel)
            .subscribe(onNext: weakify{ strongSelf, model in
                
                print(model)
                
            }).disposed(by: rx.disposeBag)
    }
}
