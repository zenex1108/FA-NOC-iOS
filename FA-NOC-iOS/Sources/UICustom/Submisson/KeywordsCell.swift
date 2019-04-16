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
    
    func bind(_ model: SubmissionModel) {
        
        keywordsView.removeAllTags()
        keywordsView.addTags(model.keywords)
    }
}
