//
//  ImageCell.swift
//  FA-NOC-iOS
//
//  Created by joowon on 16/04/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit
import Kingfisher

class ImageCell: UITableViewCell, SubmissionCellProtocol {

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var imageHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func bind(_ model: SubmissionModel) {
        
        let screenWidth = Double(UIScreen.main.bounds.width)
        let ratio = model.galleryModel.ratio!
        let height = screenWidth*ratio
        
        let placeholder = GalleryPlaceholder(width: screenWidth,
                                             heightRatio: ratio,
                                             tip: 0.615)
        thumbnailImageView.kf
            .setImage(with: model.galleryModel.thumbnailUrl,
                      placeholder: placeholder,
                      options: [.transition(.fade(0.25))])
        
        imageHeightConstraint.constant = CGFloat(height)
    }
}
