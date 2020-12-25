//
//  TableViewCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/12/2020.
//

import UIKit

class UsersCell: UITableViewCell {
    
    var User:UsersStruct?
    var Users = [UsersStruct]()

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var UserNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func UserImage () {
        ImageView.layer.cornerRadius = 10
        let APIImageurl = (User?.avatar_url)!
        ImageView.downloaded(from: APIImageurl)
    }
 
    
}
