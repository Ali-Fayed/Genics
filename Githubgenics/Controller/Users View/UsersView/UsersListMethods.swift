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
        GitUsersRouter().fetchUsers(query: querySetup, page: pageNo, pagination: false ) { [weak self] result in
            self?.users = result
            DispatchQueue.main.async {
                self!.tableView.reloadData()
                if self!.searchBar.showsCancelButton == false {
                    self!.shimmerLoadingView()
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
                    query = searchBar.text!
                } else {
                    searchBar.text = query
                }
                return query
            }()
            GitUsersRouter().fetchUsers(query: querySetup, page: pageNo, pagination: true ) { [weak self] result in
                self?.users.append(contentsOf: result)
                DispatchQueue.main.async {
                    self!.tableView.tableFooterView = nil
                    self!.tableView.reloadData()
                }
            }
        }
    }
    
    func searchUser (query: String) {
        GitUsersRouter().fetchUsers(query: query, page: pageNo) { [weak self] users in
            self?.users = users
            DispatchQueue.main.async {
                self!.tableView.reloadData()
            }
        }
    }
    
    //MARK:- UI Methods
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        let touchPoint = longPress.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            let cell = users[indexPath.row].userURL
            let vc = SFSafariViewController(url: URL(string: cell)!)
            present(vc, animated: true)
        }
    }
    
    func refreshList () {
        GitUsersRouter().fetchUsers(query: "a", page: pageNo) { [weak self] result in
            self?.users = result
            DispatchQueue.main.async {
                self!.tableView.reloadData()
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
    
    func showTableViewSpinner () {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    
    func renderSearchBar() {
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
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshList ()
    }
    
    @IBAction func refreshTable(_ sender: UIRefreshControl?) {
        sender?.endRefreshing()
        refreshList ()
    }
    
    //MARK:- Handle Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            guard let commitsViewController = segue.destination as? DetailViewController else {
                return
            }
            commitsViewController.passedUser = passedusers
        }
    }
}
