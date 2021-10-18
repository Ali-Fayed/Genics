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
        return viewModel.numberOfReposCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ReposTableViewCell
        cell.cellData(with: viewModel.getReposViewModel(at: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.pushWithData(navigationController: navigationController!)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        viewModel.selectedRepository = viewModel.getReposViewModel(at: indexPath)
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        showTableViewSpinner(tableView: tableView)
        viewModel.fetchMoreCells(tableView: tableView, loadingSpinner: loadingSpinner, indexPath: indexPath, searchController: searchController)
    }
    
    func tableView( _ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(String(describing: index))" as NSString
        return UIContextMenuConfiguration( identifier: identifier, previewProvider: nil) { [weak self] _ in
            
            let bookmarkAction = UIAction(title: Titles.bookmark, image: UIImage(systemName: "bookmark.fill")) { _ in
                self?.viewModel.saveRepos(indexPath: indexPath)
            }
            
            let safariAction = UIAction(
                title: Titles.openInSafari,
                image: UIImage(systemName: "link")) { _ in
                self?.pushURLpage(indexPath: indexPath)
            }
            
            let shareAction = UIAction(
                title: Titles.share,
                image: UIImage(systemName: "square.and.arrow.up")) { _ in
                self?.shareRepo(indexPath: indexPath)
            }
            
            return UIMenu(title: "", image: nil, children: [safariAction ,bookmarkAction, shareAction])
        }
    }
    
    //MARK:- Actions
    
    func pushURLpage(indexPath: IndexPath)  {
        viewModel.router?.trigger(.repoURL(indexPath: indexPath))
    }
    
    func shareRepo(indexPath: IndexPath) {
        viewModel.router?.trigger(.shareRepo(indexPath: indexPath))
    }
    
}
