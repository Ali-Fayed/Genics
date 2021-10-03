//
//  PSVC TableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 09/04/2021.
//

import UIKit

extension PrivateStarredViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfStarredCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ReposTableViewCell
        cell.cellData(with: viewModel.getStarredViewModel(at: indexPath))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.pushToDestinationVC(indexPath: indexPath, navigationController: navigationController!)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        viewModel.starttedRepositories = viewModel.starttedRepos[indexPath.row]
        return indexPath
    }    
}
