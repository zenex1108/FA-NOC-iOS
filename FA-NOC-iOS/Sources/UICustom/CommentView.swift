//
//  CommentView.swift
//  FA-NOC-iOS
//
//  Created by joowon on 15/04/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit
import ActiveLabel
import Kingfisher

class CommentView: UIView {

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var commentLabel: ActiveLabel!
    
    @discardableResult
    func bind(_ model: CommentModel) -> CommentView {
        
        let placeholder = GalleryPlaceholder(width: 40.0,
                                             heightRatio: 1.0,
                                             tip: 0.615)
        thumbnailImageView.kf
            .setImage(with: model.userThumbnail,
                      placeholder: placeholder,
                      options: [.transition(.fade(0.25))])
        
        commentLabel.text = model.comment
        
        return self
    }

}
