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
    case repoURL(indexPath: IndexPath)
    case commits(selectedRepository: Repository)
    case shareRepo(indexPath: IndexPath)
    case dismiss
}
class ReposListCoordinaotr: NavigationCoordinator<ReposListRoute> {
    init() {
        super.init(initialRoute: .reposList)
    }
    override func prepareTransition(for route: ReposListRoute) -> NavigationTransition {
        switch route {
        case .reposList:
            let viewController = RepositoriesViewController.instaintiate(on: .reposView)
            viewController.viewModel.router = unownedRouter
            return .push(viewController)
        case .commits(let selectedRepository):
            let commitsView = CommitsViewController.instaintiate(on: .commitsView)
            commitsView.viewModel.repository = selectedRepository
            return .push(commitsView)
        case .repoURL(let indexPath):
            let viewController = RepositoriesViewController.instaintiate(on: .reposView)
            let repositoryURL = viewController.viewModel.getReposViewModel(at: indexPath).repositoryURL
            let safariVC = SFSafariViewController(url: URL(string: repositoryURL)!)
            return .present(safariVC)
        case .shareRepo(let indexPath):
            let viewController = RepositoriesViewController.instaintiate(on: .reposView)
            let image = UIImage(systemName: "bell")
            let repositoryURL = viewController.viewModel.getReposViewModel(at: indexPath).repositoryURL
           let sheetVC = UIActivityViewController(activityItems: [image!,repositoryURL], applicationActivities: nil)
           HapticsManger.shared.selectionVibrate(for: .medium)
            return .present(sheetVC)
        case .dismiss:
            return .dismiss()
        }
    }
}
