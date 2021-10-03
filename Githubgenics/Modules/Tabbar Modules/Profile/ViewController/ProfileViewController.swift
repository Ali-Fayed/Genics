//
//  ProfileViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit

class ProfileViewController: ViewSetups {
        
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLogin: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var userBio: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userFollowers: UILabel!
        
    lazy var viewModel: ProfileViewModel = {
       return ProfileViewModel()
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = settingsButton
        viewModel.loggedInStatus(tableView: tableView, conditionLabel: conditionLabel)
    }
        
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    func initView () {
        title = Titles.profileViewTitle
        tabBarItem.title = Titles.profileViewTitle
        tableView.tableFooterView = tableFooterView
        tableView.addSubview(refreshControl)
        view.addSubview(conditionLabel)
        conditionLabel.text = Titles.noToken
    }
    
    func initViewModel () {
        viewModel.userProfileData(requestData: GitRequestRouter.gitAuthenticatedUser,
                        userName: userName, userAvatar: userAvatar, userFollowData: userFollowers,
                        userBio: userBio, userLoginName: userLogin, userLocation: userLocation)
    }
    
    @IBAction func didTapSettingsButton(_ sender: UIBarButtonItem) {
        let settingsVC = UIStoryboard.init(name: Storyboards.settingsView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.settingsViewControllerID) as? SettingsViewController
        navigationController?.pushViewController(settingsVC!, animated: true)
    }
}
