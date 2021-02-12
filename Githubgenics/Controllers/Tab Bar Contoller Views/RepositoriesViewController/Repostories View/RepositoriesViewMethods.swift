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
        GitReposRouter().searchPublicRepositories(query: query) { [self] repositories in
            self.repositories = repositories
            loadingIndicator.stopAnimating()
            tableView.reloadData()
        }
    }
    
    //MARK:- UI Methods
    
    func renderAndDisplayUserRepositories() {
        loadingIndicator.startAnimating()
        GitUsersRouter().fetchAuthorizedUserRepositories { [self] repositories in
            self.repositories = repositories
            loadingIndicator.stopAnimating()
            tableView.reloadData()
        }
    }
    
    func renderSearchBar() {
        listSearchBar.searchBarStyle = UISearchBar.Style.prominent
        listSearchBar.placeholder = Titles.searchPlacholder
        listSearchBar.sizeToFit()
        listSearchBar.isTranslucent = false
        listSearchBar.delegate = self
        listSearchBar2.searchBarStyle = UISearchBar.Style.prominent
        listSearchBar2.placeholder = Titles.searchPlacholder
        listSearchBar2.sizeToFit()
        listSearchBar2.isTranslucent = false
        listSearchBar2.delegate = self
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
        HapticsManger.shared.selectionVibrate(for: .medium)
        let touchPoint = longPress.location(in: tableView)
        if let index = tableView.indexPathForRow(at: touchPoint) {
            let repository = self.repositories[index.row]
            let sheet = UIAlertController(title: "More".localized(), message: nil , preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "Bookmark".localized(), style: .default, handler: { (url) in
                Save().repository(repoName: repository.repositoryName, repoDescription: repository.repositoryDescription ?? "", repoProgrammingLanguage: repository.repositoryLanguage ?? "", repoURL: repository.repositoryURL, repoUserFullName: repository.repoFullName, repoStars: Float((repository.repositoryStars!)))
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }))
            sheet.addAction(UIAlertAction(title: "URL", style: .default, handler: { (url) in
                let cell = self.repositories[index.row].repositoryURL
                let vc = SFSafariViewController(url: URL(string: cell)!)
                self.present(vc, animated: true)
            }))
            sheet.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil ))
            present(sheet, animated: true)
        }
    }
}
