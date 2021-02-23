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
    
    // fetch users in list
    func renderUsersList  ()  {
        //check for pagination bool
        guard !isPaginating else {
            return
        }
        GitAPIManger().fetchUsers(query: "a", page: pageNo, pagination: false ) { [weak self] users in
            guard ((self?.usersModel = users) != nil) else {
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

    // fetch more users
    func fetchMoreUsers () {
        // next page every call
        if  pageNo < totalPages {
            pageNo += 1
            // check for pagination bool
            guard !isPaginating else {
                return
            }
            // pagination when search and without in same view
            let querySetup : String = {
                var query : String = "a"
                if searchBar.text == nil {
                    query = searchBar.text ?? ""
                } 
                return query
            }()
            // pagination and view next page
            GitAPIManger().fetchUsers(query: querySetup, page: pageNo, pagination: true ) { [weak self] result in
                guard ((self?.usersModel.append(contentsOf: result)) != nil) else {
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
    
    // search for user
    func searchUser (query: String) {
        GitAPIManger().fetchUsers(query: query, page: 1) { [weak self] users in
            guard ((self?.usersModel = users) != nil) else {
                return
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    
    //MARK:- Handle Long Press
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        // haptic feedback to attract the user he is long pressed the screen
        HapticsManger.shared.selectionVibrate(for: .medium)
        let touchPoint = longPress.location(in: tableView)
        if let index = tableView.indexPathForRow(at: touchPoint) {
            // alert sheet for more options
            let sheet = UIAlertController(title: Titles.more, message: nil , preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: Titles.bookmark, style: .default, handler: { [weak self] (handler) in
                if let index = self?.tableView.indexPathForRow(at: touchPoint) {
                    // save user to database bookmarks view
                    guard let usersIndex = self?.usersModel[index.row] else {
                        return
                    }
                    let items = UsersDataBase(context: self!.context)
                    items.userName = usersIndex.userName
                    items.userAvatar = usersIndex.userAvatar
                    items.userURL = usersIndex.userURL
                    try! self?.context.save()
                }
            }))
            // open user url
            sheet.addAction(UIAlertAction(title: Titles.url , style: .default, handler: { [weak self] (url) in
                guard let url = self?.usersModel[index.row].userURL else {
                    return
                }
                let vc = SFSafariViewController(url: URL(string: url)!)
                self?.present(vc, animated: true)
            }))
            // cancel sheet
            sheet.addAction(UIAlertAction(title: Titles.cancel , style: .cancel, handler: nil ))
            present(sheet, animated: true)
        }
    }
    
    //MARK:- Handle Refresh
        
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    
    //MARK:- UI Methods
    
    func skeletonViewLoader () {
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        tableView.skeletonCornerRadius = 5
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
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
        usersListViewSearchBar.searchBarStyle = UISearchBar.Style.prominent
        usersListViewSearchBar.placeholder = Titles.searchPlacholder
        usersListViewSearchBar.sizeToFit()
        usersListViewSearchBar.isTranslucent = false
        usersListViewSearchBar.delegate = self
    }
    
    //MARK:- Handle Segue
    
    // segue to commits view with passed data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.detailViewSegue {
            guard let commitsViewController = segue.destination as? DetailViewController else {
                return
            }
            commitsViewController.passedUser = passedUsers
        }
    }
}

