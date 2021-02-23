//
//  CommitsViewTable.swift
//  Githubgenics
//
//  Created by Ali Fayed on 02/02/2021.
//

import UIKit

extension CommitsViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return commits.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Cells.commitCell, for: indexPath)
    let commit = commits[indexPath.row]
    cell.textLabel?.text = commit.authorName
    cell.detailTextLabel?.text = commit.message
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
  }
}
