//
//  ViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 14/01/2021.
//

import UIKit
import SafariServices
import Alamofire

class DoubleView: UIViewController , UITableViewDataSource , UITableViewDelegate , UISearchBarDelegate {

    @IBOutlet weak var Searchbaar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var SearchHistoryView: UIView!
    
    var UsersAPIStruct = [UsersStruct]()
    var bookmarkDataBase = [UsersDataBase]()
    var searchHistory = [SearchHistory]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    var UsersQuery = [items]()
    var User = [UsersStruct]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UsersSearchCell.nib(), forCellReuseIdentifier: UsersSearchCell.identifier)
        Searchbaar.showsCancelButton = true
        navigationItem.hidesBackButton = true
        Searchbaar.delegate = self

        Searchbaar.showsScopeBar = true
        Searchbaar.scopeButtonTitles = ["Users","Repositories"]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        Searchbaar.becomeFirstResponder()
        tableView.isHidden = true
        self.tabBarController?.navigationItem.title = "Search".localized()
    }
    
   
    //MARK:- SearchBar Delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
         self.SearchHistoryView.isHidden = true
         self.tableView.isHidden = false
       }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
  
        print ("Search = \(searchText)")
        guard let text = searchBar.text, !text.isEmpty else { return }
        let query = text.replacingOccurrences(of: " ", with: "%20")
        let url = "https://api.github.com/search/users?q=\(query)"
        SearchFromGithubQuery(url: url)
        UsersQuery.removeAll()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.text = ""
        self.UsersQuery.removeAll()
        self.tableView.reloadData()
        DispatchQueue.main.async {
            self.SearchHistoryView.isHidden = false
            self.tableView.isHidden = true
            self.Searchbaar.resignFirstResponder()
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        savehistory(keyword: text)
 

    }
    

//MARK:- TableView Methods and Delegate
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UsersQuery.count
        
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersSearchCell.identifier, for: indexPath) as! UsersSearchCell
        cell.CellData(with: UsersQuery[indexPath.row])
        return cell
    }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Show movie details
        print(UsersQuery[indexPath.row].html_url)
        let url = UsersQuery[indexPath.row].html_url
        let serverErrorURL = URL(string: "https://github.com")!
        let vc = SFSafariViewController(url: URL(string: url) ?? serverErrorURL)
        present(vc, animated: true)
        let model = UsersQuery[indexPath.row].login
        let model2 = UsersQuery[indexPath.row].avatar_url
        saveNewSearchHistoryWord(login: model, avatar_url: model2)
    }

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    //MARK:- Search Method
    
    func SearchFromGithubQuery (url: String ) {
        AF.request(url, method: .get).responseJSON { (response) in
            guard let safedata = response.data else {
                return
            }
            var result: UsersQResults?

            do {
                result = try JSONDecoder().decode(UsersQResults.self, from: safedata)
               }
            catch {
                let error = error
                print(error.localizedDescription)
            }
            guard let finalResult = result else {
                return
            }
            let newMovies = finalResult.items
            self.UsersQuery.append(contentsOf: newMovies)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func saveNewSearchHistoryWord (login: String , avatar_url: String) {
        let DataParameters = UsersDataBase(context: context)
        DataParameters.login = login
        DataParameters.avatar_url = avatar_url
        do {
            try context.save()
            fetchAllData()
        } catch {
            
        }
    }
    
    func
    fetchAllData () {
        do {
            bookmarkDataBase = try context.fetch(UsersDataBase.fetchRequest())
            searchHistory = try context.fetch(SearchHistory.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()

            }
        } catch {
            //error
        }
    }
    
    func savehistory (keyword: String) {
        let historyData = SearchHistory(context: context)
        historyData.keyword = keyword
        do {
            try context.save()
            fetchAllData ()
        } catch {}
    }
    
    func updateHistory (DataBase: SearchHistory, keyword: String)  {
        DataBase.keyword = keyword
        do {
            try context.save()
            fetchAllData ()
        } catch {
            
        }
    }
    
    
}

