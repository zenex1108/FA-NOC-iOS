//
//  InfoCell.swift
//  FA-NOC-iOS
//
//  Created by joowon on 16/04/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit
import Kingfisher

class InfoCell: UITableViewCell, SubmissionCellProtocol {

    @IBOutlet private weak var userProfileImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    
    func bind(_ model: SubmissionModel) {
        
        let placeholder = #imageLiteral(resourceName: "ic_placeholder").kf.image(withRoundRadius: 24.0, fit: .init(width: 48, height: 48))
        
        userProfileImageView.kf
            .setImage(with: model.userThumbnail,
                      placeholder: placeholder,
                      options: [.transition(.fade(0.25))])
        
        userNameLabel.text = model.galleryModel.userName
    }
}
