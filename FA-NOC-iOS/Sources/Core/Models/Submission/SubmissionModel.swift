//
//  SubmissionModel.swift
//  FA-NOC-iOS
//
//  Created by joowon on 19/01/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import Foundation

class SubmissionModel {

    var galleryModel: GalleryItemModel!
    
    var category: String!
    var speciese: String!
    var gender: String!
    
    var views: Int = 0
    var favorites: Int = 0
    var comments: Int = 0
    
    var keywords: [String]!
    
    var favUrl: URL!
    
    var contentOriginalUrl: URL!
    
    var userThumbnail: URL!
    
    init(_ galleryModel: GalleryItemModel) {
        self.galleryModel = galleryModel
    }
}
