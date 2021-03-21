//
//  TableViewCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/03/2021.
//

import UIKit
import SafariServices

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var topUsers = [items]()
    var bestRepos = [Repository]()
    var bestPython = [Repository]()
    var bestJavaScript = [Repository]()
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        GitAPIcaller.shared.makeRequest(returnType: Repositories.self, requestData: GitRequestRouter.gitPublicRepositories(1, "language:Swift")) { [weak self] (repos) in
            self?.bestRepos = repos.items
            self?.collectionView.reloadData()
        }
        GitAPIcaller.shared.makeRequest(returnType: Repositories.self, requestData: GitRequestRouter.gitPublicRepositories(1, "language:Dart")) { [weak self] (repos) in
            self?.bestPython = repos.items
            self?.collectionView.reloadData()
        }
        GitAPIcaller.shared.makeRequest(returnType: Repositories.self, requestData: GitRequestRouter.gitPublicRepositories(1, "language:Java")) { [weak self] (repos) in
            self?.bestJavaScript = repos.items
            self?.collectionView.reloadData()
        }
        
    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension TableViewCell:  UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bestRepos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ExploreCollectionViewCell
        switch indexPath.row {
        case 0:
            cell!.CellData(with: bestRepos[indexPath.index(after: 9)])
            return cell!
        case 1:
            cell!.CellData(with: bestRepos[indexPath.row])
            return cell!
        default:
            cell!.CellData(with: bestRepos[indexPath.index(before: 12)])
            return cell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 420, height: 450)
    }
    

}
