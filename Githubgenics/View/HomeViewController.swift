//
//  HomeViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 16/03/2021.
//

import UIKit
import SwiftyJSON
import SafariServices

class HomeViewController: UIViewController {
    var searchHistory = [SearchHistory]()

    var profileTableData = [ProfileTableData]()
    var projectRepo = [Repository]()
    var isLoggedIn: Bool {
        if GitTokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var searchFieldsTable: UITableView!

    
    private var search = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellNib(cellClass: SearchHistoryCell.self)
        self.historyTable.isHidden = true
        self.searchFieldsTable.isHidden = true
        searchRepositories ()
        DataBaseManger().Fetch(returnType: SearchHistory.self) { [weak self] (result) in
            self?.searchHistory = result
    

        }
        search.searchBar.delegate = self
        search.searchBar.sizeToFit()
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = true
        self.definesPresentationContext = true
        search.searchBar.placeholder = Titles.searchPlacholder
        self.navigationItem.searchController = search
        tableView.addSubview(refreshControl)
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.usersViewTitle)", Image: "Profile"))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.repositoriesViewTitle)", Image: "Repositories" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.Issues)", Image: "Issues"))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.commitsViewTitle)", Image: "Startted" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.Organizations)", Image: "Organizations"))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.gitHubURL)", Image: "GithubWeb"))
    }
    
    func searchRepositories () {
        GitAPIcaller.shared.makeRequest(returnType: [Repository].self, requestData: GitRequestRouter.gitProjectRepo) { [weak self] (repositories) in
            self?.projectRepo = repositories
            self?.tableView.reloadData()
        }
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
}

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
            return profileTableData.count
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
             session.request(GitRequestRouter.gitProjectRepo).responseJSON { (response) in
                 switch response.result {
                 case .success(let responseJSON) :
                     let recievedJson = JSON (responseJSON)
                     cell.textLabel?.text = recievedJson["\(User.userName)"].stringValue
                     cell.detailTextLabel?.text = recievedJson["owner"]["login"].stringValue
                     let url = recievedJson["owner"]["avatar_url"].stringValue
                     let fileUrl = URL(string: url)
                     let data = try? Data(contentsOf: fileUrl!)
                     let image = UIImage(data: data!)
                     cell.imageView?.image = image
                     cell.imageView?.contentMode = .scaleToFill
                     cell.imageView?.layer.masksToBounds = false
                     cell.imageView?.clipsToBounds = true
                     cell.imageView?.layer.cornerRadius = ((cell.bounds.height) / 2)
                 case .failure(let error):
                     print(error)
                 }
             }
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
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
         cell.textLabel?.text = profileTableData[indexPath.row].cellHeader
         cell.imageView?.image = UIImage(named: profileTableData[indexPath.row].Image)
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
        return UITableViewCell()
   }
    

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        let label = UILabel(frame: CGRect(x: 15, y: 5, width: sectionView.frame.size.width - 15, height: sectionView.frame.height-10))
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        sectionView.addSubview(label)
        if tableView == self.historyTable {
            label.text = "Recent Search"
            return sectionView
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
                    let vc = UIStoryboard.init(name: Storyboards.tabBar , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.usersListViewID) as? UsersViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                } else if indexPath.row == 1 {
                    let vc = UIStoryboard.init(name: Storyboards.tabBar , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.repositoriesViewController) as? RepositoriesViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                } else if indexPath.row == 2 {
                    let vc = UIStoryboard.init(name: Storyboards.IssuesView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.issuesViewController) as? IssuesViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                } else if indexPath.row == 3 {
                    let vc = UIStoryboard.init(name: Storyboards.commits , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.commitsViewControllerID) as? CommitsViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                } else if indexPath.row == 4 {
                    let vc = UIStoryboard.init(name: Storyboards.usersOrgs , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.usersOrgsViewControllerID) as? UsersOrgsViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }else if indexPath.row == 5 {
                    let vc = GithubViewController()
                    vc.navigationItem.largeTitleDisplayMode = .never
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 1:
                break
            default:
                break
            }
        } else if tableView == self.searchFieldsTable {
            tableView.deselectRow(at: indexPath, animated: true)
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
            }
        } else if tableView == self.tableView {
            
        } else if tableView == self.searchFieldsTable {
            
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
                navigationItem.hidesSearchBarWhenScrolling = true
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        DispatchQueue.main.async {
            if self.search.searchBar.text?.isEmpty == true {
                self.tableView.isHidden = true
                self.historyTable.isHidden = false
                self.searchFieldsTable.isHidden = true
            } else {
                self.tableView.isHidden = true
                self.historyTable.isHidden = true
                self.searchFieldsTable.isHidden = false
            }
            self.historyTable.reloadData()
            self.search.searchBar.showsCancelButton = true
        }
        
        UIView.animate(withDuration: 0.3, animations: {
      
        })
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.historyTable.isHidden = true
            self.searchFieldsTable.isHidden = true
            self.historyTable.reloadData()
            self.search.searchBar.showsCancelButton = false
        }

    }
}
