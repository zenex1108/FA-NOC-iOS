//
//  ImageLoadScheduler.swift
//  FA-NOC-iOS
//
//  Created by joowon on 06/01/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit

class ImageLoadScheduler: Scheduler {
    static let shared = ImageLoadScheduler()

    func load(_ block: @escaping (@escaping ()->Void)->Void, isInit:Bool) {
        if isInit {clear()}
        add(block)
    }
}
