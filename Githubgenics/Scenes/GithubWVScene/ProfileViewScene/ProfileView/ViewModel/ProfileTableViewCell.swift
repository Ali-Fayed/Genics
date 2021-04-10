//
//  ProfileTableViewCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 10/04/2021.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellData (with model: ProfileTableData) {
        textLabel?.text = model.cellHeader
        imageView?.image = UIImage(named: model.Image)
        imageView?.layer.cornerRadius = 10
        imageView?.clipsToBounds = true
    }

}
