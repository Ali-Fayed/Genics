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
    @IBOutlet weak var bookmarkRepository: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let ButtonState = defaults.string(forKey: "Bookmark State")
        {
            setButtonState = ButtonState
            
        }
        else { setButtonState = "off"
            
        }
    }
    
  
  //MARK:- Bookmark Button
    
    var setButtonState: String = "off" {
        willSet {
            if newValue == "on" {
                bookmarkRepository?.setBackgroundImage(UIImage(named: "like"), for: .normal)

            }
            else { bookmarkRepository?.setBackgroundImage(UIImage(named: "unlike"), for: .normal)


            }
        }
    }

    @IBAction func didTapButton(_ sender: Any) {
        delegate?.didTapButton(cell: self, didTappedThe: sender as? UIButton)
        let stat = setButtonState == "on" ? "off" : "on"
        setButtonState = stat
        defaults.set(stat , forKey: "BookmarkState")
        print(stat)
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

extension DetailViewController : DidTapCell {
    
    func didTapButton(cell: ReposCell, didTappedThe button: UIButton?) {
        guard let index = tableView.indexPath(for: cell) else {
            return
        }
        let repository = self.userRepository[index.row]
        Save().repository(repoName: repository.repositoryName, repoDescription: repository.repositoryDescription!, repoProgrammingLanguage: repository.repositoryLanguage! , repoURL: repository.repositoryURL, repoUserFullName: repository.repoFullName, repoStars: Float((repository.repositoryStars!)))
                DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
