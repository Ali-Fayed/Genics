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
            self?.repositories = repositories
            self?.loadingIndicator.stopAnimating()
            self?.tableView.reloadData()
        }
    }
    
    //MARK:- UI Methods
    

    func renderAndDisplayBestSwiftRepositories() {
      loadingIndicator.startAnimating()
        GitAPIManger().fetchPopularSwiftRepositories { [weak self] repositories in
        self?.repositories = repositories
        self?.loadingIndicator.stopAnimating()
        self?.tableView.reloadData()
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
    
    //MARK:- Handle Star Button State
    
    func renderStarState () {
        let cell = ReposCell()
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        if let checks = UserDefaults.standard.value(forKey: repositories[indexPath.row].repositoryName) as? NSData {
            do {
                try starButton = NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(checks as Data) as! [Int : Bool]
            } catch {
                //
            }
        }
    }
    func saveStarState () {
        let cell = ReposCell()
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        do {
            try  UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: starButton, requiringSecureCoding: true), forKey: repositories[indexPath.row].repositoryName)
            UserDefaults.standard.synchronize()
        } catch {
            //
        }
    }
    
    //MARK:- Handle Long Press
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        HapticsManger.shared.selectionVibrate(for: .medium)
        let touchPoint = longPress.location(in: tableView)
        if let index = tableView.indexPathForRow(at: touchPoint) {
            let repository = self.repositories[index.row]
            let sheet = UIAlertController(title: Titles.more, message: nil , preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: Titles.bookmark, style: .default, handler: { (url) in
                let saveRepoInfo = SavedRepositories(context: self.context)
                    saveRepoInfo.repoName = repository.repositoryName
                    saveRepoInfo.repoDescription = repository.repositoryDescription
                    saveRepoInfo.repoProgrammingLanguage = repository.repositoryLanguage
                    saveRepoInfo.repoUserFullName = repository.repoFullName
                    saveRepoInfo.repoStars = Float(repository.repositoryStars ?? 0)
                    saveRepoInfo.repoURL = repository.repositoryURL
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }))
            sheet.addAction(UIAlertAction(title: Titles.url , style: .default, handler: { (url) in
                let cell = self.repositories[index.row].repositoryURL
                let vc = SFSafariViewController(url: URL(string: cell)!)
                self.present(vc, animated: true)
            }))
            sheet.addAction(UIAlertAction(title: Titles.cancel , style: .cancel, handler: nil ))
            present(sheet, animated: true)
        }
    }
}
