//
//  ExploreViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/03/2021.
//

import UIKit

class ExploreViewController: ViewSetups {

    var bestRepos = [Repository]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Explore"
        tableView.addSubview(refreshControl)
    }
}
