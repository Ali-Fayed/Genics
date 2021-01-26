//
//  RepositoriesListViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/01/2021.
//

import UIKit
import SafariServices
import CoreData



class RepositoriesListViewController: UITableViewController  {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    var fetchedRepositories: [Repository] = []
    var savedRepositories = [SavedRepositories]()

    //MARK:- View LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ReposCell.nib(), forCellReuseIdentifier: "repocell")
        fetchAndDisplayPopularSwiftRepositories()
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        tableView.rowHeight = 120
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = "Repositories".localized()
    }
    

    
  
    // MARK: - TableView DataSource


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedRepositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repocell", for: indexPath) as? ReposCell
        cell?.CellData(with: fetchedRepositories[indexPath.row])
        return cell!
    }
    
    
    //MARK:- TableView Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 120
   }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = fetchedRepositories[indexPath.row].html_url
        let vc = SFSafariViewController(url: URL(string: url)!)
        DispatchQueue.main.async {
            tableView.isHidden = false
        }
        present(vc, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let important = importantAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [important])
    }
    
    func importantAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Bookmark") { [self] (action, view, completion) in
            let index1 = fetchedRepositories[indexPath.row].name
            let index2 = fetchedRepositories[indexPath.row].description
            let index3 = fetchedRepositories[indexPath.row].language
            let index4 = fetchedRepositories[indexPath.row].stargazers_count
            let index5 = fetchedRepositories[indexPath.row].html_url

            saveLastTouchedSearch(name: index1, desc: index2, language: index3, stars: index4, url: index5)
        }
        action.image = #imageLiteral(resourceName: "like")
        action.backgroundColor = .gray
        return action
    }
    
    
    //MARK:- DataBase Methods
   
   func saveLastTouchedSearch (name: String , desc: String , language: String , stars: Int , url : String) {
       let DataParameters = SavedRepositories(context: context)
       DataParameters.name = name as NSObject
       DataParameters.descriptin = desc as NSObject
       DataParameters.language = language as NSObject
       DataParameters.stars = stars as NSObject
       DataParameters.url = url as NSObject

       do {
           try context.save()
           fetchAllData ()
       } catch {
           
       }
   }
   func fetchAllData () {
       do {
           savedRepositories = try context.fetch(SavedRepositories.fetchRequest())
           DispatchQueue.main.async {
               self.tableView.reloadData()
           }
       } catch {
           //error
       }
   }


}

// MARK: - UISearchBarDelegate


extension RepositoriesListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text else {
          return
        }
        loadingIndicator.startAnimating()
        NetworkingManger.shared.searchRepositories(query: query) { repositories in
          self.fetchedRepositories = repositories
          self.loadingIndicator.stopAnimating()
          self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      searchBar.text = nil
      searchBar.resignFirstResponder()
        fetchAndDisplayPopularSwiftRepositories()
        loadingIndicator.stopAnimating()
      }
    
    func fetchAndDisplayPopularSwiftRepositories() {
      loadingIndicator.startAnimating()
        NetworkingManger.shared.fetchPopularSwiftRepositories { repositories in
        self.fetchedRepositories = repositories
        self.loadingIndicator.stopAnimating()
        self.tableView.reloadData()
      }
    }
    }


