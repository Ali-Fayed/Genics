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

class ProfileViewController: ProfileSetup {
        
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLogin: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var userBio: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userFollowers: UILabel!
    
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.profileViewTitle
        tabBarItem.title = Titles.profileViewTitle
        tableView.tableFooterView = tableFooterView
        tableView.addSubview(refreshControl)
        view.addSubview(conditionLabel)
        conditionLabel.text = Titles.noToken
        userProfileData(requestData: GitRequestRouter.gitAuthenticatedUser,
                        userName: userName, userAvatar: userAvatar, userFollowData: userFollowers,
                        userBio: userBio, userLoginName: userLogin, userLocation: userLocation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = settingsButton
        loggedInStatus (tableView: tableView)
    }
        
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    @IBAction func didTapSettingsButton(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard.init(name: Storyboards.settingsView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.settingsViewControllerID) as? SettingsViewController
        navigationController?.pushViewController(vc!, animated: true)
    }
        
}

//MARK:-  Profile Table

extension ProfileViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let vc = UIStoryboard.init(name: Storyboards.reposView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.userRepositoryViewControllerID) as? UserRepositoryViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            
        } else if indexPath.row == 1 {
            let vc = UIStoryboard.init(name: Storyboards.starredView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.userStartedViewControllerID) as? UserStarredViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            
        } else if indexPath.row == 2 {
            let vc = UIStoryboard.init(name: Storyboards.orgsView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.orgsViewControllerID) as? OrgsViewController
            vc?.fetchUserOrgs()
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
}
