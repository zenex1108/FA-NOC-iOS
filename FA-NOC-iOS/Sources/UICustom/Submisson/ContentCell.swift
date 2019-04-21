//
//  ContentCell.swift
//  FA-NOC-iOS
//
//  Created by joowon on 16/04/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit

class ContentCell: UITableViewCell, SubmissionCellProtocol {

    @IBOutlet private weak var contentLabel: UILabel!
    
    func bind(_ model: SubmissionModel) {
        
        contentLabel.attributedText = model.description
    }
}

