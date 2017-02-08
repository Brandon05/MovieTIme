//
//  UICollectionViewExtentions.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 2/7/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation
import UIKit

/*
 MARK: - Extension to Register Nib
 before:
 let cell = UINib(nibName: "Cell", bundle: nil)
 self.collectionView.registerNib(cell, forCellWithReuseIdentifier: "Cell")
 
 after:
 self.collectionView.register(Cell) - where Cell is the actual class name
 */

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        
        let Nib = UINib(nibName: T.nibName, bundle: nil)
        register(Nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}


/*
 MARK: - Extension to Dequeue Cell
 before:
 guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? Cell
 else { fatalError() }
 
 after: (No force unwrapping or ugly guard else statement)
 return collectionView.dequeueReusableCell(forIndexPath: indexPath) as Cell
 */


extension UICollectionView {
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

/*
 Completion handler for reloadData()
 - allows collectionViewFlowLayout to be set in completion
 */

extension UICollectionView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
}
