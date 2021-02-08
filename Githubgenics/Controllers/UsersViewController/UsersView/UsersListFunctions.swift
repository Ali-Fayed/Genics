//
//  Calls.swift
//  Githubgenics
//
//  Created by Ali Fayed on 01/02/2021.
//

import UIKit
import SafariServices


extension UsersListViewController {
    
    func fetchUsersList  ()  {
        let querySetup : String = {
              var query : String = "a"
            if searchBar.text == nil {
                query = searchBar.text ?? ""
            } else {
                searchBar.text = "a"
            }
            return query
        }()
        guard !isPaginating else {
            return
        }
        GitAPIManager().fetchUsers(query: querySetup, page: pageNo, pagination: false ) { [weak self] result in
            switch result {
            case .success(let moreUsers):
                self?.users.append(contentsOf: moreUsers)
                DispatchQueue.main.async {
                    self!.tableView.reloadData()
                    if self!.searchBar.showsCancelButton == false {
                        self?.shimmerLoadingView()
                    }
                }
            case .failure(_):
                AlertsModel.shared.showPaginationErrorAlert()
                break
            }
        }
    }
    
    func fetchMoreUsers () {
        if  pageNo < totalPages {
            pageNo += 1
            guard !isPaginating else {
                return
            }
            let querySetup : String = {
                  var query : String = "a"
                if searchBar.text == nil {
                    query = searchBar.text!
                } else {
                    searchBar.text = query
                }
                return query
            }()
            GitAPIManager.shared.fetchUsers(query: querySetup, page: pageNo, pagination: true ) { [weak self] result in
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                }
                switch result {
                case .success(let moreUsers):
                    self?.users.append(contentsOf: moreUsers)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(_):
                    AlertsModel.shared.showPaginationErrorAlert()
                    break
                }
            }
        }
    }
    
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        let touchPoint = longPress.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            let cell = users[indexPath.row].userURL
            let vc = SFSafariViewController(url: URL(string: cell!)!)
            present(vc, animated: true)
            
        }
        
    }
    func refreshList () {
        GitAPIManager.shared.fetchUsers(query: "a", page: pageNo) { [weak self] result in
            switch result {
            case .success(let users):
                self!.users.append(contentsOf: users)
                DispatchQueue.main.async {
                    self!.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
    
    func shimmerLoadingView () {
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        tableView.skeletonCornerRadius = 5
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }
    }
    
    
    func SignOutError () {
        let alert = UIAlertController(title: "Error Sign Out", message: "check your internet", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default) { (action) in
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func performSignOut () {
        TokenManager.shared.clearAccessToken()
        UserDefaults.standard.removeObject(forKey: "outh")
    }
    
//    func fetchUsersData () {
//        UsersRouter().fetchUserstoAvoidIndexError { [weak self] result in
//            switch result {
//            case .success(let users):
//                self!.users.append(contentsOf: users)
//                DispatchQueue.main.async {
//                    self!.tableView.reloadData()
//                }
//            case .failure(_):
//                break
//            }
//            
//        }
//    }
    
    func viewSearchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        listSearchBar.searchBarStyle = UISearchBar.Style.prominent
        listSearchBar.placeholder = " Search..."
        listSearchBar.sizeToFit()
        listSearchBar.isTranslucent = false
        listSearchBar.delegate = self
    }
    
    
    func searchUser (query: String) {
        UsersRouter().fetchUsers(query: query, page: pageNo) { [self] users in
            switch users {
            case .success(let moreUsers):
                self.users.append(contentsOf: moreUsers)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(_):
                AlertsModel.shared.showPaginationErrorAlert()
                break
            }
        }
    }
}
