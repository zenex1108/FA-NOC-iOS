//
//  MainSearchViewController.swift
//  FA-NOC-iOS
//
//  Created by joowon on 18/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit

class MainSearchViewController: MainBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationItem.searchController = UISearchController(searchResultsController: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
