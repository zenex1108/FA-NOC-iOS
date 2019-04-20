//
//  MarginTagListView.swift
//  FA-NOC-iOS
//
//  Created by joowon on 19/04/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit
import TagListView

class MarginTagListView: TagListView {
    
    var fixedHeight: CGFloat?

    override var intrinsicContentSize: CGSize {
        let superIntrinsic = super.intrinsicContentSize
        return CGSize(width: superIntrinsic.width, height: fixedHeight ?? superIntrinsic.height)
    }
}
