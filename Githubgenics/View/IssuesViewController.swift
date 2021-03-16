//
//  IssuesViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 16/03/2021.
//

import UIKit
import JGProgressHUD

class IssuesViewController: UIViewController {
    var pageNo : Int = 1
    var totalPages : Int = 100
    // two search bar for animating (check search bar page)
    lazy var reposSearchBar:UISearchBar = UISearchBar()
    var issuesData = [Issue]()
    let spinner = JGProgressHUD(style: .dark)
     let footer = UIView()
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    let searchLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = Titles.searchForRepos
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = footer
        fetchOrgs ()
        view.addSubview(searchLabel)
        search.searchBar.delegate = self
        search.searchBar.sizeToFit()
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = true
        self.definesPresentationContext = true
        search.searchBar.placeholder = Titles.searchPlacholder
        self.navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.addSubview(refreshControl)
    }
    private var search = UISearchController(searchResultsController: nil)
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }

    func fetchOrgs () {
            spinner.show(in: view)
        GitAPIcaller.shared.makeRequest(returnType: Issues.self, requestData: GitRequestRouter.gitSearchIssues(1, "a"), pagination: false) { [weak self] (result) in
            self?.issuesData = result.items
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.spinner.dismiss()
            }
        }
    }
    
    // layout and framing
    override func viewDidLayoutSubviews() {
        searchLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }

}

//MARK:- User Orgs Table

extension IssuesViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issuesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = issuesData[indexPath.row].issueTitle
        cell.detailTextLabel?.text = issuesData[indexPath.row].issueState
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fetch more
        if indexPath.row == issuesData.count - 1 {
            showTableViewSpinner()
            let query : String = {
                var queryString = String()
                if let searchText = reposSearchBar.text {
                    queryString = searchText.isEmpty ? "a" : searchText
                }
                return queryString
            }()
            if pageNo < totalPages {
                pageNo += 1
            fetchMoreUsers(query: query, page: pageNo)
            }
        }
    }
    
    // fetch more users
    func fetchMoreUsers (query: String, page: Int) {
        GitAPIcaller.shared.makeRequest(returnType: Issues.self, requestData: GitRequestRouter.gitSearchIssues(page, query), pagination: true) { [weak self] (moreUsers) in
            DispatchQueue.main.async {
                if moreUsers.items.isEmpty == false {
                    self?.issuesData.append(contentsOf: moreUsers.items)
                    self?.tableView.reloadData()
                    self?.tableView.tableFooterView = nil
                } else {
                    self?.tableView.tableFooterView = self?.footer
                }
            }
        }
    }
    
    // show spinner
    func showTableViewSpinner () {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
}

extension IssuesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 0.0
            self.searchLabel.alpha = 1.0
        })
        
        DispatchQueue.main.async {
            self.reposSearchBar.text = nil
            self.searchLabel.isHidden = false
            self.reposSearchBar.becomeFirstResponder()
            self.pageNo = 1
        }
    }
    
    // Fetch Methods
    func searchRepositories (query: String, page: Int) {
        if issuesData.isEmpty {
            spinner.show(in: view)
        }
        GitAPIcaller.shared.makeRequest(returnType: Issues.self, requestData: GitRequestRouter.gitSearchIssues(page, query)) { [weak self] (repositories) in
            self?.issuesData = repositories.items
            self?.spinner.dismiss()
            self?.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let query = searchBar.text else {
            return
        }
        searchRepositories(query: query, page: pageNo)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.isHidden = true
            if searchBar.text?.isEmpty == true {
                self.tableView.alpha = 0.0
                self.spinner.dismiss()
            }
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.alpha = 0.0
        })
        
        DispatchQueue.main.async {
            self.reposSearchBar.resignFirstResponder()
            self.reposSearchBar.text = nil
            self.searchLabel.isHidden = true

        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
                navigationItem.hidesSearchBarWhenScrolling = true
    }
}
