//
//  RVC TableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit
import SafariServices

extension RepositoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicRepositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ReposCell
        cell.CellData(with: publicRepositories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = UIStoryboard.init(name: Storyboards.commits , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.commitsViewControllerID) as? CommitsViewController
        vc?.repository = selectedRepository
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedRepository = publicRepositories[indexPath.row]
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fetch more
        if indexPath.row == publicRepositories.count - 1 {
            showTableViewSpinner()
            let query : String = {
                var queryString = String()
                if let searchText = reposSearchBar.text {
                    queryString = searchText.isEmpty ? "language:Swift" : searchText
                }
                return queryString
            }()
            if pageNo < totalPages {
                pageNo += 1
                fetchMoreRepositories(query: query, page: pageNo)
            }
        }
    }
    func showTableViewSpinner () {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    
    func tableView( _ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(String(describing: index))" as NSString
        return UIContextMenuConfiguration( identifier: identifier, previewProvider: nil) { _ in
            
            let bookmarkAction = UIAction(title: Titles.bookmark, image: UIImage(systemName: "bookmark.fill")) { _ in
                let saveRepoInfo = SavedRepositories(context: self.context)
                let repository = self.publicRepositories[indexPath.row]
                saveRepoInfo.repoName = repository.repositoryName
                saveRepoInfo.repoDescription = repository.repositoryDescription
                saveRepoInfo.repoProgrammingLanguage = repository.repositoryLanguage
                saveRepoInfo.repoUserFullName = repository.repoFullName
                saveRepoInfo.repoStars = Float(repository.repositoryStars ?? 0)
                saveRepoInfo.repoURL = repository.repositoryURL
                try! self.context.save()
            }
            
            let safariAction = UIAction(
                title: Titles.openInSafari,
                image: UIImage(systemName: "link")) { _ in
                let url = self.publicRepositories[indexPath.row].repositoryURL
                let vc = SFSafariViewController(url: URL(string: url)!)
                self.present(vc, animated: true)
            }
            
            let shareAction = UIAction(
                title: Titles.share,
                image: UIImage(systemName: "square.and.arrow.up")) { _ in
                 let image = UIImage(systemName: "bell")
                let url = self.publicRepositories[indexPath.row].repositoryURL
                let sheetVC = UIActivityViewController(activityItems: [image!,url], applicationActivities: nil)
                HapticsManger.shared.selectionVibrate(for: .medium)
                self.present(sheetVC, animated: true)
            }
            
            return UIMenu(title: "", image: nil, children: [safariAction ,bookmarkAction, shareAction])
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
                navigationItem.hidesSearchBarWhenScrolling = true
    }

}
