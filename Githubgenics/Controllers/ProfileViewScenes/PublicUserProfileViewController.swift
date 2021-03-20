//
//  PublicUserProfileViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import SkeletonView
import SafariServices
import SwiftyJSON

class PublicUserProfileViewController: ProfileViewData  {
    
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
    
    // Bookmark button states on and off with state and save to database
    var setBookmarkButtonState: String = "off" {
        willSet {
            if newValue == "on" {
                bookmarkButton?.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                // save user to database bookmarks view
                let users = UsersDataBase(context: context)
                users.userName = self.passedUser?.userName
                users.userAvatar = self.passedUser?.userAvatar
                users.userURL = self.passedUser?.userURL
                try! self.context.save()
            }
            else {
                bookmarkButton?.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        }
    }

    //MARK:- LifeCycle Methods
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        title = Titles.profileViewTitle
        renderTheButtonWithSavedState ()
        tableView.tableFooterView = tableFooterView
        tableView.addSubview(refreshControl)
        guard let user = passedUser?.userName else {return}
        userProfileData(requestData: GitRequestRouter.gitPublicUserInfo(user),
                        userName: userName, userAvatar: userAvatar, userFollowData: userFollowers,
                        userBio: userBio, userLoginName: userLogin, userLocation: userLocation)
    }
                   
    // change button value between on or off
    @IBAction func bookmarkButton(_ sender: UIButton) {
        let stat = setBookmarkButtonState == "on" ? "off" : "on"
        setBookmarkButtonState = stat
        guard let passedUser = passedUser else { return }
        UserDefaults.standard.set(stat, forKey: (passedUser.userName))
        HapticsManger.shared.selectionVibrate(for: .medium)
    }
    
    @IBAction func urlButton(_ sender: UIButton) {
        guard let user = passedUser else { return }
        let url = user.userURL
        let vc = SFSafariViewController(url: URL(string: url)!)
        self.present(vc, animated: true)
    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        guard let url = passedUser?.userURL else { return }
        let sheetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(sheetVC, animated: true)
        HapticsManger.shared.selectionVibrate(for: .medium)
    }
    
    // laod button state
    func renderTheButtonWithSavedState () {
        guard let passedUserName = passedUser?.userName else { return }
        if let ButtonState = UserDefaults.standard.string(forKey: (passedUserName))
        {
            setBookmarkButtonState = ButtonState
        }
        else {
            setBookmarkButtonState = "off"
        }
    }
}


//MARK:- tableView

extension PublicUserProfileViewController {
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let vc = UIStoryboard.init(name: Storyboards.usersRepos , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.usersRepositoryViewControllerID) as? PublicUserRepositoriesViewController
            vc?.passedUser = passedUser
            self.navigationController?.pushViewController(vc!, animated: true)
            
        } else if indexPath.row == 1 {
            let vc = UIStoryboard.init(name: Storyboards.usersStartted , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.usersStartedViewControllerID) as? PublicUserStarredViewController
            vc?.passedUser = passedUser
            self.navigationController?.pushViewController(vc!, animated: true)
            
        } else if indexPath.row == 2 {
            let vc = UIStoryboard.init(name: Storyboards.usersOrgs , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.usersOrgsViewControllerID) as? OrgsViewController
            vc?.passedUser = passedUser
            vc?.fetchPublicUserOrgs()
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
    }

}
