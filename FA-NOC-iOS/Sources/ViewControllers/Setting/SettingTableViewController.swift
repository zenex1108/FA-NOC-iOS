//
//  SettingTableViewController.swift
//  FA-NOC-iOS
//
//  Created by joowon on 05/01/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit

enum SettingType {
    case global, browse, search, notification, submissions
}

protocol SettingTableViewControllerDelegate: NSObjectProtocol {
    func chagedSetting(_ onlyLayout:Bool)
}

class SettingModelSection {
    
    enum SettingSectionType {
        case numbers, onOff, detail
    }
    
    var name: String
    var models: [SettingModel]
    let type: SettingSectionType
    
    init(name: String, models: [SettingModel], type: SettingSectionType = .detail) {
        
        self.name = name
        self.models = models
        self.type = type
    }
}

class SettingTableViewController: UITableViewController {
    
    weak var delegate: SettingTableViewControllerDelegate?
    
    var type: SettingType!
    var sections: [SettingModelSection]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsInit()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].models.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let modelSection = sections[indexPath.section]
        let model = modelSection.models[indexPath.row]
        
        switch modelSection.type {
        case .numbers:
            
            let numbersCell: NumbersTableViewCell = tableView.cell("numbersCell", for: indexPath)
            numbersCell.binding(model: model)
            numbersCell.delegate = self
            
            return numbersCell
            
        case .detail:
            
            let detailCell: UITableViewCell = tableView.cell("rightDetailCell", for: indexPath)
            detailCell.textLabel?.text = model.name
            detailCell.detailTextLabel?.text = model.selectedSection.selectedItem?.text
            
            return detailCell
            
        case .onOff:
            
            let switchCell: SwitchTableViewCell = tableView.cell("switchCell", for: indexPath)
            switchCell.binding(model: model)
            switchCell.delegate = self
            
            return switchCell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let modelSection = sections[indexPath.section]
        if modelSection.type == .detail {
            let model = modelSection.models[indexPath.row]
            performSegue(withIdentifier: "toDetail", sender: model)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let model = sender as? SettingModel {
            let settingViewController = segue.destination as? SettingDetailTableViewController
            settingViewController?.delegate = self
            settingViewController?.model = model
        }
    }
}

extension SettingTableViewController {
    
    func settingsInit() {
        
        if type == .browse {
            
            sections = [SettingModelSection(name: Browse.View.categoryName,
                                            models: Browse.View.allCases.map{$0.model}, type: .numbers),
                        SettingModelSection(name: Browse.Filter.categoryName,
                                            models: Browse.Filter.allCases.map{$0.model}),
                        SettingModelSection(name: Browse.Rating.categoryName,
                                            models: Browse.Rating.allCases.map{$0.model}, type: .onOff)]
        }
    }
}

extension SettingTableViewController: SettingDetailDelegate {
    
    func didSelect(_ model: SettingModel) {
        
        var onlyLayout = false
        
        if type == .browse {
            Settings.setBrowse(setting: model)
            
            var row: Int!
            let section = sections.firstIndex { section in
                row = section.models.firstIndex(where: {$0===model})
                return (row != nil)
            }!
            
            if section == 1 {
                tableView.reloadRows(at: [IndexPath(row: row, section: section)], with: .automatic)
            }
            
            onlyLayout = (section == 0)
        }
        
        delegate?.chagedSetting(onlyLayout)
    }
}
