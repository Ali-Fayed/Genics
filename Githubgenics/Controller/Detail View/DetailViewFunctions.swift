//
//  DetailViewFunctions.swift
//  Githubgenics
//
//  Created by Ali Fayed on 01/02/2021.
//

import UIKit
import SafariServices

extension DetailViewController {
    
    //MARK:- Fetch Methods
    
    func renderClickedUserPunlicRepositories () {
        guard let repository = passedUser else {return}
        GitReposRouter().fetchUsersRepositories(for: repository.userName) { result in
            self.userRepository = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK:- UI Methods
    
    func renderUserProfileData () {
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
    
    func DisplaySpinner () {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    
    func shimmerLoadingView () {
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }
    }
    
    @IBAction func bookmarkButton(_ sender: UIButton) {
        let stat = setBookmarkButtonState == "on" ? "off" : "on"
        setBookmarkButtonState = stat
        defaults.set(stat, forKey: ((passedUser?.userName)!))
    }
    
    func loadTheButtonWithSavedState () {
        if let ButtonState = defaults.string(forKey: ((passedUser?.userName)!))
        {
            setBookmarkButtonState = ButtonState
        }
        else {
            setBookmarkButtonState = "off"
        }
    }
    
    //MARK:- Handle Long Press
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        let touchPoint = longPress.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            let cell = userRepository[indexPath.row].repositoryURL
            let vc = SFSafariViewController(url: URL(string: cell)!)
            present(vc, animated: true)
        }
    }
    
    //MARK:- Handle Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommitSegue" {
            guard let commitsViewController = segue.destination as? CommitsViewController else {
                return
            }
            commitsViewController.userRepositories = selectedRepository
        }
    }
}
