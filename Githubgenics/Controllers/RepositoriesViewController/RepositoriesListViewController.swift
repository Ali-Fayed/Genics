//
//  RepositoriesListViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/01/2021.
//

import UIKit
import Alamofire
import SafariServices
import CoreData



class RepositoriesListViewController: UITableViewController  {
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 30, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    var repositories: [Repository] = []
    var selectedRepository: Repository?
    var savedrepo = [SavedRepositories]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
            savedrepo = try context.fetch(SavedRepositories.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()

            }
        } catch {
            //error
        }
    }
    
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
    
    
    func fetchAndDisplayPopularSwiftRepositories() {
      loadingIndicator.startAnimating()
        GithubRouter.shared.fetchPopularSwiftRepositories { repositories in
        self.repositories = repositories
        self.loadingIndicator.stopAnimating()
        self.tableView.reloadData()
      }
    }
    

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repocell", for: indexPath) as? ReposCell
        cell?.CellData(with: repositories[indexPath.row])
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 120
   }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = repositories[indexPath.row].html_url
        let serverErrorURL = URL(string: "https://github.com")!
        let vc = SFSafariViewController(url: URL(string: url!) ?? serverErrorURL)
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
            let index1 = repositories[indexPath.row].name
            let index2 = repositories[indexPath.row].description
            let index3 = repositories[indexPath.row].language
            let index4 = repositories[indexPath.row].stargazers_count
            let index5 = repositories[indexPath.row].html_url

            saveLastTouchedSearch(name: index1, desc: index2!, language: index3!, stars: index4!, url: index5!)
        }
        action.image = #imageLiteral(resourceName: "like")
        action.backgroundColor = .gray
        return action
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      selectedRepository = repositories[indexPath.row]
      return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "CommitSegue" {
        guard let commitsViewController = segue.destination as? CommitsViewController else {
          return
        }
        commitsViewController.selectedRepository = selectedRepository
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
        GithubRouter.shared.searchRepositories(query: query) { repositories in
          self.repositories = repositories
          self.loadingIndicator.stopAnimating()
          self.tableView.reloadData()
        }
    }
    
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

  }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      searchBar.text = nil
      searchBar.resignFirstResponder()
        fetchAndDisplayPopularSwiftRepositories()
      }
    }


