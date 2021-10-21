//
//  ReposListCoordinator.swift
//  Githubgenics
//
//  Created by Ali Fayed on 18/10/2021.
//

import Foundation
import XCoordinator
import SafariServices
enum ReposListRoute: Route {
    case reposList
    case searchRepos(searchText: String)
    case commits(selectedRepository: Repository)
    case repoURL(repoURL: String)
    case shareRepo(repoURL: String)
    case dismiss
}
class ReposListCoordinaotr: NavigationCoordinator<ReposListRoute> {
    init(searchText: String) {
        let viewController = RepositoriesViewController.instaintiate(on: .reposView)
        if viewController.navigationController?.navigationBar.prefersLargeTitles == true {
            super.init(initialRoute: .reposList)
        } else {
            super.init(initialRoute: .searchRepos(searchText: searchText))
        }
    }
    override func prepareTransition(for route: ReposListRoute) -> NavigationTransition {
        switch route {
        case .reposList:
            let viewController = RepositoriesViewController.instaintiate(on: .reposView)
            viewController.viewModel.router = unownedRouter
            return .push(viewController)
        case .searchRepos(let searchText):
            let viewController = RepositoriesViewController.instaintiate(on: .reposView)
            viewController.viewModel.router = unownedRouter
            viewController.searchController.searchBar.text = searchText
            viewController.query = searchText
            return .push(viewController)
        case .commits(let selectedRepository):
            let commitsView = CommitsViewController.instaintiate(on: .commitsView)
            commitsView.viewModel.repository = selectedRepository
            return .push(commitsView)
        case .repoURL(let repoURL):
            let safariVC = SFSafariViewController(url: URL(string: repoURL)!)
            return .present(safariVC)
        case .shareRepo(let repoURL):
            let image = UIImage(systemName: "bell")
           let sheetVC = UIActivityViewController(activityItems: [image!,repoURL], applicationActivities: nil)
           HapticsManger.shared.selectionVibrate(for: .medium)
            return .present(sheetVC)
        case .dismiss:
            return .dismiss()
        }
    }
}
