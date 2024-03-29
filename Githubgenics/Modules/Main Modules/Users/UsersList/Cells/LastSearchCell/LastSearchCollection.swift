//
//  SearchHistoryCollectionViewCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/01/2021.
//

import UIKit
import Kingfisher

class LastSearchCollectionCell: UICollectionViewCell {
    
    static let lastSearchCell     = "LastSearchCollection"
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func cellData(with model: LastSearch) {
        userName.text = model.userName
        guard let avatarURL = model.userAvatar else { return }
        userAvatar.kf.setImage(with: URL(string: avatarURL), placeholder: nil, options: [.transition(.fade(0.7))])
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.layer.masksToBounds = false
        userAvatar.layer.cornerRadius = userAvatar.frame.height/2
        userAvatar.clipsToBounds = true
    }
}
