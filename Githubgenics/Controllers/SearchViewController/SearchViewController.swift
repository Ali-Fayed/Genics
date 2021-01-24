//
//  ViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 14/01/2021.
//

import UIKit
import SafariServices
import Alamofire

class SearchViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var LastSearc = [LastSearch]()
    var searchHistory = [SearchHistory]()
    var UsersQuery = [items]()
    
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
        

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.isHidden = true
            
//            if self.Searchbaar.text == nil {
//                self.tableView.isHidden = true
//                Searchbaar.becomeFirstResponder()
//            } else {
//                self.tableView.isHidden = false
//
//            }
        
        self.tabBarController?.navigationItem.title = "Search".localized()
    }
    

    //MARK:- CRUD Methods
    
    func saveSearchKeywords (keyword: String) {
        let historyData = SearchHistory(context: context)
        historyData.keyword = keyword
        do {
            try context.save()
            fetchAllData ()
        } catch {}
    }
    
    func saveLastTouchedSearch (login: String , avatar_url: String , html_url: String) {
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
            LastSearc = try context.fetch(LastSearch.fetchRequest())
            searchHistory = try context.fetch(SearchHistory.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()

            }
        } catch {
            //error
        }
    }
    
}


//MARK:- TableView DataSource and Delegate
    

extension SearchViewController : UITableViewDataSource , UITableViewDelegate  {
    
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
       
       let url = UsersQuery[indexPath.row].html_url
       let serverErrorURL = URL(string: "https://github.com")!
       let vc = SFSafariViewController(url: URL(string: url) ?? serverErrorURL)
       present(vc, animated: true)
        
       
       let model = UsersQuery[indexPath.row].login
       let model2 = UsersQuery[indexPath.row].avatar_url
       let model3 = UsersQuery[indexPath.row].html_url
       saveLastTouchedSearch(login: model, avatar_url: model2, html_url: model3)
   }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 60
   }
    
}


 //MARK:- UISearchBar Delegate

extension SearchViewController  : UISearchBarDelegate  {

     func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
         DispatchQueue.main.async {
          self.SearchHistoryView.isHidden = true
          self.tableView.isHidden = false
        }
     }
     
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
   
         print ("Search = \(searchText)")
        if searchText != nil {
            tableView.isHidden = false
        }
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
         saveSearchKeywords(keyword: text)
  

     }
     
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
    

}

