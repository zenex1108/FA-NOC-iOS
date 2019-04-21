//
//  CommentCell.swift
//  FA-NOC-iOS
//
//  Created by joowon on 16/04/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell, CommentCellProtocol {

    @IBOutlet private weak var leftMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    
    private var _step: Int = 0
    private var step: Int {
        set{
            _step = newValue
            leftMarginConstraint.constant = UIScreen.main.bounds.width*CGFloat(newValue)*0.03
        }
        get{
            return _step
        }
    }
    
    func bind(_ model: CommentModel) {
        
        let placeholder = #imageLiteral(resourceName: "ic_placeholder").kf.image(withRoundRadius: 24.0, fit: .init(width: 48, height: 48))
        
        thumbnailImageView.kf
            .setImage(with: model.userThumbnail,
                      placeholder: placeholder,
                      options: [.transition(.fade(0.25))])
        
        step = model.commentStep
        
        userNameLabel.text = model.userNickName
        dateLabel.text = model.postedAt.toString("MMM d, yyyy HH:mm a")
        commentLabel.attributedText = model.comment
    }
}

extension Date {
    
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
