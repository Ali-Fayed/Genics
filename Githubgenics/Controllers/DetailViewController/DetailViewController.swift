//
//  DetailViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import SkeletonView

class DetailViewController: UIViewController  {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    var defaults = UserDefaults.standard
    let longPress = UILongPressGestureRecognizer()
    var userRepository = [Repository]()
    var savedRepos = [SavedRepositories]()
    var passedUser : items?
    var selectedRepository: Repository?
    var starButton = [Int : Bool]()

    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userFollowers: UILabel!
    @IBOutlet weak var userFollowing: UILabel!
    
    var setBookmarkButtonState: String = "off" {
        willSet {
            if newValue == "on" {
                bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
                let users = UsersDataBase(context: context)
                    users.userName = self.passedUser?.userName
                    users.userAvatar = self.passedUser?.userAvatar
                    users.userURL = self.passedUser?.userURL
                    try! self.context.save()
            }
            else {
                bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
        }
    }
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        tableView.addGestureRecognizer(longPress)
        view.addSubview(loadingIndicator)
        tableView.rowHeight = 60
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationItem.title = Titles.DetailViewTitle
        tableView.registerCellNib(cellClass: ReposCell.self)
        renderUserProfileData ()
        renderTheButtonWithSavedState ()
        renderClickedUserPublicRepositories()
        renderStarState()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }
}
