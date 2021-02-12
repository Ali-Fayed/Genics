//
//  DetailViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import SkeletonView

class DetailViewController: UIViewController  {

    var userRepository = [UserRepository]()
    var savedRepos = [SavedRepositories]()
    var passedUser : items?
    var selectedRepository: UserRepository?
    var defaults = UserDefaults.standard
    let longPress = UILongPressGestureRecognizer()
    
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userFollowers: UILabel!
    @IBOutlet weak var userFollowing: UILabel!
    
    var setBookmarkButtonState: String = "off" {
        willSet {
            if newValue == "on" {
                bookmarkButton.setBackgroundImage(UIImage(named: "like"), for: .normal)
                Save().user(userName: (passedUser?.userName)!, userAvatar: (passedUser?.userAvatar)!, userURL: (passedUser?.userURL)!)
            }
            else { bookmarkButton.setBackgroundImage(UIImage(named: "unlike"), for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addGestureRecognizer(longPress)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationItem.title = Titles.DetailViewTitle
        tableView.register(Cells.reposNib(), forCellReuseIdentifier: Cells.repositoriesCell)
        renderUserProfileData ()
        loadTheButtonWithSavedState ()
        renderClickedUserPunlicRepositories()
        tableView.rowHeight = 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }
        
}
