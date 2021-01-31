//
//  UsersSearchCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 14/01/2021.
//

import UIKit
import Kingfisher

class UsersSearchCell: UITableViewCell {
    
    @IBOutlet var userName: UILabel!
    @IBOutlet var userAvatar: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    static func nib() -> UINib {
        return UINib(nibName: "QueryCell",
                     bundle: nil)
    }

    func CellData(with model: items) {
        self.userName.text = model.userName
        let url = model.userAvatar
        self.userAvatar.kf.setImage(with: URL(string: url!), placeholder: nil, options: [.transition(.fade(0.7))])
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.layer.masksToBounds = false
        userAvatar.layer.cornerRadius = userAvatar.frame.height/2
        userAvatar.clipsToBounds = true
    }
    
    func CellData(with model: UsersDataBase) {
        self.userName.text = model.login
        let url = model.avatar_url
        self.userAvatar.kf.setImage(with: URL(string: url!), placeholder: nil, options: [.transition(.fade(0.7))])
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.layer.masksToBounds = false
        userAvatar.layer.cornerRadius = userAvatar.frame.height/2
        userAvatar.clipsToBounds = true
    }
    
}
