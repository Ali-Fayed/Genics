//
//  UserCellDetailsController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit

class UserRepositoryViewController: UIViewController {
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView

    @IBOutlet weak var tableView: UITableView!
    var repositories : Repository?
    var repository = [Repository]()
    let footer = UIView ()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.RepositoriesViewTitle
        tableView.registerCellNib(cellClass: ReposCell.self)
        loadingIndicator.startAnimating()
        GitAPIManger().APIcall(returnType: Repository.self, requestData: GitRouter.fetchAuthorizedUserRepositories, pagination: false) { [weak self] (repos) in
            self?.repository = repos
            self?.loadingIndicator.stopAnimating()
            self?.tableView.reloadData()
        }
        tableView.tableFooterView = footer
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.commitViewSegue {
            guard let commitsViewController = segue.destination as? CommitsViewController else {
                return
            }
            commitsViewController.repository = repositories
        }
    }

}


extension UserRepositoryViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repository.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ReposCell
        cell.CellData(with: repository[indexPath.row])
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
        repositories = repository[indexPath.row]
        return indexPath
    }
    
}
