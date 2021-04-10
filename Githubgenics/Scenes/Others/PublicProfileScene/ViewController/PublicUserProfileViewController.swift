//
//  PublicUserProfileViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import SafariServices

class PublicUserProfileViewController: ViewSetups  {
    
    @IBOutlet weak var bookmarkButton: UIButton?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLogin: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var userBio: UILabel!
    @IBOutlet weak var Header: UIView!
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userFollowers: UILabel!
    
    lazy var viewModel: ProfileViewModel = {
       return ProfileViewModel()
   }()
    
    // Bookmark button states on and off with state and save to database
    var setBookmarkButtonState: String = "off" {
        willSet {
            if newValue == "on" {
                bookmarkButton?.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                viewModel.saveUserToBookmarks ()
            }
            else {
                bookmarkButton?.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        }
    }
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    
    func initView() {
        renderTheButtonWithSavedState ()
        tableView.tableFooterView = tableFooterView
        tableView.addSubview(refreshControl)
    }
    
    func initViewModel() {
        guard let user = viewModel.passedUser?.userName else {return}
        viewModel.userProfileData(requestData: GitRequestRouter.gitPublicUserInfo(user),
                        userName: userName, userAvatar: userAvatar, userFollowData: userFollowers,
                        userBio: userBio, userLoginName: userLogin, userLocation: userLocation)
    }
                   
    func renderTheButtonWithSavedState () {
        guard let passedUserName = viewModel.passedUser?.userName else { return }
        if let ButtonState = UserDefaults.standard.string(forKey: (passedUserName))
        {
            setBookmarkButtonState = ButtonState
        }
        else {
            setBookmarkButtonState = "off"
        }
    }
}

extension PublicUserProfileViewController {
    
    // change button value between on or off
    @IBAction func bookmarkButton(_ sender: UIButton) {
        let stat = setBookmarkButtonState == "on" ? "off" : "on"
        setBookmarkButtonState = stat
        guard let passedUser = viewModel.passedUser else { return }
        UserDefaults.standard.set(stat, forKey: (passedUser.userName))
        HapticsManger.shared.selectionVibrate(for: .medium)
    }
    
    @IBAction func urlButton(_ sender: UIButton) {
        guard let user = viewModel.passedUser else { return }
        let url = user.userURL
        let vc = SFSafariViewController(url: URL(string: url)!)
        self.present(vc, animated: true)
    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        guard let url = viewModel.passedUser?.userURL else { return }
        let sheetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(sheetVC, animated: true)
        HapticsManger.shared.selectionVibrate(for: .medium)
    }
    
    
}
