//
//  SettingsView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 26/12/2020.
//

import UIKit

class SettingsViewController: UITableViewController {
     
    var Setting = Titles.darkMode
    var isLoggedIn: Bool {
      if TokenManager.shared.fetchAccessToken() != nil {
        return true
      }
      return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellNib(cellClass: SignOutCell.self)
        tableView.registerCellNib(cellClass: LanguageCell.self)
        tableView.tableFooterView = UIView()
        title = Titles.settingsViewTitle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = Titles.settingsViewTitle
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
}