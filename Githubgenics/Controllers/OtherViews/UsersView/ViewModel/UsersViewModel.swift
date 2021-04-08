//
//  UsersViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 08/04/2021.
//

import UIKit
import CoreData
import JGProgressHUD

class UsersViewModel {
    
    var searchHistory = [SearchHistory]()
    var usersModel = [items]()
    var savedUsers = [UsersDataBase]()
    var passedUsers : items?
    var lastSearch = [LastSearch]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pageNo : Int = 1
    var totalPages : Int = 100
    
    
    var numberOfSearchHistoryCell: Int {
        return searchHistory.count
    }
    var numberOfUsersCells: Int {
        return usersModel.count
    }
    var numberOfSavedUsersCells: Int {
        return savedUsers.count
    }
    
    var numberOfLastSearchCells: Int {
        return lastSearch.count
    }
    
    func getSearchHistoryViewModel( at indexPath: IndexPath ) -> SearchHistory {
        return searchHistory[indexPath.row]
    }
    
    func getUsersCellsViewModel( at indexPath: IndexPath ) -> items {
        return usersModel[indexPath.row]
    }
    
    func getSavedUsersViewModel( at indexPath: IndexPath ) -> UsersDataBase {
        return savedUsers[indexPath.row]
    }
    
    func getLastSearchViewModel( at indexPath: IndexPath ) -> LastSearch {
        return lastSearch[indexPath.row]
    }
    
    func query (searchText : String? ) -> String {
        let query : String = {
            var queryString = String()
            if let searchText = searchText {
                queryString = searchText.isEmpty ? "a" : searchText
            }
            return queryString
        }()
        return query
    }
    
    // fetch users in table
    func renderUsersList (tableView: UITableView , searchController: UISearchController, loadingSpinner: JGProgressHUD )  {
        GitAPIcaller.shared.makeRequest(returnType: Users.self, requestData: GitRequestRouter.gitSearchUsers(pageNo, "R")) { [weak self] (users) in
            DispatchQueue.main.async {
                self?.usersModel = users.items
                tableView.reloadData()
                if searchController.searchBar.showsCancelButton == false {
                    loadingSpinner.dismiss()
                }
            }
        }
    }
    
    func renderPassedQuerySearch(query: String, tableView: UITableView, loadingSpinner: JGProgressHUD) {
        GitAPIcaller.shared.makeRequest(returnType: Users.self, requestData: GitRequestRouter.gitSearchUsers(1, query)) { [weak self] (searchedUsers) in
            DispatchQueue.main.async {
                self?.usersModel = searchedUsers.items
                tableView.reloadData()
                tableView.isHidden = false
                loadingSpinner.dismiss()
            }
        }
    }
    
    func fetchMoreUsers (tableView: UITableView, tableViewFooter: UIView, query: String, page: Int) {
        GitAPIcaller.shared.makeRequest(returnType: Users.self, requestData: GitRequestRouter.gitSearchUsers(page, query), pagination: true) { [weak self] (moreUsers) in
            DispatchQueue.main.async {
                if moreUsers.items.isEmpty == false {
                    self?.usersModel.append(contentsOf: moreUsers.items)
                    tableView.reloadData()
                    tableView.tableFooterView = nil
                } else {
                    tableView.tableFooterView = tableViewFooter
                }
            }
        }
    }
    
    func searchInQuery(tableView: UITableView, query: String) {
        GitAPIcaller.shared.makeRequest(returnType: Users.self, requestData: GitRequestRouter.gitSearchUsers(1, query)) { [weak self] (searchedUsers) in
            DispatchQueue.main.async {
                self?.usersModel = searchedUsers.items
                tableView.reloadData()
                tableView.isHidden = false
            }
        }
    }
    
    func recentSearchData (collectionView: UICollectionView, tableView: UITableView) {
            DataBaseManger().Fetch(returnType: LastSearch.self) { [weak self] (result) in
                 self?.lastSearch = result
                 collectionView.reloadData()
            DataBaseManger().Fetch(returnType: SearchHistory.self) { [weak self] (result) in
                 self?.searchHistory = result
                 tableView.reloadData()
            }
        }
        
    }
    
    func excute (tableView: UITableView , collectionView: UICollectionView, label: UILabel) {
        let resetSearchHistory = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.searchHistoryEntity)
        let resetLastSearch = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.lastSearchEntity)
        let resetHistory = NSBatchDeleteRequest(fetchRequest: resetSearchHistory)
        let resetLast = NSBatchDeleteRequest(fetchRequest: resetLastSearch)
        do {
            try context.execute(resetHistory)
            try context.execute(resetLast)
            try context.save()
            DispatchQueue.main.async {
                tableView.reloadData()
                collectionView.reloadData()
                tableView.isHidden = true
                label.isHidden = false
            }
            DataBaseManger().Fetch(returnType: LastSearch.self) { [weak self] (result) in
                self?.lastSearch = result
                collectionView.reloadData()
            }
                DataBaseManger().Fetch(returnType: SearchHistory.self) { [weak self] (result) in
                    self?.searchHistory = result
                    tableView.reloadData()
                }
            } catch {
            //
        }
    }
    
    func saveUserToBookmarks (indexPath: IndexPath) {
        let model = usersModel[indexPath.row]
        let items = UsersDataBase(context: self.context)
        items.userName = model.userName
        items.userAvatar = model.userAvatar
        items.userURL = model.userURL
        try! self.context.save()
    }
    
    func pushWithData (navigationController: UINavigationController) {
        let vc = UIStoryboard.init(name: Storyboards.publicProfileView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.profileViewControllerID) as? PublicUserProfileViewController
        vc?.passedUser = passedUsers
        navigationController.pushViewController(vc!, animated: true)
    }
    

    func showTableViewSpinner (tableView: UITableView) {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
    }
    
    func deleteAndFetchRecentTableData (indexPath:IndexPath) {
        let item = searchHistory[indexPath.row]
        DataBaseManger.shared.Delete(returnType: SearchHistory.self, Delete: item)
        DataBaseManger.shared.Fetch(returnType: SearchHistory.self) { (history) in
            self.searchHistory = history
        }
    }
    
    func saveSearchWord (text: String) {
        let history = SearchHistory(context: self.context)
        history.keyword = text
        try! self.context.save()
    }
    
}
