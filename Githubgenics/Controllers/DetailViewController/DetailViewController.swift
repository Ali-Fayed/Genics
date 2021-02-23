//
//  DetailViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import SkeletonView

class DetailViewController: UIViewController  {
    
    // data models
    var userRepository = [Repository]()
    var savedRepos = [SavedRepositories]()
    var passedUser : items?
    var selectedRepository: Repository?
    // userdefaults to cache user settings
    var defaults = UserDefaults.standard
    // longpress
    let longPress = UILongPressGestureRecognizer()
    var starButton = [Int : Bool]()
    // persistentContainer context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    
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
        // add gestures when try to back
        tableView.addGestureRecognizer(longPress)
        // add spinner as subview
        view.addSubview(loadingIndicator)
        tableView.rowHeight = 60
        // back with gestures
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        //view title
        navigationItem.title = Titles.DetailViewTitle
        // register cell with generics
        tableView.registerCellNib(cellClass: ReposCell.self)
        // headerView data
        renderUserProfileData ()
        // load user bookmark button state
        renderTheButtonWithSavedState ()
        // load userRepos
        renderClickedUserPublicRepositories()
        // load stars state
        renderStarState()
    }
            
}
