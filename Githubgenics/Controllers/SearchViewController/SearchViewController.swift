//
//  ViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 14/01/2021.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    var lastSearch = [LastSearch]()
    var searchHistory = [SearchHistory]()
    var searchedUsers : [items] = []
    var passedKeys: SearchHistory?
    
    @IBOutlet weak var Searchbaar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var SearchHistoryView: UIView!
    
    
    //MARK:- View LifeCycle Methods
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UsersSearchCell.nib(), forCellReuseIdentifier: UsersSearchCell.identifier)
        Searchbaar.showsCancelButton = true
        navigationItem.hidesBackButton = true
        Searchbaar.delegate = self
        Searchbaar.placeholder = "Search".localized()
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        fetchAndDisplaySearchViewUsers()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.isHidden = true
        self.tabBarController?.navigationItem.title = "Search".localized()
        if tableView.isHidden == true {
            loadingIndicator.stopAnimating()
        }
        Searchbaar.text = passedKeys?.keyword
    }
    
    func fetchAndDisplaySearchViewUsers() {
            self.loadingIndicator.startAnimating()
        NetworkingManger.shared.fetchUserstoAvoidIndexError { repositories in
            self.searchedUsers = repositories
                self.loadingIndicator.stopAnimating()
                self.tableView.reloadData()
            
        }
    }
    
    //MARK:- DataBase Methods
    
    func saveSearchKeywords (keyword: String) {
            let historyData = SearchHistory(context: self.context)
            historyData.keyword = keyword
            do {
                try self.context.save()
                self.fetchAllData ()
            }
            catch {}
          }
    
    func saveLastTouchedUserSearch (login: String , avatar_url: String , html_url: String) {
        let DataParameters = LastSearch(context: context)
        DataParameters.login = login
        DataParameters.avatar_url = avatar_url
        DataParameters.html_url = html_url
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func fetchAllData () {
        do {
            lastSearch = try context.fetch(LastSearch.fetchRequest())
            searchHistory = try context.fetch(SearchHistory.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
    
}

//MARK:- TableView DataSource


extension SearchViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedUsers.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersSearchCell.identifier, for: indexPath) as! UsersSearchCell
        cell.CellData(with: searchedUsers[indexPath.row])
        return cell
    }
    
}

//MARK:- TableView Delegate

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = searchedUsers[indexPath.row].html_url
        let serverErrorURL = URL(string: "https://github.com")!
        let vc = SFSafariViewController(url: URL(string: url!) ?? serverErrorURL)
        present(vc, animated: true)
        let model = searchedUsers[indexPath.row].login
        let model2 = searchedUsers[indexPath.row].avatar_url
        let model3 = searchedUsers[indexPath.row].html_url
        saveLastTouchedUserSearch(login: model!, avatar_url: model2!, html_url: model3!)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}


//MARK:- UISearchBar Delegate

extension SearchViewController  : UISearchBarDelegate  {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text else {
            return
        }
        self.loadingIndicator.startAnimating()
        NetworkingManger.shared.searchUsers(query: query) { (response) in
            self.searchedUsers = response
            self.loadingIndicator.stopAnimating()
            self.tableView.reloadData()
        }
//        searchedUsers.removeAll()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.SearchHistoryView.isHidden = true
            self.tableView.isHidden = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.text = ""
        self.searchedUsers.removeAll()
        self.tableView.reloadData()
        DispatchQueue.main.async {
            self.SearchHistoryView.isHidden = false
            self.tableView.isHidden = true
            self.Searchbaar.resignFirstResponder()
            self.loadingIndicator.stopAnimating()
        }
        let tv : RecentSearchViewController = self.children[0] as! RecentSearchViewController
        tv.tableView.reloadData()
        tv.viewWillAppear(true)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        saveSearchKeywords(keyword: text)
    }
    
}

