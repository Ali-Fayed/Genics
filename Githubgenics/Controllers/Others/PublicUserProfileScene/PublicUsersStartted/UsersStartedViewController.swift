//
//  UsersStartedViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import JGProgressHUD
import SafariServices

class UsersStartedViewController: UIViewController {
    
    // data model
    var starttedRepos = [Repository]()
    var starttedRepositories : Repository?
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    let footer = UIView ()
    let spinner = JGProgressHUD(style: .dark)
    var passedUser: items?
    var pageNo : Int = 1
    var totalPages : Int = 100
    var defaults = UserDefaults.standard
    var starButton = [Int : Bool]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    weak var delegate : DetailViewCellDelegate?

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
        label.text = Titles.noStartted
        label.textAlignment = .center
        label.textColor = UIColor(named: "color")
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.Starred
        // load started
        renderStarState ()
        tableView.registerCellNib(cellClass: ReposCell.self)
        loadStarred ()
        view.addSubview(noOrgsLabel)
        tableView.addSubview(refreshControl)
        // footer
        tableView.tableFooterView = footer
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func loadStarred () {
        guard let repository = passedUser else {return}
        if self.starttedRepos.isEmpty == true {
            spinner.show(in: view)
        }
        GitAPIcaller.shared.makeRequest(returnType: [Repository].self, requestData: GitRequestRouter.gitPublicUsersStarred(pageNo, repository.userName)) { [weak self] (result) in
            self?.starttedRepos = result
            DispatchQueue.main.async {
                if self?.starttedRepos.isEmpty == true {
                    self?.tableView.isHidden = true
                    self?.noOrgsLabel.isHidden = false
                    
                } else {
                    self?.tableView.isHidden = false
                    self?.noOrgsLabel.isHidden = true
                }
                self?.spinner.dismiss()
                self?.tableView.reloadData()
            }
        }
    }
    
    func fetchMoreStarredRepos (page: Int) {
        guard let user = passedUser else {return}
        GitAPIcaller.shared.makeRequest(returnType: [Repository].self, requestData: GitRequestRouter.gitPublicUsersStarred(pageNo, user.userName), pagination: true) { [weak self]  (moreStarredRepos) in
            DispatchQueue.main.async {
                if moreStarredRepos.isEmpty == false {
                    self?.starttedRepos.append(contentsOf: moreStarredRepos)
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
        if let checks = UserDefaults.standard.value(forKey: passedUser!.userURL) as? NSData {
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
            try UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: starButton, requiringSecureCoding: true), forKey: passedUser!.userURL)
            UserDefaults.standard.synchronize()
        } catch {
            //
        }
    }
    
}

//MARK:- User Started Table

extension UsersStartedViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return starttedRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ReposCell
        cell.CellData(with:  starttedRepos[indexPath.row])
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
        // fetch more
        if indexPath.row == starttedRepos.count - 1 {
            showTableViewSpinner()
            if pageNo < totalPages {
                pageNo += 1
                fetchMoreStarredRepos(page: pageNo)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "CommitsView" , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.commitsViewControllerID) as? CommitsViewController
        vc?.repository = starttedRepositories
        self.navigationController?.pushViewController(vc!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        starttedRepositories = starttedRepos[indexPath.row]
        return indexPath
    }
    
    func tableView( _ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(String(describing: index))" as NSString
        return UIContextMenuConfiguration( identifier: identifier, previewProvider: nil) { _ in
            
            let bookmarkAction = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark.fill")) { _ in
                let saveRepoInfo = SavedRepositories(context: self.context)
                let repository = self.starttedRepos[indexPath.row]
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
                let url = self.starttedRepos[indexPath.row].repositoryURL
                let vc = SFSafariViewController(url: URL(string: url)!)
                self.present(vc, animated: true)
            }
            
            let shareAction = UIAction(
                title: Titles.share,
                image: UIImage(systemName: "square.and.arrow.up")) { _ in
                let url = self.starttedRepos[indexPath.row].repositoryURL
                let sheetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                HapticsManger.shared.selectionVibrate(for: .medium)
                self.present(sheetVC, animated: true)
            }
            
            return UIMenu(title: "", image: nil, children: [safariAction, bookmarkAction, shareAction])
        }
    }
    
}


extension UsersStartedViewController : DetailViewCellDelegate {
    
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
                let repository = self.starttedRepos[indexPath.row]
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
