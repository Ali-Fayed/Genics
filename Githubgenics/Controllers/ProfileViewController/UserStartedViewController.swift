//
//  UserStartedSegue.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit

class UserStartedViewController: UIViewController {
    
    // data model
    var starttedRepos = [Repository]()
    var starttedRepositories : Repository?
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    let footer = UIView ()

    // IBOutlets
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // load started
        loadingIndicator.startAnimating()
        GitAPIManger().APIcall(returnType: Repository.self, requestData: GitRouter.gitStartedReposUser, pagination: false) { [weak self] (started) in
            self?.starttedRepos = started
            self?.loadingIndicator.stopAnimating()
            self?.tableView.reloadData()
        }
        // title
        title = Titles.Startted
        // footer
        tableView.tableFooterView = footer
        // gesture back
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // handle segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.commitViewSegue {
            guard let commitsViewController = segue.destination as? CommitsViewController else {
                return
            }
            commitsViewController.repository = starttedRepositories
        }
    }
}

//MARK:- User Started Table

extension UserStartedViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return starttedRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = starttedRepos[indexPath.row].repositoryName
        cell.detailTextLabel?.text = starttedRepos[indexPath.row].repositoryDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segues.commitViewSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        starttedRepositories = starttedRepos[indexPath.row]
        return indexPath
    }
    
}
