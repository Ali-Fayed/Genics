//
//  BVC TableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit
import SafariServices
import CoreData

extension BookmarksViewController: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.numberOfUsersCells
        default:
            return viewModel.numberOfReposCells
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeue() as UsersTableViewCell
            cell.cellData(with: viewModel.getUsersViewModel(at: indexPath))
            if viewModel.bookmarkedUsers.isEmpty == true {
                
            }
            return cell
        default:
            let cell = tableView.dequeue() as ReposTableViewCell
            cell.cellData(with: viewModel.getReposViewModel(at: indexPath))
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            router?.trigger(.userSafariURL(indexPath: indexPath))
        default:
            viewModel.pushToDestnationVC(indexPath: indexPath, view: view, tableView: self.tableView, loadingSpinner: loadingSpinner)
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch indexPath.section {
        case 0:
            break
        default:
            viewModel.passedRepo = viewModel.getReposViewModel(at: indexPath)
        }
        return indexPath
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerText = UILabel()
        switch section {
        case 0:
            if viewModel.bookmarkedUsers.isEmpty == false {
                headerText.text = Titles.usersViewTitle
            } else {
                headerText.text = nil
            }
        default:
            if viewModel.savedRepositories.isEmpty == false {
                headerText.text = Titles.repositoriesViewTitle
            } else {
                headerText.text = nil
            }
        }
        return headerText.text
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            switch indexPath.section {
            case 0:
                viewModel.deleteAndFetchUsers(at: indexPath, tableView: self.tableView, conditionLabel: conditionLabel)
            default:
                viewModel.deleteAndFetchRepos(at: indexPath, tableView: self.tableView, conditionLabel: conditionLabel)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    func tableView( _ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(String(describing: index))" as NSString
        return UIContextMenuConfiguration( identifier: identifier, previewProvider: nil) { _ in
            switch indexPath.section {
            case 0:
                let safariAction = UIAction(
                    title: Titles.urlTitle,
                    image: UIImage(systemName: "link")) { _ in
                        self.openUserInSafari(indexPath: indexPath)
                    }
                let shareAction = UIAction(
                    title: Titles.share,
                    image: UIImage(systemName: "square.and.arrow.up")) { _ in
                        self.shareUser(indexPath: indexPath)
                    }
                return UIMenu(title: "", image: nil, children: [safariAction, shareAction])
            default:
                let safariAction = UIAction(
                    title: Titles.urlTitle,
                    image: UIImage(systemName: "link")) { _ in
                        self.openRepoInSafari(indexPath: indexPath)
                    }
                let shareAction = UIAction(
                    title: Titles.share,
                    image: UIImage(systemName: "square.and.arrow.up")) { _ in
                        self.shareRepo(indexPath: indexPath)
                    }
                return UIMenu(title: "", image: nil, children: [safariAction, shareAction])
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        default:
            return 100
        }
    }
    // MARK: - Actions
    func openUserInSafari (indexPath: IndexPath) {
        router?.trigger(.userSafariURL(indexPath: indexPath))
    }
    func shareUser (indexPath: IndexPath) {
        router?.trigger(.shareUser(indexPath: indexPath))
    }
    func openRepoInSafari (indexPath: IndexPath) {
        router?.trigger(.repoSafariURL(indexPath: indexPath))
    }
    func shareRepo (indexPath: IndexPath) {
        router?.trigger(.shareRepo(indexPath: indexPath))
    }
}
