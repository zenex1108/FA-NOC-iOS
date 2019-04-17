//
//  KeywordsCell.swift
//  FA-NOC-iOS
//
//  Created by joowon on 16/04/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit
import TagListView

class KeywordsCell: UITableViewCell, SubmissionCellProtocol {

    @IBOutlet private weak var keywordsView: TagListView!
    
    @IBOutlet private weak var topPaddingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomPaddingConstraint: NSLayoutConstraint!
    
    private var visiblePadding: Bool {
        set{
            let padding: CGFloat = (newValue ? 8.0 : 0.0)
            topPaddingConstraint.constant = padding
            bottomPaddingConstraint.constant = padding
        }
        get{
            return (topPaddingConstraint.constant == 8.0)
        }
    }
    
    private var isInit = true
    
    func bind(_ model: SubmissionModel) {
        guard isInit else { return }
        isInit = false
        visiblePadding = (model.keywords.count > 0)
        guard visiblePadding else { return }
        
        keywordsView.removeAllTags()
        keywordsView.addTags(model.keywords)
    }
}
