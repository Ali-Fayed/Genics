//
//  SettingsView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 26/12/2020.
//

import UIKit

class SettingsViewController: UITableViewController {
     
    var Setting = Titles.darkMode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(Cells.signOutNib(), forCellReuseIdentifier: Cells.signOutCell)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = Titles.settingsViewTitle

    }
}
