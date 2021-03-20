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

    var Setting = Titles.darkMode
    var Settings = ["Dark Mode" , "App Icon" , "Remove All Bookmarks"]
    var policy = ["\(Titles.privacyPolicy)" , "\(Titles.terms)"]
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
          return  3
        case 1:
           return 2
        case 2:
           return 1
        default:
           return 1
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeue() as SettingsCell
            cell.DarkModeLabel?.text = Setting
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "celll", for: indexPath)
            cell.textLabel?.text = Settings[indexPath.row]
                return cell
            }
 
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" )
            cell!.textLabel?.text = policy[indexPath.row]
            return cell!
        case 2:
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
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                break
            case 1:
                break
            default:
                //
                let resetSearchHistory = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.usersEntity)
                let resetLastSearch = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.repositoryEntity)
                let resetRequest = NSBatchDeleteRequest(fetchRequest: resetSearchHistory)
                let resetRequest2 = NSBatchDeleteRequest(fetchRequest: resetLastSearch)
                
                do {
                    try self.context.execute(resetRequest)
                    try self.context.execute(resetRequest2)
                    try self.context.save()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        HapticsManger.shared.selectionVibrate(for: .heavy)
                    }
                } catch {
                    //
                }
                //
                
            }
           case 1:
            switch indexPath.row {
            case 0:
                let url = "https://docs.github.com/en/github/site-policy/github-privacy-statement"
                let vc = SFSafariViewController(url: URL(string: url)!)
                self.present(vc, animated: true)
            default:
                let url = "https://docs.github.com/en/github/site-policy/github-terms-of-service"
                let vc = SFSafariViewController(url: URL(string: url)!)
                self.present(vc, animated: true)
            }
        default:
            break
        }
    }
    
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerText = UILabel()
        switch section {
        case 0:
                headerText.text = "General"
        case 1:
                headerText.text = "Policy"
        case 2:
                headerText.text = "Language"
        default:
                headerText.text = "Account"
        }
        return headerText.text
    }
    

}
