//
//  ProfileViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import XCoordinator

class ProfileViewController: CommonViews {
    //MARK: - @IBOutlets
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLogin: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var userBio: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userFollowers: UILabel!
    //MARK: - Props
    lazy var viewModel: ProfileViewModel = {
       return ProfileViewModel()
   }()
    //MARK: - LifeCycle
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
    //MARK: - ViewMethods
    func initView () {
        title = Titles.profileViewTitle
        tabBarItem.title = Titles.profileViewTitle
        tableView.tableFooterView = tableFooterView
        tableView.addSubview(refreshControl)
        tableView.isHidden = true
        view.addSubview(conditionLabel)
        conditionLabel.text = Titles.noToken
    }
    func initViewModel () {
        viewModel.userProfileData(requestData: GitRequestRouter.gitAuthenticatedUser,
                        userName: userName, userAvatar: userAvatar, userFollowData: userFollowers,
                        userBio: userBio, userLoginName: userLogin, userLocation: userLocation, tableView: tableView)
    }
    @IBAction func didTapSettingsButton(_ sender: UIBarButtonItem) {
        viewModel.router?.trigger(.settings)
    }
}
//MARK: - TableView
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfProfileElementCells
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ProfileTableViewCell
        cell.cellData(with: viewModel.getProfileViewModel(at: indexPath))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.pushToPrivateDestnationVC(indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
