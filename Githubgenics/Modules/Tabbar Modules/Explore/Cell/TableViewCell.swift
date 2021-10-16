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
    var topUsers = [User]()
    var bestRepos = [Repository]()
    var bestPython = [Repository]()
    var bestJavaScript = [Repository]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NetworkingManger.shared.performRequest(dataModel: Repositories.self, requestData: GitRequestRouter.gitPublicRepositories(1, "language:Swift")) { [weak self] (result) in
            switch result {
            case .success(let result):
                self?.bestRepos = result.items
                self?.collectionView.reloadData()
            case .failure(let error):
                break
            }
        }
        NetworkingManger.shared.performRequest(dataModel: Repositories.self, requestData: GitRequestRouter.gitPublicRepositories(1, "language:Dart")) { [weak self] (result) in
            switch result {
            case .success(let result):
                self?.bestPython = result.items
                self?.collectionView.reloadData()
            case .failure(let error):
                break
            }
        }
        NetworkingManger.shared.performRequest(dataModel: Repositories.self, requestData: GitRequestRouter.gitPublicRepositories(1, "language:Java")) { [weak self] (result) in
            switch result {
            case .success(let result):
                self?.bestJavaScript = result.items
                self?.collectionView.reloadData()
            case .failure(let error):
                break
            }
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
            cell!.cellData(with: bestRepos[indexPath.row])
            return cell!
        case 1:
            cell!.cellData(with: bestRepos[indexPath.row])
            return cell!
        default:
            cell!.cellData(with: bestRepos[indexPath.row])
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
