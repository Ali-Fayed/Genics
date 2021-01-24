//
//  RepositoriesListViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/01/2021.
//

import UIKit
import Alamofire
import SafariServices



class RepositoriesListViewController: UITableViewController  {
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 30, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    var repositories: [Repository] = []
    var selectedRepository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ReposCell.nib(), forCellReuseIdentifier: "repocell")
        fetchAndDisplayPopularSwiftRepositories()
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
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


