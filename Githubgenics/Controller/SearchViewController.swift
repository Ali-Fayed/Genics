//
//  ViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 14/01/2021.
//

import UIKit
import SafariServices
import Alamofire

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var SearchField: UITextField!
    let searchBar = UISearchBar()
    @IBOutlet weak var Searchbaar: UISearchBar!
    

    var UsersQuery = [items]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UsersSearchCell.nib(), forCellReuseIdentifier: UsersSearchCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
//        searchbar ()
        Searchbaar.delegate = self
    }

    // Field
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Searchbaar.becomeFirstResponder()
    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//            UsersQuery.removeAll()
//            guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
//                return
//            }
//
//            if Date().timeIntervalSince(previousRun) > minInterval {
//                previousRun = Date()
//                fetchResults(for: textToSearch)
//            }
//        }
//
//        func fetchResults(for text: String) {
//            print("Text Searched: \(text)")
//
//        }
//
////        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
////            searchResults.removeAll()
////        }
//    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        let query = text.replacingOccurrences(of: " ", with: "%20")
        let url = "https://api.github.com/search/users?q=\(query)"
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
        UsersQuery.removeAll()
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async {
//            self.Searchbaar.resignFirstResponder()
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            performSegue(withIdentifier: "SearchBar", sender: self)
        }
    }
    func SearchUsers() {
        SearchField.resignFirstResponder()
        UsersQuery.removeAll()
        FetchQuery ()
    }

    // Table

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
        let url = UsersQuery[indexPath.row].html_url
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
    func FetchQuery () {
        guard let text = SearchField.text, !text.isEmpty else {
            return
        }
        let query = text.replacingOccurrences(of: " ", with: "$0")
        let url = "https://api.github.com/search/users?q=\(query)"
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

struct UsersQResults: Codable {
    let items: [items]
}

struct items: Codable {
    let login: String
    let avatar_url: String
    let html_url: String


    private enum CodingKeys: String, CodingKey {
        case login, avatar_url, html_url
    }
}

