//
//  SVC TableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 10/04/2021.
//

import UIKit
import CoreData
import SafariServices

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
                let cell = tableView.dequeue() as DarkModeCell
                cell.darkModeLabel?.text = setting
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = settings[indexPath.row]
                return cell
            }
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath )
            cell.textLabel?.text = policy[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            return cell
        case 2:
            let cell = tableView.dequeue() as LanguageCell
            return cell
        default:
            let cell = tableView.dequeue() as SignOutCell
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
                let resetSearchHistory = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.searchHistoryEntity)
                let resetLastSearch = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.lastSearchEntity)
                let resetHistory = NSBatchDeleteRequest(fetchRequest: resetSearchHistory)
                let resetLast = NSBatchDeleteRequest(fetchRequest: resetLastSearch)
                do {
                    try context.execute(resetHistory)
                    try context.execute(resetLast)
                    try context.save()
                    DispatchQueue.main.async {
                        HapticsManger.shared.selectionVibrate(for: .heavy)
                    }
                    
                } catch {
                    //
                }
            default:
                //
                let resetUsersEntity = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.usersEntity)
                let resetRepositoryEntity = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.repositoryEntity)
                let resetUsers = NSBatchDeleteRequest(fetchRequest: resetUsersEntity)
                let resetRepos = NSBatchDeleteRequest(fetchRequest: resetRepositoryEntity)
                
                do {
                    try self.context.execute(resetUsers)
                    try self.context.execute(resetRepos)
                    try self.context.save()
                    DispatchQueue.main.async {
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
                let policyURL = "https://docs.github.com/en/github/site-policy/github-privacy-statement"
                let policyVC = SFSafariViewController(url: URL(string: policyURL)!)
                self.present(policyVC, animated: true)
            default:
                let termsURL = "https://docs.github.com/en/github/site-policy/github-terms-of-service"
                let termsVC = SFSafariViewController(url: URL(string: termsURL)!)
                self.present(termsVC, animated: true)
            }
        case 2:
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        default:
            if isLoggedIn {
                navigationController?.popViewController(animated: true)
                TokenManager.shared.clearAccessToken()
            } else {
                let loginView = UIStoryboard.init(name: Storyboards.loginView, bundle: Bundle.main).instantiateViewController(withIdentifier: ID.loginViewControllerID) as? LoginViewController
                loginView?.hidesBottomBarWhenPushed = true
                loginView?.getGitHubAccessToken()
                navigationController?.pushViewController(loginView!, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerText = UILabel()
        switch section {
        case 0:
            headerText.text = Titles.generalHeaderTitle
        case 1:
            headerText.text = Titles.policyHeaderTitle
        case 2:
            headerText.text = Titles.languageHeaderTitle
        default:
            headerText.text = Titles.accountHeaderTitle
        }
        return headerText.text
    }
}
