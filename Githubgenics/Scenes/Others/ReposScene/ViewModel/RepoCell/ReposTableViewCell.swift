//
//  ReposCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 25/12/2020.
//

import UIKit
import Kingfisher

class ReposTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userRepoLangaugeImage: UIImageView!
    @IBOutlet weak var userRepoName: UILabel!
    @IBOutlet weak var userRepoDescription: UILabel!
    @IBOutlet weak var userRepoStars: UILabel!
    @IBOutlet weak var userRepoLangauge: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    weak var delegate : DetailViewCellDelegate?
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
    }
    
    //MARK:- Repositories Cell Data
    
    func CellData( with model: Repository ) {
        self.userRepoName?.text = model.repositoryName
        self.userRepoDescription?.text = model.repositoryDescription
        self.userRepoStars?.text = String(model.repositoryStars!)
        self.userRepoLangauge?.text = model.repositoryLanguage
    }
        
    func CellData(with model: SavedRepositories) {
        self.userRepoName?.text = model.repoName
        self.userRepoDescription?.text = model.repoDescription
        self.userRepoStars?.text = String(model.repoStars)
        self.userRepoLangauge?.text = model.repoProgrammingLanguage
    }
}


