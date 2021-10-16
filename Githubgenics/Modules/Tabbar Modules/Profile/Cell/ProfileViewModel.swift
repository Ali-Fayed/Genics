//
//  ProfileViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 08/04/2021.
//

import UIKit
import SwiftyJSON
import Alamofire

class ProfileViewModel {
    var profileTableData = [ProfileTableData]()
    var userRepository = [Repository]()
    var selectedRepository: Repository?
    var passedUser : User?
    var router = ProfileCordinator()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var isLoggedIn: Bool {
        if TokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }

    var numberOfProfileElementCells: Int {
        return  profileTableData.count
    }
    func getProfileViewModel( at indexPath: IndexPath ) -> ProfileTableData {
        return profileTableData[indexPath.row]
    }
    func pushToPrivateDestnationVC(indexPath: IndexPath, navigationController: UINavigationController) {
        if indexPath.row == 0 {
            router.pushTo(destination: .privateRepos, navigationController: navigationController, passedUser: nil)
        } else if indexPath.row == 1 {
            router.pushTo(destination: .privateStarred, navigationController: navigationController, passedUser: nil)
        } else if indexPath.row == 2 {
            router.pushTo(destination: .privateOrgs, navigationController: navigationController, passedUser: nil)
        }
    }
    
    func pushToPublicDestnationVC (indexPath: IndexPath, navigationController: UINavigationController) {
        if indexPath.row == 0 {
            router.pushTo(destination: .publicRepos, navigationController: navigationController, passedUser: passedUser)
        } else if indexPath.row == 1 {
            router.pushTo(destination: .publicStarred, navigationController: navigationController, passedUser: passedUser)
        } else if indexPath.row == 2 {
            router.pushTo(destination: .publicOrgs, navigationController: navigationController, passedUser: passedUser)
        }
    }
    
    func userProfileData(requestData: GitRequestRouter,userName : UILabel, userAvatar: UIImageView, userFollowData: UILabel, userBio: UILabel, userLoginName: UILabel, userLocation: UILabel) {
        NetworkingManger.shared.afSession.request(requestData).responseJSON { (response) in
            switch response.result {
            case .success(let responseJSON) :
                let recievedJson = JSON(responseJSON)
                let userAvatr = recievedJson["\(PrivateUser.userAvatar)"].stringValue
                userName.text = recievedJson["\(PrivateUser.userName)"].stringValue
                userAvatar.kf.setImage(with: URL(string: userAvatr), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                userAvatar.layer.masksToBounds = false
                userAvatar.layer.cornerRadius = userAvatar.frame.height/2
                userAvatar.clipsToBounds = true
                userFollowData.text = "followers:  " + recievedJson["\(PrivateUser.userFollowers)"].stringValue + "  .  " + "following:  " + recievedJson["\(PrivateUser.userFollowing)"].stringValue
                userBio.text = recievedJson["\(PrivateUser.userBio)"].stringValue
                userLoginName.text = recievedJson["\(PrivateUser.userLoginName)"].stringValue
                userLocation.text  = recievedJson["\(PrivateUser.userLocation)"].stringValue
            case .failure(let error):
                print(error)
            }
        }
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.repositoriesViewTitle)", image: "Repositories" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.starredViewTitle)", image: "Startted" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.organizationsViewTitle)", image: "Organizations"))
    }
    
        func loggedInStatus (tableView: UITableView, conditionLabel: UILabel) {
        if isLoggedIn {
            conditionLabel.isHidden = true
        } else {
            tableView.isHidden = true
            conditionLabel.isHidden = false
        }
    }
    
    func saveUserToBookmarks () {
        // save user to database bookmarks view
        let users = UsersDataBase(context: context)
        users.userName = self.passedUser?.userName
        users.userAvatar = self.passedUser?.userAvatar
        users.userURL = self.passedUser?.userURL
        try! self.context.save()
    }

}

struct ProfileTableData {
    let cellHeader: String
    let image: String
}
