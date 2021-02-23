//
//  RepositoriesViewMethods.swift
//  Githubgenics
//
//  Created by Ali Fayed on 11/02/2021.
//

import UIKit
import SafariServices

extension RepositoriesViewController {
    
    //MARK:- Fetch Methods
    
    func searchRepositories (query: String) {
        loadingIndicator.stopAnimating()
        GitAPIManger().searchPublicRepositories(query: query) { [weak self] repositories in
            self?.publicRepositories = repositories
            self?.loadingIndicator.stopAnimating()
            self?.tableView.reloadData()
        }
    }
    
    //MARK:- UI Methods
    
    func renderAndDisplayBestSwiftRepositories() {
      loadingIndicator.startAnimating()
        GitAPIManger().fetchPopularSwiftRepositories { [weak self] repositories in
        self?.publicRepositories = repositories
        self?.loadingIndicator.stopAnimating()
        self?.tableView.reloadData()
      }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    
    //MARK:- Searchbar
    
    func renderSearchBar() {
        reposSearchBar.searchBarStyle = UISearchBar.Style.prominent
        reposSearchBar.placeholder = Titles.searchPlacholder
        reposSearchBar.sizeToFit()
        reposSearchBar.isTranslucent = false
        reposSearchBar.delegate = self
        repoSearchBarHeader.searchBarStyle = UISearchBar.Style.prominent
        repoSearchBarHeader.placeholder = Titles.searchPlacholder
        repoSearchBarHeader.sizeToFit()
        repoSearchBarHeader.isTranslucent = false
        repoSearchBarHeader.delegate = self
    }
    
    // MARK: - Handling Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.commitViewSegue {
            guard let commitsViewController = segue.destination as? CommitsViewController else {
                return
            }
            commitsViewController.repository = selectedRepository
        }
    }
    
    
    //MARK:- Handle Long Press
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        // haptic when long pressed
        HapticsManger.shared.selectionVibrate(for: .medium)
        let touchPoint = longPress.location(in: tableView)
        if let index = tableView.indexPathForRow(at: touchPoint) {
            let repository = self.publicRepositories[index.row]
            let sheet = UIAlertController(title: Titles.more, message: nil , preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: Titles.bookmark, style: .default, handler: { (url) in
                // save repos
                let saveRepoInfo = SavedRepositories(context: self.context)
                    saveRepoInfo.repoName = repository.repositoryName
                    saveRepoInfo.repoDescription = repository.repositoryDescription
                    saveRepoInfo.repoProgrammingLanguage = repository.repositoryLanguage
                    saveRepoInfo.repoUserFullName = repository.repoFullName
                    saveRepoInfo.repoStars = Float(repository.repositoryStars ?? 0)
                    saveRepoInfo.repoURL = repository.repositoryURL
            }))
            // open url
            sheet.addAction(UIAlertAction(title: Titles.url , style: .default, handler: { (url) in
                let cell = self.publicRepositories[index.row].repositoryURL
                let vc = SFSafariViewController(url: URL(string: cell)!)
                self.present(vc, animated: true)
            }))
            // cancel
            sheet.addAction(UIAlertAction(title: Titles.cancel , style: .cancel, handler: nil ))
            present(sheet, animated: true)
        }
    }
}
