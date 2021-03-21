//
//  ExploreCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/03/2021.
//

import UIKit

class ExploreCell: UITableViewCell {

    @IBOutlet weak var repoHeader: UIImageView!
    @IBOutlet weak var repoOwnerImage: UIImageView!
    @IBOutlet weak var repoOwnerName: UILabel!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    @IBOutlet weak var repoStartsNumber: UILabel!
    @IBOutlet weak var repoLanguage: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func CellData( with model: Repository ) {
        self.repoName?.text = model.repositoryName
        self.repoDescription?.text = model.repositoryDescription
        self.repoStartsNumber?.text = String(model.repositoryStars!)
        self.repoLanguage?.text = model.repositoryLanguage
        self.repoOwnerName?.text = model.repoOwnerName
        let url = model.repoOwnerAvatarURL
        self.repoOwnerImage.kf.setImage(with: URL(string: url), placeholder: nil, options: [.transition(.fade(0.7))])
        self.repoHeader.kf.setImage(with: URL(string: url), placeholder: nil, options: [.transition(.fade(0.7))])
        self.repoOwnerImage.layer.cornerRadius = UsersCell.profileImageSize.width / 2.0
        repoOwnerImage.contentMode = .scaleAspectFill
        repoOwnerImage.layer.masksToBounds = false
        repoOwnerImage.layer.cornerRadius = repoOwnerImage.frame.height/2
        repoOwnerImage.clipsToBounds = true
        let blurEffect = UIBlurEffect(style: .regular)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = repoHeader.bounds
        contentView.addSubview(blurredEffectView)
    }
    
}
