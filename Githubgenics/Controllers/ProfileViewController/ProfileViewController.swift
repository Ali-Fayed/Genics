//
//  ProfileViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController {
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    var userRepository = [Repository]()
    var selectedRepository: Repository?
    var profileTableData = [ProfileTableData]()
    let footer = UIView ()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(Titles.signinWith, for: .normal)
        button.backgroundColor = UIColor(named: "Color")
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.addTarget(self, action: #selector(signInButton),for: .touchUpInside)
        return button
    }()
    
    var isLoggedIn: Bool {
        if TokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isLoggedIn {
            loginButton.isHidden = true
        } else {
            tableView.isHidden = true
            loginButton.isHidden = false
        }
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.RepositoriesViewTitle)", Image: "Repositories" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.BookmarksViewTitle)", Image: "Startted" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.Organizations)", Image: "Organizations"))
        tableView.tableHeaderView = Header
        tableView.tableHeaderView?.backgroundColor = UIColor(named: "ViewsColorBallet")
        tableView.tableFooterView = footer
        renderUserProfile ()
        view.addSubview(loginButton)
        self.tabBarItem.title = Titles.Profile

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = Titles.Profile
        tabBarController?.navigationItem.rightBarButtonItem = settingsButton
    }
    
    override func viewDidLayoutSubviews() {
        loginButton.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 70)
    }
    
    @objc func signInButton () {
        let vc = UIStoryboard.init(name: ID.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: ID.loginViewID) as? LoginViewController
        self.navigationController?.pushViewController(vc!, animated: true)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            performSegue(withIdentifier: Segues.userCellDetailSegue, sender: self)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: Segues.userStarttedSegue, sender: self)
        } else if indexPath.row == 2 {
            performSegue(withIdentifier: Segues.userOrgsSegue, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.sectionIndexColor = UIColor(named: "ViewsColorBallet")
        return UIView()
    }
    
}

//MARK:- Fetch User Profile

extension ProfileViewController {
    
    func renderUserProfile () {
        session.request(GitRouter.gitAuthUser).responseJSON { (response) in
            switch response.result {
            case .success(let responseJSON) :
                let recievedJson = JSON (responseJSON)
                self.userName.text = recievedJson["\(AuthenticatedUserInfo.userName)"].stringValue
                let avatar = recievedJson["\(AuthenticatedUserInfo.userAvatar)"].stringValue
                self.userAvatar.kf.setImage(with: URL(string: avatar), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                self.userAvatar.layer.masksToBounds = false
                self.userAvatar.layer.cornerRadius = self.userAvatar.frame.height/2
                self.userAvatar.clipsToBounds = true
                self.userFollowers.text = recievedJson["\(AuthenticatedUserInfo.userFollowers)"].stringValue
                self.userFollowing.text = recievedJson["\(AuthenticatedUserInfo.userFollowing)"].stringValue
                self.userBio.text = recievedJson["\(AuthenticatedUserInfo.userBio)"].stringValue
                self.userLogin.text = recievedJson["\(AuthenticatedUserInfo.userLoginName)"].stringValue
                self.userLocation.text = recievedJson["\(AuthenticatedUserInfo.userLocation)"].stringValue
            case .failure(let error):
                print(error)
            }
        }
    }
}
