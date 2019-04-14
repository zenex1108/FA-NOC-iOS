//
//  CommentModel.swift
//  FA-NOC-iOS
//
//  Created by joowon on 14/04/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit

class CommentModel {

    let commentId: String
    let postedAt: Date
    let commentStep: Int
    let comment: String
    
    let userNickName: String
    let userThumbnail: URL
    
    let userPageLink: URL
    let userGalleryUrl: URL
    let userJounalUrl: URL
    let userSendNoteUrl: URL
    let commentUrl: URL
    
    let replyLink: URL
    
    var subComments = [CommentModel]()
    
    init(commentId: String,
         postedAt: Date,
         commentStep: Int,
         comment: String,
         userNickName: String,
         userThumbnail: URL,
         userPageLink: URL,
         userGalleryUrl: URL,
         userJounalUrl: URL,
         userSendNoteUrl: URL,
         commentUrl: URL,
         replyLink: URL) {
        
        self.commentId = commentId
        self.postedAt = postedAt
        self.commentStep = commentStep
        self.comment = comment
        self.userNickName = userNickName
        self.userThumbnail = userThumbnail
        self.userPageLink = userPageLink
        self.userGalleryUrl = userGalleryUrl
        self.userJounalUrl = userJounalUrl
        self.userSendNoteUrl = userSendNoteUrl
        self.commentUrl = commentUrl
        self.replyLink = replyLink
    }
}
