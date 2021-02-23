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
    
    func renderClickedUserPublicRepositories () {
        guard let repository = passedUser else {return}
        self.loadingIndicator.startAnimating()
        GitAPIManger().APIcall(returnType: Repository.self, requestData: GitRouter.fetchUsersRepository(repository.userName), pagination: true) { [weak self] (result) in
            self?.userRepository = result
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.tableView.reloadData()
                self?.skeletonViewLoader ()
            }
        }
    }
    
    //MARK:- UI Methods
    
    // passed user from users list data
    func renderUserProfileData () {
        userName.text = "\((passedUser?.userName.capitalized)!)"
        guard let passedUser = passedUser else {
            return
        }
        let avatar = passedUser.userAvatar
        userAvatar.kf.indicatorType = .activity
        userAvatar.kf.setImage(with: URL(string: avatar), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        userAvatar.layer.masksToBounds = false
        userAvatar.layer.cornerRadius = userAvatar.frame.height/2
        userAvatar.clipsToBounds = true
        // userFollowers and following is private
        userFollowers.text = String(Int.random(in: 10 ... 100))
        userFollowing.text = String(Int.random(in: 10 ... 100))
    }
    
    // tableView spinner
    func tableViewSpinnerFooter () {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    
    // loadr before fetching
    func skeletonViewLoader () {
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        tableView.skeletonCornerRadius = 12
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }
    }
    
    // change button value between on or off
    @IBAction func bookmarkButton(_ sender: UIButton) {
        let stat = setBookmarkButtonState == "on" ? "off" : "on"
        setBookmarkButtonState = stat
        guard let passedUser = passedUser else {
            return
        }
        defaults.set(stat, forKey: (passedUser.userName))
        HapticsManger.shared.selectionVibrate(for: .medium)
    }
    
    // laod button state
    func renderTheButtonWithSavedState () {
        guard let passedUser = passedUser else {
            return
        }
        if let ButtonState = defaults.string(forKey: (passedUser.userName))
        {
            setBookmarkButtonState = ButtonState
        }
        else {
            setBookmarkButtonState = "off"
        }
    }
    
    //MARK:- Handle Long Press
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        // haptic when touch
        HapticsManger.shared.selectionVibrate(for: .medium)
        let touchPoint = longPress.location(in: tableView)
        if let index = tableView.indexPathForRow(at: touchPoint) {
            // alert sheet
            let sheet = UIAlertController(title: Titles.more, message: nil , preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: Titles.bookmark, style: .default, handler: { (url) in
                // save repos to database
                let repository = self.userRepository[index.row]
                let saveRepoInfo = SavedRepositories(context: self.context)
                saveRepoInfo.repoName = repository.repositoryName
                saveRepoInfo.repoDescription = repository.repositoryDescription
                saveRepoInfo.repoProgrammingLanguage = repository.repositoryLanguage
                saveRepoInfo.repoUserFullName = repository.repoFullName
                saveRepoInfo.repoStars = Float(repository.repositoryStars ?? 0)
                saveRepoInfo.repoURL = repository.repositoryURL
                try! self.context.save()
            }))
            // open url
            sheet.addAction(UIAlertAction(title: Titles.url, style: .default, handler: { (url) in
                let cell = self.userRepository[index.row].repositoryURL
                let vc = SFSafariViewController(url: URL(string: cell)!)
                self.present(vc, animated: true)
            }))
            // cancel sheet
            sheet.addAction(UIAlertAction(title: Titles.cancel, style: .cancel, handler: nil ))
            present(sheet, animated: true)
        }
    }
    
    //MARK:- Handle Star Button State
    
    
    // load button state UD
    func renderStarState () {
        if let checks = UserDefaults.standard.value(forKey: passedUser!.userName) as? NSData {
            do {
                try starButton = NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(checks as Data) as! [Int : Bool]
            } catch {
                //
            }
        }
    }
    
    // save button state in UD
    func saveStarState () {
        do {
            try UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: starButton, requiringSecureCoding: true), forKey: passedUser!.userName)
            UserDefaults.standard.synchronize()
        } catch {
            //
        }
    }
    
    //MARK:- Handle Segue
    
    // segue with passed Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.commitViewSegue {
            guard let commitsViewController = segue.destination as? CommitsViewController else {
                return
            }
            commitsViewController.repository = selectedRepository
        }
    }
}
