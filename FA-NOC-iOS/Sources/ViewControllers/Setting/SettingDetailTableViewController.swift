//
//  SettingDetailTableViewController.swift
//  FA-NOC-iOS
//
//  Created by joowon on 05/01/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit

protocol SettingDetailDelegate: NSObjectProtocol {
    func didSelect(_ model: SettingModel)
}

class SettingDetailTableViewController: UITableViewController {

    weak var delegate: SettingDetailDelegate?
    
    var model: SettingModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = model.name
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.sections[section].items.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.sections[section].name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = model.sections[indexPath.section].items[indexPath.row]
        let cell: UITableViewCell = tableView.cell("selectCell", for: indexPath)
        cell.textLabel?.text = item.text
        cell.accessoryType = (item.selected ? .checkmark : .none)

        return cell
    }
 
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let prevInadexPath = model.selectedIndexPath
        
        let item = model.sections[indexPath.section].items[indexPath.row]
        model.select(value: item.value)
        
        delegate?.didSelect(model)
        
        tableView.reloadRows(at: [prevInadexPath, indexPath], with: .automatic)
    }
}
