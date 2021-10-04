//
//  CommitsCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 01/03/2021.
//

import UIKit
import Kingfisher

class CommitsCell: UITableViewCell {

    @IBOutlet weak var authorAvatar: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var message: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellData(with model: Commit) {
        self.authorName?.text = model.authorName.capitalized
        self.message?.text = model.message
        let authorAvatarURL = model.authorAvatarURL
        self.authorAvatar.kf.setImage(with: URL(string: authorAvatarURL), placeholder: nil, options: [.transition(.fade(0.7))])
        self.authorAvatar.layer.cornerRadius = UsersTableViewCell.profileImageSize.width / 2.0
        authorAvatar.contentMode = .scaleAspectFill
        authorAvatar.layer.masksToBounds = false
        authorAvatar.layer.cornerRadius = authorAvatar.frame.height/2
        authorAvatar.clipsToBounds = true
    }
    
}
