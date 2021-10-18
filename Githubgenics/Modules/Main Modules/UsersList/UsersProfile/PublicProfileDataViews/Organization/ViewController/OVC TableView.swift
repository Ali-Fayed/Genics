//
//  OVC TableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 09/04/2021.
//

import UIKit

extension PublicOrgsViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfOrgsCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as OrgsTableViewCell
        cell.cellData(with: viewModel.getOrgsViewModel(at: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
