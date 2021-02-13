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
    weak var delegate:DidTapCell?
    var defaults = UserDefaults.standard
    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var repositoryDescription: UITextView!
    @IBOutlet weak var repositoryStars: UILabel!
    @IBOutlet weak var repositoryLanguage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK:- Repositories Cell Data
    
    func CellData( with model: UserRepository ) {
        self.repositoryName.text = model.repositoryName
        self.repositoryDescription.text = model.repositoryDescription
        self.repositoryStars.text = String(model.repositoryStars!)
        self.repositoryLanguage.text = model.repositoryLanguage
    }
    
    
    func CellData(with model: Repository) {
        repositoryName?.text = model.repositoryName
        repositoryDescription?.text = model.repositoryDescription
        repositoryLanguage.text = model.repositoryLanguage
        repositoryStars.text = String(model.repositoryStars!)
    }
    
    func CellData(with model: SavedRepositories) {
        self.repositoryName.text = model.repoName
        self.repositoryDescription.text = model.repoDescription
        self.repositoryStars?.text = String(model.repoStars)
        self.repositoryLanguage.text = model.repoProgrammingLanguage
    }
}
