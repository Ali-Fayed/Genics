//
//  SettingsViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 26/12/2020.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import SafariServices

class SettingsViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var setting = Titles.darkMode
    var settings = [Titles.darkMode , Titles.removeAllRecords , Titles.removeAllBookmarks]
    var policy = ["\(Titles.privacyPolicyTitle)" , "\(Titles.termsOfUseTitle)"]
    
    var isLoggedIn: Bool {
        if TokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
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
