//
//  UVC Collectio.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/03/2021.
//

import UIKit
import SafariServices

extension UsersViewController:  UICollectionViewDataSource , UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfLastSearchCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LastSearchCollectionCell.lastSearchCell, for: indexPath) as? LastSearchCollectionCell
        cell!.CellData(with: viewModel.getLastSearchViewModel(at: indexPath))
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let url = viewModel.getLastSearchViewModel(at: indexPath).userURL
        let vc = SFSafariViewController(url: URL(string: url!)!)
        present(vc, animated: true)
    }
    
}
