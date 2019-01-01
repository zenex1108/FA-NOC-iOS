//
//  Settings.swift
//  FA-NOC-iOS
//
//  Created by joowon on 19/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit

struct SettingModel {
    let sections: [SettingSection]
    
    var description: String {
        return sections.map{$0.description}.reduce("", {$0+"\n\n"+$1})
    }
}

struct SettingSection {
    let category: String
    let items: [SettingItem]
    
    var description: String {
        return category+"\n"+items.map{$0.description}.reduce("", {$0+"\n"+$1})
    }
}

struct SettingItem {
    let text: String
    let value: String
    
    var description: String {
        return text+" "+value
    }
}

class Settings: NSObject {
    
    static private let kbrowseParameters = "kbrowseParameters"
    static private var browseParameters: [String:Any]!
    
    
    static func browseList(_ category:Browse.List) -> SettingModel {
        return category.model
    }
    
    static func setBrowse(category:Browse.Category,
                          type:Browse.BType,
                          species:Browse.Species,
                          gender:Browse.Gender,
                          results:Browse.Results,
                          general:Bool, mature:Bool, adult:Bool) {

        objc_sync_enter(kbrowseParameters)
        defer {objc_sync_exit(kbrowseParameters)}
        
        browseParameters?.removeAll()
        browseParameters = ["cat": category.value,
                            "atype": type.value,
                            "species": species.value,
                            "gender": gender.rawString,
                            "perpage": results.rawString]
        
        if general { browseParameters["rating_general"] = "on" }
        if mature { browseParameters["rating_mature"] = "on" }
        if adult { browseParameters["rating_adult"] = "on" }
        
        UserDefaults.standard.set(browseParameters, forKey: kbrowseParameters)
        UserDefaults.standard.synchronize()
    }
    
    static func getBrowse() -> [String:Any] {
        
        objc_sync_enter(kbrowseParameters)
        defer {objc_sync_exit(kbrowseParameters)}
        
        if browseParameters == nil {
            browseParameters = UserDefaults.standard.dictionary(forKey: kbrowseParameters)
        }
        if browseParameters == nil {
            setBrowse(category: .visualArt(.all), type: .generalThings(.all), species: .unspecifiedOrAny, gender: .any, results: .fe, general: true, mature: false, adult: false)
        }
        
        return browseParameters
    }
}
