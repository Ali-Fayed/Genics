//
//  Calls.swift
//  Githubgenics
//
//  Created by Ali Fayed on 01/02/2021.
//

import UIKit
import SafariServices


extension UsersListViewController {
    
    //MARK:- Fetch Methods
    
    func renderUsersList  ()  {
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
        GitUsersRouter().fetchUsers(query: querySetup, page: pageNo, pagination: false ) { [weak self] users in
            guard ((self?.users = users) != nil) else {
                return
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                if self?.searchBar.showsCancelButton == false {
                    self?.skeletonViewLoader()
                }
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
                    query = searchBar.text ?? ""
                } 
                return query
            }()
            GitUsersRouter().fetchUsers(query: querySetup, page: pageNo, pagination: true ) { [weak self] result in
                guard ((self?.users.append(contentsOf: result)) != nil) else {
                    return
                }
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                    self?.tableView.reloadData()
                    HapticsManger.shared.selectionVibrate(for: .light)
                }
            }
        }
    }
    
    func searchUser (query: String) {
        GitUsersRouter().fetchUsers(query: query, page: 1) { [weak self] users in
            guard ((self?.users = users) != nil) else {
                return
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    //MARK:- Handle Long Press
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        HapticsManger.shared.selectionVibrate(for: .medium)
        let touchPoint = longPress.location(in: tableView)
        if let index = tableView.indexPathForRow(at: touchPoint) {
            let sheet = UIAlertController(title: Titles.more, message: nil , preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: Titles.bookmark, style: .default, handler: { [weak self] (handler) in
                if let index = self?.tableView.indexPathForRow(at: touchPoint) {
                    guard let usersIndex = self?.users[index.row] else {
                        return
                    }
                    Save().user(userName: usersIndex.userName, userAvatar: usersIndex.userAvatar, userURL: usersIndex.userURL )
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }))
            sheet.addAction(UIAlertAction(title: Titles.url , style: .default, handler: { [weak self] (url) in
                guard let url = self?.users[index.row].userURL else {
                    return
                }
                let vc = SFSafariViewController(url: URL(string: url)!)
                self?.present(vc, animated: true)
            }))
            sheet.addAction(UIAlertAction(title: Titles.cancel , style: .cancel, handler: nil ))
            present(sheet, animated: true)
        }
    }
    
    //MARK:- Handle Refresh
    
    func refreshList () {
        let querySetup : String = {
            var query : String = "a"
            if searchBar.text == nil {
                query = searchBar.text ?? ""
            }
            return query
        }()
        GitUsersRouter().fetchUsers(query: querySetup, page: pageNo) { [weak self] result in
            guard ((self?.users = result) != nil) else {
                return
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        refreshList ()
        refreshControl.endRefreshing()
    }
    
    //MARK:- UI Methods
    
    func skeletonViewLoader () {
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        tableView.skeletonCornerRadius = 5
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }
    }
    
    func showTableViewSpinner () {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    
    func renderSearchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = Titles.searchPlacholder
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        listSearchBar.searchBarStyle = UISearchBar.Style.prominent
        listSearchBar.placeholder = Titles.searchPlacholder
        listSearchBar.sizeToFit()
        listSearchBar.isTranslucent = false
        listSearchBar.delegate = self
    }
    
    //MARK:- Handle Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.detailViewSegue {
            guard let commitsViewController = segue.destination as? DetailViewController else {
                return
            }
            commitsViewController.passedUser = passedUsers
        }
    }
}

