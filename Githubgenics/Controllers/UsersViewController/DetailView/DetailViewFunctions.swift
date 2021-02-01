//
//  DetailViewFunctions.swift
//  Githubgenics
//
//  Created by Ali Fayed on 01/02/2021.
//

import UIKit


extension DetailViewController {
    
    func loadUserRepository () {
        guard let repository = passedUser else {return}
        RepostoriesRouter().fetchClickedRepositories(for: repository.userName) { [weak self] result in
            switch result {
            case .success(let repositories):
                self!.userRepository.append(contentsOf: repositories)
                DispatchQueue.main.async {
                    self!.tableView.reloadData()
                }
            case .failure(_):
             break
            }
     
        }
    }
    func loadUserProfileData () {
        userName.text = "\((passedUser?.userName.capitalized)!)"
        let avatar = (passedUser?.userAvatar)!
        userAvatar.kf.indicatorType = .activity
        userAvatar.kf.setImage(with: URL(string: avatar), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        userAvatar.layer.masksToBounds = false
        userAvatar.layer.cornerRadius = userAvatar.frame.height/2
        userAvatar.clipsToBounds = true
        userFollowers.text = String(Int.random(in: 10 ... 50))
        userFollowing.text = String(Int.random(in: 10 ... 50))
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
