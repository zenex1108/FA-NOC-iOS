//
//  CommentsStackView.swift
//  FA-NOC-iOS
//
//  Created by joowon on 15/04/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit

class CommentsStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(_ commentSet: CommentModelSet) {
        
        let views = commentSet.comments.map{CommentView.loadView().bind($0)}
        self.init(arrangedSubviews: views)
        
        axis = .vertical
        distribution = .equalSpacing
    }
}
