//
//  UsersStartedViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import JGProgressHUD
import SafariServices

class PublicUserStarredViewController: ViewSetups {
    
    weak var delegate : DetailViewCellDelegate?
    var starttedRepos = [Repository]()
    var starttedRepositories : Repository?
    var passedUser: items?
    var starButton = [Int : Bool]()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.starredViewTitle
        tableView.registerCellNib(cellClass: ReposCell.self)
        view.addSubview(conditionLabel)
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = tableFooterView
        loadStarred ()
        renderStarState ()
        conditionLabel.text = Titles.noStarred
    }
    
    func loadStarred () {
        guard let repository = passedUser else {return}
        if self.starttedRepos.isEmpty == true {
            loadingSpinner.show(in: view)
        }
        GitAPIcaller.shared.makeRequest(returnType: [Repository].self, requestData: GitRequestRouter.gitPublicUsersStarred(pageNo, repository.userName)) { [weak self] (result) in
            self?.starttedRepos = result
            DispatchQueue.main.async {
                if self?.starttedRepos.isEmpty == true {
                    self?.tableView.isHidden = true
                    self?.conditionLabel.isHidden = false
                    
                } else {
                    self?.tableView.isHidden = false
                    self?.conditionLabel.isHidden = true
                }
                self?.loadingSpinner.dismiss()
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
                    self?.tableView.tableFooterView = self?.tableFooterView
                }
            }
        }
    }

    // frame and layout
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
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

extension PublicUserStarredViewController : UITableViewDataSource , UITableViewDelegate {
    
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
            showTableViewSpinner(tableView: self.tableView)
            if pageNo < totalPages {
                pageNo += 1
                fetchMoreStarredRepos(page: pageNo)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "CommitsView" , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.commitsViewControllerID) as? CommitsViewController
        vc?.viewModel.repository = starttedRepositories
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


extension PublicUserStarredViewController : DetailViewCellDelegate {
    
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
