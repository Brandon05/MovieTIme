//
//  CollectionViewMethods.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 2/8/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation
import UIKit

extension MoviesViewController {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard filteredData != nil else {return 1}
        
        return filteredData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let gridCell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as GridCell
        let listCell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ListCell
        let movie = filteredData[indexPath.row]
        
        switch isGridFlowLayoutUsed {
        case true:
            //print(isGridFlowLayoutUsed)
            return gridCell.bind(movie)
        case false:
            return listCell.bind(movie)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = moviesCollectionView.cellForItem(at: indexPath)
        cell?.tag = indexPath.row
        self.performSegue(withIdentifier: "DetailSegue", sender: cell)
    }
}
