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
    
    var userRepository : [UserRepository] = []
    var passedUser : Users?
    var defaults = UserDefaults.standard

    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userFollowers: UILabel!
    @IBOutlet weak var userFollowing: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationItem.title = "Detail View".localized()
        userName.text = "\((passedUser?.userName?.capitalized)!)"
        let avatar = (passedUser?.userAvatar)!
        userAvatar.kf.indicatorType = .activity
        userAvatar.kf.setImage(with: URL(string: avatar), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        userAvatar.layer.masksToBounds = false
        userAvatar.layer.cornerRadius = userAvatar.frame.height/2
        userAvatar.clipsToBounds = true
        userFollowers.text = String(Int.random(in: 10 ... 50))
        userFollowing.text = String(Int.random(in: 10 ... 50))
        loadTheButtonWithSavedState ()
        guard let repository = passedUser else {return}
        RepostoriesRouter().fetchClickedRepositories(for: repository.userName!) { (result) in
            self.userRepository = result
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }
    
    //MARK:- User Bookmark Button
    
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
    
    @IBAction func bookmarkButton(_ sender: UIButton) {
        let stat = setBookmarkButtonState == "on" ? "off" : "on"
        setBookmarkButtonState = stat
        defaults.set(stat, forKey: ((passedUser?.userName)!))
        print(stat)
    }
    
    func loadTheButtonWithSavedState () {
        if let ButtonState = defaults.string(forKey: ((passedUser?.userName)!))
        { setBookmarkButtonState = ButtonState }
        else { setBookmarkButtonState = "off" }
    }
    
}

    

