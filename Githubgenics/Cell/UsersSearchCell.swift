//
//  UsersSearchCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 14/01/2021.
//

import UIKit
import Kingfisher

class UsersSearchCell: UITableViewCell {
    
    static let identifier = "Cell"
    @IBOutlet var UserTitleLabel: UILabel!
    @IBOutlet var UserAvatar: UIImageView!

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
        self.UserTitleLabel.text = model.login
        let url = model.avatar_url
        self.UserAvatar.kf.setImage(with: URL(string: url), placeholder: nil, options: [.transition(.fade(0.7))])
        UserAvatar.contentMode = .scaleAspectFill
        UserAvatar.layer.masksToBounds = false
        UserAvatar.layer.cornerRadius = UserAvatar.frame.height/2
        UserAvatar.clipsToBounds = true

    }
    
}
