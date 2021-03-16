//
//  SettingsViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 26/12/2020.
//

import UIKit
import Alamofire
import SwiftyJSON

class SettingsViewController: UITableViewController {
    
    var Setting = Titles.darkMode
    var isLoggedIn: Bool {
        if GitTokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellNib(cellClass: SignOutCell.self)
        tableView.registerCellNib(cellClass: LanguageCell.self)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 50
        title = Titles.settingsViewTitle
        if isLoggedIn {
            //
        } else {
            tableView.tableHeaderView = nil
        }
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = Titles.settingsViewTitle
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        if isLoggedIn {
            //
        } else {
            tableView.tableHeaderView = nil
        }
    }
}


extension SettingsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
          return  1
        case 1:
           return 1
        default:
           return 1
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
                let cell = tableView.dequeue() as SettingsCell
                cell.DarkModeLabel?.text = Setting
                return cell
        case 1:
                let cell = tableView.dequeue() as LanguageCell
                cell.languageDelegate = self
                return cell
        default:
                    let cell = tableView.dequeue() as SignOutCell
                    cell.delegate = self
                    return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerText = UILabel()
        switch section {
        case 0:
                headerText.text = "Apperance"
        case 1:
                headerText.text = "Language"
        default:
                headerText.text = "Account"
        }
        return headerText.text
    }
    

}
