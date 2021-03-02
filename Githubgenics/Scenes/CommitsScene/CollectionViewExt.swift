//
//  CollectionViewExt.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/02/2021.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func registerCellNib<Cell: UICollectionViewCell>(cellClass: Cell.Type){
        self.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: Cell.self))
    }


    func dequeue<Cell: UICollectionView>() -> Cell{
        let identifier = String(describing: Cell.self)
        
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: IndexPath) as? Cell else {
            fatalError("Error in cell")
        }
        
        return cell
    }
        
}
