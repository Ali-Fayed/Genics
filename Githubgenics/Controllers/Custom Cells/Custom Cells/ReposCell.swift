//
//  ReposCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 25/12/2020.
//

import UIKit
import Kingfisher

class ReposCell: UITableViewCell {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    weak var delegate : DetailViewCellDelegate?
    weak var repoListDelegate: RepositoryListCellDelegate?
    var defaults = UserDefaults.standard
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func buttonAccessory () {
        let starButton = UIButton(type: .system)
        starButton.setImage(#imageLiteral(resourceName: "fav_star"), for: .normal)
        starButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        starButton.tintColor = .red
        starButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        accessoryView = starButton
    }
    
    @objc func didTapButton(_ sender: Any) {
        delegate?.didTapButton(cell: self, didTappedThe: sender as? UIButton)
        repoListDelegate?.didTapButton(cell: self, didTappedThe: sender as? UIButton)
    }
    
    //MARK:- Repositories Cell Data
    
    func CellData( with model: Repository ) {
        self.textLabel?.text = model.repositoryName
        self.detailTextLabel?.text = model.repositoryDescription
    }
        
    func CellData(with model: SavedRepositories) {
        self.textLabel?.text = model.repoName
        self.detailTextLabel?.text = model.repoDescription
    }
}
