//
//  File.swift
//  Githubgenics
//
//  Created by Ali Fayed on 09/04/2021.
//

import UIKit
import SafariServices

extension PublicStarredViewController : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfStarredCells
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ReposTableViewCell
        cell.cellData(with: viewModel.getStarredViewModel(at: indexPath))
        cell.delegate = self
        cell.buttonAccessory()
        // handle starbutton
        if starButton[indexPath.row] != nil {
            cell.accessoryView?.tintColor = starButton[indexPath.row]! ? .red : .lightGray
        } else {
            starButton[indexPath.row] = false
            cell.accessoryView?.tintColor = .lightGray
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        showTableViewSpinner(tableView: tableView)
        viewModel.fetchMoreStarredRepos(at: indexPath, tableView: tableView, tableFooterView: tableFooterView, loadingSpinner: loadingSpinner)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.pushToDestnationVC(indexPath: indexPath, navigationController: navigationController!)
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        viewModel.starttedRepositories = viewModel.starttedRepos[indexPath.row]
        return indexPath
    }
}
//MARK:- Cell Delegate
extension PublicStarredViewController : DetailViewCellDelegate {
    
    func didTapButton(cell: ReposTableViewCell, didTappedThe button: UIButton?) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryView?.tintColor == .red {
                cell.accessoryView?.tintColor = .lightGray
                starButton[indexPath.row] = false
            }
            else{
                // handle starbutton and save repos to database
                HapticsManger.shared.selectionVibrate(for: .medium)
                cell.accessoryView?.tintColor = .red
                starButton[indexPath.row] = true
                viewModel.saveRepoToBookmarks(at: indexPath)
            }
        }
        saveStarState()
    }
    
}
