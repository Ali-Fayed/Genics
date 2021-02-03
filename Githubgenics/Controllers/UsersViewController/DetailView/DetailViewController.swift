//
//  DetailViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import SkeletonView
import Kingfisher

//MARK:- Main Class

class DetailViewController: UIViewController  {
    var checkmarks = [Int : Bool]()


    var userRepository : [UserRepository] = []
    var savedRepos = [SavedRepositories]()
    var defaults = UserDefaults.standard
    var passedUser : items?
    var selectedRepository: UserRepository?
    var gg: UserRepository?
    let longPress = UILongPressGestureRecognizer()
    var setBookmarkButtonState: String = "off" {
        willSet {
            if newValue == "on" {
                bookmarkButton.setBackgroundImage(UIImage(named: "like"), for: .normal)
                Save().user(login: (passedUser?.userName)!, avatar_url: (passedUser?.userAvatar)!, html_url: (passedUser?.userURL)!)
            }
            else { bookmarkButton.setBackgroundImage(UIImage(named: "unlike"), for: .normal)

            }
        }
    }
    
    

    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userFollowers: UILabel!
    @IBOutlet weak var userFollowing: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addGestureRecognizer(longPress)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationItem.title = "Detail View".localized()
        loadUserProfileData ()
        loadTheButtonWithSavedState ()
        loadUserRepository()
        tableView.rowHeight = 120
        
        if let checks = UserDefaults.standard.value(forKey: "checkmarks") as? NSData {
            checkmarks = (NSKeyedUnarchiver.unarchiveObject(with: checks as Data) as? [Int : Bool])!
        }
     
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
 
    }
        
}

    


