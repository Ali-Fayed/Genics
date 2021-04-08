//
//  UsersRepositoryViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import SafariServices
import JGProgressHUD

class PublicUserRepositoriesViewController: ViewSetups {
    
    @IBOutlet weak var tableView: UITableView!
    
    var repositoryModel = [Repository]()
    var savedRepos = [SavedRepositories]()
    var passedUser : items?
    var repository: Repository?
    var starButton = [Int : Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.repositoriesViewTitle
        tableView.registerCellNib(cellClass: ReposCell.self)
        renderClickedUserPublicRepositories ()
        renderStarState ()
        conditionLabel.text = Titles.searchForRepos
        tableView.tableFooterView = tableFooterView
        tableView.addSubview(refreshControl)
        view.addSubview(conditionLabel)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // frame and layout
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
        
    func renderClickedUserPublicRepositories () {
        guard let user = passedUser else {return}
        if repositoryModel.isEmpty == true {
            loadingSpinner.show(in: view)
        }
        GitAPIcaller.shared.makeRequest(returnType: [Repository].self, requestData: GitRequestRouter.gitPublicUsersRepositories(pageNo, user.userName)) { [weak self] (result) in
            self?.repositoryModel = result
            DispatchQueue.main.async {
                self?.loadingSpinner.dismiss()
                self?.tableView.reloadData()
                if self?.repositoryModel.isEmpty == true {
                    self?.tableView.isHidden = true
                    self?.conditionLabel.isHidden = false
                } else {
                    self?.tableView.isHidden = false
                    self?.conditionLabel.isHidden = true
                }
            }
        }
    }
        
    func fetchMoreRepositories (page: Int) {
        guard let user = passedUser else {return}
        GitAPIcaller.shared.makeRequest(returnType: [Repository].self, requestData: GitRequestRouter.gitPublicUsersRepositories(pageNo, user.userName), pagination: true) { [weak self]  (moreRepos) in
            DispatchQueue.main.async {
                if moreRepos.isEmpty == false {
                    self?.repositoryModel.append(contentsOf: moreRepos)
                    self?.tableView.reloadData()
                    self?.tableView.tableFooterView = nil
                } else {
                    self?.tableView.tableFooterView = self?.tableFooterView
                }
            }
        }
    }
        

    //MARK:- Handle Star Button State
    
    
    // load button state UD
    func renderStarState () {
        if let checks = UserDefaults.standard.value(forKey: passedUser!.userName) as? NSData {
            do {
                try starButton = NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(checks as Data) as! [Int : Bool]
            } catch {
                //
            }
        }
    }
    
    // save button state in UD
    func saveStarState () {
        do {
            try UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: starButton, requiringSecureCoding: true), forKey: passedUser!.userName)
            UserDefaults.standard.synchronize()
        } catch {
            //
        }
    }
    
}

//MARK:- User Repos Table

extension PublicUserRepositoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ReposCell
        cell.CellData(with: repositoryModel[indexPath.row])
        // cell delegatation to make specific actions
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: Storyboards.commitsView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.commitsViewControllerID) as? CommitsViewController
        vc?.viewModel.repository = repository
        vc?.viewModel.fetchReposCommits(view: view, tableView: tableView, loadingSpinner: loadingSpinner)
        self.navigationController?.pushViewController(vc!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fetch more
        if indexPath.row == repositoryModel.count - 1 {
            showTableViewSpinner()
            if pageNo < totalPages {
                pageNo += 1
                fetchMoreRepositories(page: pageNo)
            }
        }
    }
    
    func showTableViewSpinner () {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    
    func tableView( _ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(String(describing: index))" as NSString
        return UIContextMenuConfiguration( identifier: identifier, previewProvider: nil) { _ in
            
            let bookmarkAction = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark.fill")) { _ in
                let saveRepoInfo = SavedRepositories(context: self.context)
                let repository = self.repositoryModel[indexPath.row]
                    saveRepoInfo.repoName = repository.repositoryName
                    saveRepoInfo.repoDescription = repository.repositoryDescription
                    saveRepoInfo.repoProgrammingLanguage = repository.repositoryLanguage
                    saveRepoInfo.repoUserFullName = repository.repoFullName
                    saveRepoInfo.repoStars = Float(repository.repositoryStars ?? 0)
                    saveRepoInfo.repoURL = repository.repositoryURL
                try! self.context.save()
            }
            
            let safariAction = UIAction(
                title: Titles.openInSafari,
                image: UIImage(systemName: "link")) { _ in
                let url = self.repositoryModel[indexPath.row].repositoryURL
                let vc = SFSafariViewController(url: URL(string: url)!)
                self.present(vc, animated: true)
            }
            
            let shareAction = UIAction(
                title: Titles.share,
                image: UIImage(systemName: "square.and.arrow.up")) { _ in
                let url = self.repositoryModel[indexPath.row].repositoryURL
                let sheetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                HapticsManger.shared.selectionVibrate(for: .medium)
                self.present(sheetVC, animated: true)
            }
            
            return UIMenu(title: "", image: nil, children: [safariAction, bookmarkAction, shareAction])
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        repository = repositoryModel[indexPath.row]
        return indexPath
    }
}


extension PublicUserRepositoriesViewController : DetailViewCellDelegate {
    
    func didTapButton(cell: ReposCell, didTappedThe button: UIButton?) {
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
                let repository = self.repositoryModel[indexPath.row]
                let saveRepoInfo = SavedRepositories(context: self.context)
                    saveRepoInfo.repoName = repository.repositoryName
                    saveRepoInfo.repoDescription = repository.repositoryDescription
                    saveRepoInfo.repoProgrammingLanguage = repository.repositoryLanguage
                    saveRepoInfo.repoUserFullName = repository.repoFullName
                    saveRepoInfo.repoStars = Float(repository.repositoryStars ?? 0)
                    saveRepoInfo.repoURL = repository.repositoryURL
            }
        }
        saveStarState()
    }
}
