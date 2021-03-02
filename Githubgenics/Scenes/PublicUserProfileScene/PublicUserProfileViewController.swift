//
//  DetailViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import SkeletonView
import SafariServices

class PublicUserProfileViewController: UIViewController  {
    
    // data models
    var profileTableData = [ProfileTableData]()
    var passedUser : items?
    // userdefaults to cache user settings
    var defaults = UserDefaults.standard
    // persistentContainer context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let footer = UIView()
    // refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    // IBOutlets
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userFollowers: UILabel!
    @IBOutlet weak var userFollowing: UILabel!
    
    // Bookmark button states on and off with state and save to database
    var setBookmarkButtonState: String = "off" {
        willSet {
            if newValue == "on" {
                bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                // save user to database bookmarks view
                let users = UsersDataBase(context: context)
                users.userName = self.passedUser?.userName
                users.userAvatar = self.passedUser?.userAvatar
                users.userURL = self.passedUser?.userURL
                try! self.context.save()
            }
            else {
                bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        }
    }

    //MARK:- LifeCycle Methods
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        // back with gestures
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        //view title
        navigationItem.title = Titles.DetailViewTitle
        // headerView data
        renderUserProfileData ()
        tableView.tableFooterView = footer
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.RepositoriesViewTitle)", Image: "Repositories" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.Startted)", Image: "Startted" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.Organizations)", Image: "Organizations"))
        tableView.addSubview(refreshControl)
        tableView.rowHeight = 60
        renderFollwingAndFollowers ()
    }
           
    //MARK:- UI Methods
    
    // passed user from users list data
    func renderUserProfileData () {
        userName.text = "\((passedUser?.userName.capitalized)!)"
        guard let passedUser = passedUser else {
            return
        }
        let avatar = passedUser.userAvatar
        userAvatar.kf.indicatorType = .activity
        userAvatar.kf.setImage(with: URL(string: avatar), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        userAvatar.layer.masksToBounds = false
        userAvatar.layer.cornerRadius = userAvatar.frame.height/2
        userAvatar.clipsToBounds = true
    }
        
    // change button value between on or off
    @IBAction func bookmarkButton(_ sender: UIButton) {
        let stat = setBookmarkButtonState == "on" ? "off" : "on"
        setBookmarkButtonState = stat
        guard let passedUser = passedUser else {
            return
        }
        defaults.set(stat, forKey: (passedUser.userName))
        HapticsManger.shared.selectionVibrate(for: .medium)
    }
    
    // laod button state
    func renderTheButtonWithSavedState () {
        guard let passedUser = passedUser else {
            return
        }
        if let ButtonState = defaults.string(forKey: (passedUser.userName))
        {
            setBookmarkButtonState = ButtonState
        }
        else {
            setBookmarkButtonState = "off"
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    
    func renderFollwingAndFollowers () {
        // may contain error in real numbers because of API
        guard let user = passedUser else {return}
        GitAPIManger().APIcall(returnType: items.self, requestData: GitRouter.fetchPublicUserFollowing(user.userName), pagination: false) { [weak self] (result) in
            self?.userFollowing.text = String(result.count)
        }
        GitAPIManger().APIcall(returnType: items.self, requestData: GitRouter.fetchPublicUserFollowers(user.userName), pagination: false) { [weak self] (result) in
            self?.userFollowers.text = String(result.count)
        }
    }
}


//MARK:- tableView

extension PublicUserProfileViewController: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = profileTableData[indexPath.row].cellHeader
        cell.imageView?.image = UIImage(named: profileTableData[indexPath.row].Image)
        cell.imageView?.layer.cornerRadius = 10
        cell.imageView?.clipsToBounds = true
        return cell
    }
        

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let vc = UIStoryboard.init(name: Storyboards.usersRepos , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.usersRepositoryViewControllerID) as? UsersRepositoryViewController
            vc?.passedUser = passedUser
            self.navigationController?.pushViewController(vc!, animated: true)
            
        } else if indexPath.row == 1 {
            let vc = UIStoryboard.init(name: Storyboards.usersStartted , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.usersStartedViewControllerID) as? UsersStartedViewController
            vc?.passedUser = passedUser
            self.navigationController?.pushViewController(vc!, animated: true)
            
        } else if indexPath.row == 2 {
            let vc = UIStoryboard.init(name: Storyboards.usersOrgs , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.usersOrgsViewControllerID) as? UsersOrgsViewController
            vc?.passedUser = passedUser
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}
