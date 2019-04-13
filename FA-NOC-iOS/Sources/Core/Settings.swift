//
//  Settings.swift
//  FA-NOC-iOS
//
//  Created by joowon on 19/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit

class Settings: NSObject {
    
    static private let kbrowseParameters = "kbrowseParameters"
    static private var browseParameters: BrowseRequestModel!
    
    static func setBrowse(setting model: SettingModel) {
        
        let value = model.selectedSection.selectedItem?.value
        
        switch model.name {
        case Browse.ColumnCount.categoryName: browseParameters.columnCount = value!
        case Browse.Category.categoryName: browseParameters.category = value
        case Browse.BType.categoryName: browseParameters.type = value
        case Browse.Species.categoryName: browseParameters.species = value
        case Browse.Gender.categoryName: browseParameters.gender = value
        case Browse.RatingGeneral.categoryName: browseParameters.general = (value == "on" ? value : nil)
        case Browse.RatingMature.categoryName: browseParameters.mature = (value == "on" ? value : nil)
        case Browse.RatingAdult.categoryName: browseParameters.adult = (value == "on" ? value : nil)
        default: break
        }
        
        setBrowse(request: browseParameters)
    }
    
    static func setBrowse(request model: BrowseRequestModel) {
        
        browseParameters = model
        
        var json = model.toJSON()
        json[Browse.ColumnCount.categoryName] = model.columnCount
        
        UserDefaults.standard.set(json, forKey: kbrowseParameters)
        UserDefaults.standard.synchronize()
    }
    
    static func getBrowse() -> BrowseRequestModel {
        
        if browseParameters == nil {
            if let json = UserDefaults.standard.dictionary(forKey: kbrowseParameters) {
                browseParameters = BrowseRequestModel(JSON: json)
                browseParameters.columnCount = json[Browse.ColumnCount.categoryName] as! String
            }
        }
        if browseParameters == nil {
            setBrowse(request: BrowseRequestModel())
        }
        
        return browseParameters
    }
}
