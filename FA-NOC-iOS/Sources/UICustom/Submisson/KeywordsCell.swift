//
//  KeywordsCell.swift
//  FA-NOC-iOS
//
//  Created by joowon on 16/04/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit

class KeywordsCell: UITableViewCell, SubmissionCellProtocol {

    @IBOutlet private weak var keywordsView: MarginTagListView!
    
    @IBOutlet private weak var topPaddingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomPaddingConstraint: NSLayoutConstraint!
    
    private var isInit = true
    
    func bind(_ model: SubmissionModel) {
        
        guard isInit else { return }
        isInit = false
        
        guard (model.keywords.count > 0) else {
            topPaddingConstraint.constant = 0.0
            bottomPaddingConstraint.constant = 0.0
            keywordsView.fixedHeight = 1.0
            contentView.backgroundColor = .clear
            return
        }
        
        
        keywordsView.removeAllTags()
        keywordsView.addTags(model.keywords)
    }
}
