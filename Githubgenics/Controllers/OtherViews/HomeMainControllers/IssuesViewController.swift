//
//  IssuesViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 16/03/2021.
//

import UIKit
import JGProgressHUD

class IssuesViewController: ViewSetups {
    
  
    var issuesData = [Issue]()
    var query: String = "a"
    
    @IBOutlet weak var tableView: UITableView!
    var searchController = UISearchController(searchResultsController: nil)


    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = tableFooterView
        conditionLabel.text = Titles.searchIssues
        view.addSubview(conditionLabel)
        if searchController.searchBar.text?.isEmpty == true {
            searchController.searchBar.delegate = self
            setupSearchController(search: searchController)
            self.navigationItem.searchController = searchController
            searchIssues ()
            title = Titles.issuesViewTitle
        } else {
            navigationController?.navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.prefersLargeTitles = false
            title = Titles.resultsViewTitle
            loadingSpinner.show(in: view)
            GitAPIcaller.shared.makeRequest(returnType: Issues.self, requestData: GitRequestRouter.gitSearchIssues(1, query), pagination: false) { [weak self] (result) in
                self?.issuesData = result.items
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.loadingSpinner.dismiss()
                }
            }
            
        }
    }
    
    
    // layout and framing
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            if self.searchController.searchBar.text?.isEmpty == false {
                self.searchController.searchBar.becomeFirstResponder()
            }
        }
    }
    
    func searchIssues () {
            loadingSpinner.show(in: view)
        GitAPIcaller.shared.makeRequest(returnType: Issues.self, requestData: GitRequestRouter.gitSearchIssues(1, "a"), pagination: false) { [weak self] (result) in
            self?.issuesData = result.items
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.loadingSpinner.dismiss()
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    

}

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fetch more
        
        if indexPath.row == issuesData.count - 1 {
            showTableViewSpinner()
            let query : String = {
                var queryString = String()
                if let searchText = searchController.searchBar.text {
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
                    self?.tableView.tableFooterView = self?.tableFooterView
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
            self.conditionLabel.alpha = 1.0
        })
        
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.conditionLabel.isHidden = false
            self.searchController.searchBar.becomeFirstResponder()
            self.pageNo = 1
        }
    }
    
    // Fetch Methods
    func searchRepositories (query: String, page: Int) {
        if issuesData.isEmpty {
            loadingSpinner.show(in: view)
        }
        GitAPIcaller.shared.makeRequest(returnType: Issues.self, requestData: GitRequestRouter.gitSearchIssues(page, query)) { [weak self] (repositories) in
            self?.issuesData = repositories.items
            self?.loadingSpinner.dismiss()
            self?.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let query = searchBar.text else {
            return
        }
        searchRepositories(query: query, page: pageNo)
        self.tableView.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.alpha = 1.0
            self.conditionLabel.isHidden = true
            if searchBar.text?.isEmpty == true {
                self.tableView.alpha = 0.0
                self.loadingSpinner.dismiss()
            }
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.conditionLabel.alpha = 0.0
        })
        
        DispatchQueue.main.async {
            self.searchController.searchBar.resignFirstResponder()
            self.searchController.searchBar.text = nil
            self.conditionLabel.isHidden = true
            self.tableView.isHidden = false


        }
    }

}
