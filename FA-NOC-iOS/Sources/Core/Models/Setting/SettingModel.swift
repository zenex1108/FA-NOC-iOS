//
//  SettingModel.swift
//  FA-NOC-iOS
//
//  Created by joowon on 05/01/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit

class SettingModel {
    
    let name: String
    let sections: [SettingSection]
    var selectedSection: SettingSection!
    
    var description: String {
        return name+"\n"+sections.map{$0.description}.reduce("", {$0+"\n"+$1})
    }
    
    var selectedIndexPath: IndexPath {
        let section = sections.firstIndex(where: {$0.name==selectedSection.name})!
        let row = selectedSection.items.firstIndex(where: {$0.value==selectedSection.selectedItem!.value})!
        return IndexPath(row: row, section: section)
    }
    
    init(name: String, sections: [SettingSection]) {
        self.name = name
        self.sections = sections
    }
    
    func select(value: String?) {
        guard let value = value else { return }
        selectedSection = sections.filter{$0.select(value: value) != nil}.first!
    }
}

class SettingSection {
    
    let name: String
    let items: [SettingItem]
    var selectedItem: SettingItem?
    
    var description: String {
        return name+"\n"+items.map{$0.description}.reduce("", {$0+"\n"+$1})
    }
    
    init(name: String, items: [SettingItem]) {
        
        self.name = name
        self.items = items
    }
    
    @discardableResult
    func select(value: String) -> SettingItem? {
        
        selectedItem?.selected = false
        selectedItem = items.filter{$0.value==value}.first
        
        selectedItem?.selected = true
        
        return selectedItem
    }
}

class SettingItem: EnumValueProtocol {
    
    let text: String
    let value: String
    var selected: Bool
    
    internal var enumValue: Any?
    
    var description: String {
        return text+" "+value
    }
    
    required init(text: String, value: String, enumValue: Any? = nil) {
        
        self.text = text
        self.value = value
        selected = false
        
        self.enumValue = enumValue
    }
}

protocol EnumValueProtocol {
    associatedtype enumType
    var enumValue:enumType {get}
    init(text: String, value: String, enumValue:enumType)
}
