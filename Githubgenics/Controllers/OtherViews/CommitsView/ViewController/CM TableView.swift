//
//  CM TableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 08/04/2021.
//

import UIKit
import SafariServices

extension CommitsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCommitCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as CommitsCell
        cell.CellData(with: viewModel.getCommitViewModel(at: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       showTableViewSpinner(tableView: tableView)
        viewModel.fetchMoreCommits(indexPath: indexPath, footerView: tableFooterView, tableView: tableView, loadingSpinner: loadingSpinner, page: pageNo)
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = viewModel.getCommitViewModel(at: indexPath).html_url
        let vc = SFSafariViewController(url: URL(string: url)!)
        self.present(vc, animated: true)
    }
}
