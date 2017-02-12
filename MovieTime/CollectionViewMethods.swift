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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector((MoviesViewController.didTap(_:))))
        // Add tap gesture recognizer on text view to segue to detail
        //listCell.descriptionTextView.addGestureRecognizer(tapGesture)
        
        
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

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard recommendedMovies != nil else {print("No recommended Movies"); return 0}
        
        return recommendedMovies.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let gridCell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as GridCell
        let movie = recommendedMovies[indexPath.row]
        
        return gridCell.bind(movie)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = recommendedCollectionView.cellForItem(at: indexPath) as! GridCell
        let movie = recommendedMovies[indexPath.row]
        //guard let movie = movies[(cell.tag)] as? Movie else {print("error passing data")}
        guard cell != nil else {return}
        print(movie)
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.movie = movie
         //this is the data which will be passed to the new vc
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension WatchLaterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard watchLaterFiltered != nil else {print("No Movies"); return 0}
        
        return watchLaterFiltered.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let gridCell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as GridCell
        let listCell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ListCell
        let movie = watchLaterFiltered[indexPath.row]
        
        switch isGridFlowLayoutUsed {
        case true:
            return gridCell.bind(movie)
        case false:
            return listCell.bind(movie)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = watchLaterCollectionView.cellForItem(at: indexPath)
//        cell?.tag = indexPath.row
//        self.performSegue(withIdentifier: "DetailSegue", sender: cell)
        
        //let cell = watchLaterCollectionView.cellForItem(at: indexPath) as! GridCell
        let movie = watchLaterFiltered[indexPath.row]
//        //guard let movie = movies[(cell.tag)] as? Movie else {print("error passing data")}
        guard cell != nil else {return}
//        print(movie)
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
//      this is the data which will be passed to the new vc
        vc.movie = movie
    
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
