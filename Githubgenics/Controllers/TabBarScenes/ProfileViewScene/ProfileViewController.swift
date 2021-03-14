//
//  ProfileViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import AuthenticationServices

class ProfileViewController: UIViewController {
    
    // data model
    var userRepository = [Repository]()
    var selectedRepository: Repository?
    var profileTableData = [ProfileTableData]()
    let footer = UIView ()
    // spinner
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    // button if not signed in
    let noTokenLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = Titles.noTokenLabel
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    //  refresh control
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    // check for token
    var isLoggedIn: Bool {
        if GitTokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    
     // IBOutlets
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLogin: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var userBio: UILabel!
    @IBOutlet weak var Header: UIView!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userFollowers: UILabel!
    @IBOutlet weak var userFollowing: UILabel!

    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.profileViewTitle
        tabBarItem.title = Titles.profileViewTitle
        tableView.addSubview(refreshControl)
        tableView.tableHeaderView = Header
        tableView.tableHeaderView?.backgroundColor = UIColor(named: "ViewsColorBallet")
        tableView.tableFooterView = footer
        tableView.rowHeight = 60
        renderUserProfile ()
        view.addSubview(noTokenLabel)
        tableView.addSubview(refreshControl)
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.repositoriesViewTitle)", Image: "Repositories" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.Starred)", Image: "Startted" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.Organizations)", Image: "Organizations"))
        if isLoggedIn {
            noTokenLabel.isHidden = true
        } else {
            tableView.isHidden = true
            noTokenLabel.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = Titles.profileViewTitle
        tabBarController?.navigationItem.rightBarButtonItem = settingsButton
        if isLoggedIn {
            noTokenLabel.isHidden = true
        } else {
            tableView.isHidden = true
            noTokenLabel.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        noTokenLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    
    @IBAction func didTapSettingsButton(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard.init(name: Storyboards.settings , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.settingsViewControllerID) as? SettingsViewController
        navigationController?.pushViewController(vc!, animated: true)
    }
    
}

//MARK:-  Profile Table

extension ProfileViewController : UITableViewDataSource , UITableViewDelegate {
    
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
            let vc = UIStoryboard.init(name: Storyboards.userRepos , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.userRepositoryViewControllerID) as? UserRepositoryViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            
        } else if indexPath.row == 1 {
            let vc = UIStoryboard.init(name: Storyboards.userStartted , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.userStartedViewControllerID) as? UserStarredViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            
        } else if indexPath.row == 2 {
            let vc = UIStoryboard.init(name: Storyboards.userOrgs , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.userOrgsViewControllerID) as? UserOrgsViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    
}

//MARK:- Fetch User Profile

extension ProfileViewController {
    
    func renderUserProfile () {
        session.request(GitRequsetRouter.gitAuthenticatedUser).responseJSON { (response) in
            switch response.result {
            case .success(let responseJSON) :
                let recievedJson = JSON (responseJSON)
                self.userName.text = recievedJson["\(User.userName)"].stringValue
                let avatar = recievedJson["\(User.userAvatar)"].stringValue
                self.userAvatar.kf.setImage(with: URL(string: avatar), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                self.userAvatar.layer.masksToBounds = false
                self.userAvatar.layer.cornerRadius = self.userAvatar.frame.height/2
                self.userAvatar.clipsToBounds = true
                self.userFollowers.text = recievedJson["\(User.userFollowers)"].stringValue
                self.userFollowing.text = recievedJson["\(User.userFollowing)"].stringValue
                self.userBio.text = recievedJson["\(User.userBio)"].stringValue
                self.userLogin.text = recievedJson["\(User.userLoginName)"].stringValue
                self.userLocation.text = recievedJson["\(User.userLocation)"].stringValue
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK:- Profile Model

struct ProfileTableData {
    let cellHeader: String
    let Image: String
}
