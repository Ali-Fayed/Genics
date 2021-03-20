//
//  HVC Table.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/03/2021.
//

import UIKit

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView {
            return 3
        } else if tableView == self.historyTable {
            return 1
        } else if tableView == self.searchFieldsTable {
            return 1
        }
        return Int()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            switch section {
            case 0:
                return profileTableData.count
            case 1:
             return  1
            default:
                return 1
            }
        } else if tableView == self.historyTable {
            return searchHistory.count
        } else if tableView == self.searchFieldsTable {
            return searchTableData.count
        }
        return Int ()
   }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.historyTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell!.textLabel?.text = searchHistory[indexPath.row].keyword
            cell!.accessoryView = UIImageView(image: UIImage(systemName: "arrow.up.backward"))
            return cell!
        }
        else if tableView == self.tableView {
            switch (indexPath.section) {
            case 0:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
             cell.textLabel?.text = profileTableData[indexPath.row].cellHeader
             cell.imageView?.image = UIImage(named: profileTableData[indexPath.row].Image)
             cell.imageView?.layer.cornerRadius = 10
             cell.imageView?.clipsToBounds = true
             return cell
            case 1:
             let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
                cell.textLabel?.text = "Githubgenics"
                cell.detailTextLabel?.text = "Ali-Fayed"
                cell.imageView?.image = UIImage(named: "ali")
               cell.imageView?.contentMode = .scaleAspectFit
                cell.imageView?.layer.masksToBounds = false
                cell.imageView?.clipsToBounds = true
                cell.imageView?.layer.cornerRadius = 10
             return cell
            default:
             let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
             if isLoggedIn {
                 cell.textLabel?.text = "Authenticated User Mode"
                 cell.accessoryType = .none
             } else {
                 cell.textLabel?.text = "Guest Mode"
             }
             return cell
            }
        } else if tableView == self.searchFieldsTable {
            if  let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")  {
                 let searchText = search.searchBar.text
                cell.textLabel?.text = searchTableData[indexPath.row].cellHeader + " with " + "'" + searchText! + "'"
             cell.imageView?.image = UIImage(named: searchTableData[indexPath.row].Image)
             cell.imageView?.layer.cornerRadius = 10
             cell.imageView?.clipsToBounds = true
                let view = cell.contentView
                view.layer.opacity = 0.8
                UIView.animate(withDuration: 0.5) {
                    view.layer.transform = CATransform3DIdentity
                    view.layer.opacity = 1
                }
             return cell
            }
        }
        return UITableViewCell()
   }
    

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        let label = UILabel(frame: CGRect(x: 15, y: 5, width: sectionView.frame.size.width - 15, height: sectionView.frame.height-10))
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        sectionView.addSubview(label)
        if tableView == self.historyTable {
            return nil
        } else if tableView == self.tableView {
            switch section {
            case 0:
                label.text = "Explore"
              return sectionView
            case 1:
                label.text = "Repo"
                return sectionView
            default:
                label.text = "State"
                return sectionView
            }
        } else if tableView == self.searchFieldsTable {
        }
        return UIView()
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerText = UILabel()
        if tableView == self.historyTable {
            switch section {
            case 0:
                if self.searchHistory.isEmpty == false {
                    headerText.text = "RECENT SEARCH"
                } else {
                    return nil
                }
            default:
                break
            }
        } else if tableView == self.tableView {
           return nil
        } else if tableView == self.searchFieldsTable {
        }
        return headerText.text

      }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let Footer = UIView()
        return Footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.historyTable {
            return 40
        } else if tableView == self.tableView {
            switch section {
            case 0:
              return 40
            case 1:
              return 40
            default:
                return 40
            }
        }else if tableView == self.searchFieldsTable {
            return 0
        }
        return CGFloat()
    }
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.historyTable {
            return 60
        } else if tableView == self.tableView {
            switch indexPath.section {
            case 0:
              return 60
            case 1:
              return 60
            default:
                return 60
            }
        } else if tableView == self.searchFieldsTable {
            return 60
        }
        return CGFloat()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.historyTable {
            self.historyTable.deselectRow(at: indexPath, animated: true)
            let history = searchHistory[indexPath.row].keyword
            DispatchQueue.main.async {
                self.search.searchBar.text = history
                self.search.searchBar.becomeFirstResponder()
            }
        } else if tableView == self.tableView {
            self.tableView.deselectRow(at: indexPath, animated: true)
            switch indexPath.section {
            case 0:
                if indexPath.row == 0 {
                    let vc = UIStoryboard.init(name: Storyboards.UsersView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.usersListViewID) as? UsersViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                } else if indexPath.row == 1 {
                    let vc = UIStoryboard.init(name: Storyboards.ReposView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.repositoriesViewController) as? RepositoriesViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                } else if indexPath.row == 2 {
                    let vc = UIStoryboard.init(name: Storyboards.IssuesView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.issuesViewController) as? IssuesViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                } else if indexPath.row == 3 {
                    let vc = UIStoryboard.init(name: Storyboards.commits , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.commitsViewControllerID) as? CommitsViewController
                    vc?.searchCommitsFetch ()
                    vc?.navigationController?.navigationItem.largeTitleDisplayMode = .always
                    vc?.navigationController?.navigationBar.prefersLargeTitles = true
                    self.navigationController?.pushViewController(vc!, animated: true)
                } else if indexPath.row == 4 {
                    let vc = UIStoryboard.init(name: Storyboards.usersOrgs , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.usersOrgsViewControllerID) as? OrgsViewController
                    vc?.fetchOrgsList ()
                    self.navigationController?.pushViewController(vc!, animated: true)
                }else if indexPath.row == 5 {
                    let vc = GithubViewController()
                    vc.navigationItem.largeTitleDisplayMode = .always
                    vc.navigationController?.navigationBar.prefersLargeTitles = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 1:
                break
            default:
                break
            }
        } else if tableView == self.searchFieldsTable {
            tableView.deselectRow(at: indexPath, animated: true)
            guard let text = search.searchBar.text else { return }
            let history = SearchHistory(context: self.context)
                history.keyword = text
                try! self.context.save()
            if indexPath.row == 0 {
                let vc = UIStoryboard.init(name: Storyboards.UsersView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.usersListViewID) as? UsersViewController
                vc?.search.searchBar.text = self.search.searchBar.text
                self.navigationController?.pushViewController(vc!, animated: true)
            } else if indexPath.row == 1 {
                let vc = UIStoryboard.init(name: Storyboards.ReposView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.repositoriesViewController) as? RepositoriesViewController
                vc?.search.searchBar.text = self.search.searchBar.text
                self.navigationController?.pushViewController(vc!, animated: true)
                
            } else if indexPath.row == 2 {
                let vc = UIStoryboard.init(name: Storyboards.IssuesView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.issuesViewController) as? IssuesViewController
                vc?.search.searchBar.text = self.search.searchBar.text
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView == self.historyTable {
            return .delete

        } else if tableView == self.tableView {
            
        } else if tableView == self.searchFieldsTable {
            
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == self.historyTable {
            if editingStyle == .delete {
                tableView.beginUpdates()
                switch indexPath.section {
                case 0:
                    let item = searchHistory[indexPath.row]
                    DataBaseManger.shared.Delete(returnType: SearchHistory.self, Delete: item)
                    DataBaseManger.shared.Fetch(returnType: SearchHistory.self) { (history) in
                        self.searchHistory = history
                    }
                default:
                   break
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                DispatchQueue.main.async {
                    if self.searchHistory.isEmpty == true {
                        self.searchLabel.isHidden = false
                    }
                    self.historyTable.reloadData()
                }
            }
        } else if tableView == self.tableView {
            
        } else if tableView == self.searchFieldsTable {
            
        }
    }
    
    

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == self.searchFieldsTable {
            cell.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), animations: {
                  cell.alpha = 1
            })
        }
        
    }
}
