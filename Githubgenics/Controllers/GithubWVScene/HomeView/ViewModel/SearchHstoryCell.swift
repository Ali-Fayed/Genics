//
//  SearchHistoryCellViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 07/04/2021.
//

import UIKit

class SearchHstoryCell: UITableViewCell {
    
    func cellViewModel(with model: SearchHistory) {
        textLabel?.text = model.keyword
        accessoryView = UIImageView(image: UIImage(systemName: "arrow.up.backward"))
    }
}
