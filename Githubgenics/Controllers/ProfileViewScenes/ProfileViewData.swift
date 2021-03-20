//
//  ViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 20/03/2021.
//

import UIKit
import SwiftyJSON
import Alamofire
import Kingfisher

class ProfileViewData: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let tableFooterView = UIView()
    var profileTableData = [ProfileTableData]()
    var userRepository = [Repository]()
    var selectedRepository: Repository?
    var passedUser : items?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    
    let noContentLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textAlignment = .center
        label.textColor = UIColor(named: "color")
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    var isLoggedIn: Bool {
        if GitTokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    
    func userProfileData(requestData: GitRequestRouter,userName : UILabel, userAvatar: UIImageView, userFollowData: UILabel, userBio: UILabel, userLoginName: UILabel, userLocation: UILabel) {
        session.request(requestData).responseJSON { (response) in
            switch response.result {
            case .success(let responseJSON) :
                let recievedJson = JSON (responseJSON)
                let userAvatr = recievedJson["\(User.userAvatar)"].stringValue
                userName.text = recievedJson["\(User.userName)"].stringValue
                userAvatar.kf.setImage(with: URL(string: userAvatr), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                userAvatar.layer.masksToBounds = false
                userAvatar.layer.cornerRadius = userAvatar.frame.height/2
                userAvatar.clipsToBounds = true
                userFollowData.text = "followers:  " + recievedJson["\(User.userFollowers)"].stringValue + "  .  " + "following:  " + recievedJson["\(User.userFollowing)"].stringValue
                userBio.text = recievedJson["\(User.userBio)"].stringValue
                userLoginName.text = recievedJson["\(User.userLoginName)"].stringValue
                userLocation.text  = recievedJson["\(User.userLocation)"].stringValue
            case .failure(let error):
                print(error)
            }
        }
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.repositoriesViewTitle)", Image: "Repositories" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.Starred)", Image: "Startted" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.Organizations)", Image: "Organizations"))
    }
    
    func loggedInStatus (tableView: UITableView) {
        if isLoggedIn {
            noContentLabel.isHidden = true
        } else {
            tableView.isHidden = true
            noContentLabel.isHidden = false
        }
    }

}

extension ProfileViewData: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = profileTableData[indexPath.row].cellHeader
        cell.imageView?.image = UIImage(named: profileTableData[indexPath.row].Image)
        cell.imageView?.layer.cornerRadius = 10
        cell.imageView?.clipsToBounds = true
        return cell
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

//MARK:- Profile Model

struct ProfileTableData {
    let cellHeader: String
    let Image: String
}
