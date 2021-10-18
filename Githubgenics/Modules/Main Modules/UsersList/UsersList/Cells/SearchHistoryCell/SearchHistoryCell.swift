//
//  searchHistory.swift
//  Githubgenics
//
//  Created by Ali Fayed on 01/03/2021.
//

import UIKit

class SearchHistoryCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellData(with model: SearchHistory) {
        textLabel?.text = model.keyword
        accessoryView = UIImageView(image: UIImage(systemName: "arrow.up.backward"))
    }
    
}
