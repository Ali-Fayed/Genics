//
//  UsersSearchCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 14/01/2021.
//

import UIKit

class UsersSearchCell: UITableViewCell {

    @IBOutlet var UserTitleLabel: UILabel!
    @IBOutlet var UserAvatar: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    static let identifier = "Cell"

    static func nib() -> UINib {
        return UINib(nibName: "QueryCell",
                     bundle: nil)
    }

    func CellData(with model: items) {
        self.UserTitleLabel.text = model.login
        let url = model.avatar_url
        if let data = try? Data(contentsOf: URL(string: url)!) {
            self.UserAvatar.image = UIImage(data: data)
        }
    }
    
}
