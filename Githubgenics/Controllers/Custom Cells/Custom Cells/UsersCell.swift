//
//  UsersSearchCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 14/01/2021.
//

import UIKit
import Kingfisher

class UsersCell: UITableViewCell {
    
    static let profileImageSize: CGSize = CGSize(width: 50, height: 50)
    @IBOutlet var userName: UILabel!
    @IBOutlet var userAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func CellData(with model: UsersDataBase) {
        self.userName.text = model.userName
        guard let url = model.userAvatar else { return }
        self.userAvatar.kf.setImage(with: URL(string: url), placeholder: nil, options: [.transition(.fade(0.7))])
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.layer.masksToBounds = false
        userAvatar.layer.cornerRadius = userAvatar.frame.height/2
        userAvatar.clipsToBounds = true
    }
    
    func CellData(with model: items) {
        self.userName.text = model.userName.capitalized
        let url = model.userAvatar
        self.userAvatar.kf.setImage(with: URL(string: url), placeholder: nil, options: [.transition(.fade(0.7))])
        self.userAvatar.layer.cornerRadius = UsersCell.profileImageSize.width / 2.0
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.layer.masksToBounds = false
        userAvatar.layer.cornerRadius = userAvatar.frame.height/2
        userAvatar.clipsToBounds = true
        userName.layer.masksToBounds = false
        userName.layer.cornerRadius = userName.frame.height/2
        userName.clipsToBounds = true
    }
}

