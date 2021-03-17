//
//  UsersRepositoryViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import SafariServices
import JGProgressHUD

class UsersRepositoryViewController: UIViewController {
    
    // data models
    var userRepository = [Repository]()
    var savedRepos = [SavedRepositories]()
    var passedUser : items?
    var selectedRepository: Repository?
    var pageNo : Int = 1
    var totalPages : Int = 100
    // userdefaults to cache user settings
    var defaults = UserDefaults.standard
    var starButton = [Int : Bool]()
    // persistentContainer context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //

    var profileTableData = [ProfileTableData]()
    let footer = UIView()
    let spinner = JGProgressHUD(style: .dark)
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    let noOrgsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = Titles.noRepos
        label.textAlignment = .center
        label.textColor = UIColor(named: "color")
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.repositoriesViewTitle
        tableView.registerCellNib(cellClass: ReposCell.self)
        tableView.rowHeight = 60
        // fetch user repos
        renderClickedUserPublicRepositories ()
        tableView.tableFooterView = footer
        // gestures
        renderStarState ()
        tableView.addSubview(refreshControl)
        view.addSubview(noOrgsLabel)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    func renderClickedUserPublicRepositories () {
        guard let user = passedUser else {return}
        if userRepository.isEmpty == true {
            spinner.show(in: view)
        }
        GitAPIcaller.shared.makeRequest(returnType: [Repository].self, requestData: GitRequestRouter.gitPublicUsersRepositories(pageNo, user.userName)) { [weak self] (result) in
            self?.userRepository = result
            DispatchQueue.main.async {
                self?.spinner.dismiss()
                self?.tableView.reloadData()
                if self?.userRepository.isEmpty == true {
                    self?.tableView.isHidden = true
                    self?.noOrgsLabel.isHidden = false
                } else {
                    self?.tableView.isHidden = false
                    self?.noOrgsLabel.isHidden = true
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func fetchMoreRepositories (page: Int) {
        guard let user = passedUser else {return}
        GitAPIcaller.shared.makeRequest(returnType: [Repository].self, requestData: GitRequestRouter.gitPublicUsersRepositories(pageNo, user.userName), pagination: true) { [weak self]  (moreRepos) in
            DispatchQueue.main.async {
                if moreRepos.isEmpty == false {
                    self?.userRepository.append(contentsOf: moreRepos)
                    self?.tableView.reloadData()
                    self?.tableView.tableFooterView = nil
                } else {
                    self?.tableView.tableFooterView = self?.footer
                }
            }
        }
    }
    
    // frame and layout
    override func viewDidLayoutSubviews() {
        noOrgsLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
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

extension UsersRepositoryViewController: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRepository.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ReposCell
        cell.CellData(with: userRepository[indexPath.row])
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
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: Storyboards.commits , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.commitsViewControllerID) as? CommitsViewController
        vc?.repository = selectedRepository
        self.navigationController?.pushViewController(vc!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fetch more
        if indexPath.row == userRepository.count - 1 {
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
                let repository = self.userRepository[indexPath.row]
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
                let url = self.userRepository[indexPath.row].repositoryURL
                let vc = SFSafariViewController(url: URL(string: url)!)
                self.present(vc, animated: true)
            }
            
            let shareAction = UIAction(
                title: Titles.share,
                image: UIImage(systemName: "square.and.arrow.up")) { _ in
                let url = self.userRepository[indexPath.row].repositoryURL
                let sheetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                HapticsManger.shared.selectionVibrate(for: .medium)
                self.present(sheetVC, animated: true)
            }
            
            return UIMenu(title: "", image: nil, children: [safariAction, bookmarkAction, shareAction])
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedRepository = userRepository[indexPath.row]
        return indexPath
    }
}


extension UsersRepositoryViewController : DetailViewCellDelegate {
    
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
                let repository = self.userRepository[indexPath.row]
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
