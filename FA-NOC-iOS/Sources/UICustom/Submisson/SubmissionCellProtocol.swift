//
//  SubmissionCell.swift
//  FA-NOC-iOS
//
//  Created by joowon on 16/04/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit

protocol SubmissionCellProtocol {
    func bind(_ model: SubmissionModel)
}

protocol CommentCellProtocol {
    func bind(_ model: CommentModel)
}

protocol SubmissionCellDataProtocol {}

extension SubmissionModel: SubmissionCellDataProtocol {}
extension CommentModel: SubmissionCellDataProtocol {}
