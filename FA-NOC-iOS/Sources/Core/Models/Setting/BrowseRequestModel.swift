//
//  BrowseRequestModel.swift
//  FA-NOC-iOS
//
//  Created by joowon on 05/01/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import Foundation
import ObjectMapper

class BrowseRequestModel: Mappable {
    
    var category: String!
    var type: String!
    var species: String!
    var gender: String!
    var results: String = "72"
    
    var general: String?
    var mature: String?
    var adult: String?
    
    var page: String?
    var go: String = "Apply"
    
    //non-mapped
    var columnCount: String = "1"
    
    init(category:Browse.Category = .visualArt(.all),
         type:Browse.BType = .generalThings(.all),
         species:Browse.Species = .unspecifiedOrAny(.default),
         gender:Browse.Gender = .any,
         general:Bool = true, mature:Bool = true, adult:Bool = true) {
        
        self.category = category.value
        self.type = type.value
        self.species = species.value
        self.gender = gender.rawString
        
        self.general = (general ? "on" : nil)
        self.mature = (mature ? "on" : nil)
        self.adult = (adult ? "on" : nil)
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        category    <- map["cat"]
        type        <- map["atype"]
        species     <- map["species"]
        gender      <- map["gender"]
        results     <- map["perpage"]
        
        general     <- map["rating_general"]
        mature      <- map["rating_mature"]
        adult       <- map["rating_adult"]
        
        page        <- map["page"]
        go          <- map["go"]
    }
}
