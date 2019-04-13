//
//  InfinityGalleryCell.swift
//  FA-NOC-iOS
//
//  Created by joowon on 24/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit
import Kingfisher
import Hue

class InfinityGalleryCell: InfinityCollectionViewCell {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var infoBox: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var userLabel: UILabel!
    
    func binding(_ model: GalleryItemModel, numberOfColumns: Int, placeholder: Placeholder) {
        
        let visibleInfo = (numberOfColumns == 1)
        
        infoBox.isHidden = !visibleInfo
        titleLabel.text = (visibleInfo ? model.title : nil)
        userLabel.text = (visibleInfo ? "by \(model.userName!)" : nil)
        
        outlineWidth = CGFloat(6-numberOfColumns)
        outlineColor = model.rating.color.alpha(0.2+CGFloat(numberOfColumns)/10)
        
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        imageView.kf.setImage(with: model.thumbnailUrl,
                              placeholder: placeholder,
                              options: [.transition(.fade(0.25))])
        
        cornerRadius = CGFloat(16.0/Double(numberOfColumns))
    }
}


