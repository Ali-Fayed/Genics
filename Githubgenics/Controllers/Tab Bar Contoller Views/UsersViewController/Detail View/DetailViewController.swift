//
//  DetailViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import SkeletonView

class DetailViewController: UIViewController  {
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    var defaults = UserDefaults.standard
    let longPress = UILongPressGestureRecognizer()
    var userRepository = [UserRepository]()
    var savedRepos = [SavedRepositories]()
    var passedUser : items?
    var selectedRepository: UserRepository?
    
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
        view.addSubview(loadingIndicator)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationItem.title = Titles.DetailViewTitle
        tableView.register(Cells.reposNib(), forCellReuseIdentifier: Cells.repositoriesCell)
        renderUserProfileData ()
        renderTheButtonWithSavedState ()
        renderClickedUserPublicRepositories()
        tableView.rowHeight = 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }
}
