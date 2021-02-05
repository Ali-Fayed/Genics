//
//  RepositoriesFunctions.swift
//  Githubgenics
//
//  Created by Ali Fayed on 01/02/2021.
//

import Foundation


extension RepositoriesListViewController {
    
    func fetchAndDisplayPopularSwiftRepositories() {
        loadingIndicator.startAnimating()
        
        RepostoriesRouter().fetchPopularSwiftRepositories { result in
            switch result {
            case .success(let repositories):
                self.fetchedRepositories.append(contentsOf: repositories)
                self.loadingIndicator.stopAnimating()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.shimmerLoadingView ()
                }
            case .failure(_):
                break
            }
            
        }
    }
    func shimmerLoadingView () {
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        tableView.skeletonCornerRadius = 5
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }
    }
    
    
    func fetchSearchedRepositories (for query: String) {
        loadingIndicator.startAnimating()
        RepostoriesRouter().searchRepositories(query: query) { result in
            switch result {
            case .success(let users):
                self.fetchedRepositories.append(contentsOf: users)
                self.loadingIndicator.stopAnimating()
                self.tableView.reloadData()
            case .failure(_):
                let error = Error.self
                print(error)
            }
        }
    }
}
