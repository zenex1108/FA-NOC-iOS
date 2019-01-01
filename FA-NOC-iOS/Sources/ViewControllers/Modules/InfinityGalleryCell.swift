//
//  InfinityGalleryCell.swift
//  FA-NOC-iOS
//
//  Created by joowon on 24/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit
import Kingfisher

class InfinityGalleryCell: InfinityCollectionViewCell {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var infoBox: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var userLabel: UILabel!
    @IBOutlet private var ratingLabel: UILabel!
    
    func binding(_ model: GalleryItemModel, numberOfColmns: Int) {
        
        let visibleInfo = (numberOfColmns == 1)
        
        infoBox.isHidden = !visibleInfo
        titleLabel.text = (visibleInfo ? model.title : nil)
        userLabel.text = (visibleInfo ? "by \(model.userName!)" : nil)
        
        ratingLabel.text = model.rating.short
        ratingLabel.textColor = model.rating.color
        
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        imageView.kf.setImage(with: model.thumbnailUrl,
                              options: [.transition(.fade(0.25))])
        
        let radius = CGFloat(16.0/Double(numberOfColmns))
        cornerRadius = radius
        ratingLabel.roundCorners(.topLeft, radius: radius, size: ratingLabel.bounds.size)
        
        if visibleInfo {
            layoutIfNeeded()
            infoBox.roundCorners(.topRight, radius: radius)
        }
    }
}
