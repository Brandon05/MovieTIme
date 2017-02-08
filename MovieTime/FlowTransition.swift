//
//  FlowTransition.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 2/8/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation
import UIKit

extension MoviesViewController {
    // MARK:- CollectionViewFlowLayout Animations
    
    func fadeOutList() {
        let animationDuration = 0.5
        
        // Fade in the view
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            self.moviesCollectionView.alpha = 0
            //            self.collectionView.scrollToTop(animated: false, completion: {
            //            })
            //self.collectionView.scrollToTop(animated: true)
        }) { (Bool) -> Void in
            
            // After the animation completes, fade out the view after a delay
            self.moviesCollectionView.reloadData() {
                self.loadGridView() // must be called after new cells are loaded
            }
            self.moviesCollectionView.alpha = 1
        }
    }
    
    func fadeOutGrid() {
        
        let animationDuration = 0.5
        
        // Fade in the view
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            self.moviesCollectionView.alpha = 0
            //            self.collectionView.scrollToTop(animated: false, completion: {
            //            })
        }) { (Bool) -> Void in
            self.moviesCollectionView.collectionViewLayout.invalidateLayout() //neccesary to avoid autolayout loop
            // After the animation completes, fade out the view after a delay
            self.moviesCollectionView.reloadData() {
                self.loadListView() // must be called after new cells are loaded
            }
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.moviesCollectionView.alpha = 1
            }
            
        }
        
    }
    
    
    func loadListView() {
        isGridFlowLayoutUsed = false
        
        self.moviesCollectionView.reloadData() {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.moviesCollectionView.collectionViewLayout.invalidateLayout()
                self.moviesCollectionView.setCollectionViewLayout(self.listFlowLayout, animated: true)
            }, completion: { (Bool) in
                UIApplication.shared.endIgnoringInteractionEvents()
            })
            
        }
        
    }
    
    func loadGridView() {
        isGridFlowLayoutUsed = true
        self.moviesCollectionView.reloadData() {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.moviesCollectionView.collectionViewLayout.invalidateLayout()
                self.moviesCollectionView.setCollectionViewLayout(self.gridFlowLayout, animated: true)
            }, completion: { (Bool) in
                UIApplication.shared.endIgnoringInteractionEvents()
            })
            
        }
    }

}

//extension UIView {
//    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
//        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
//            self.alpha = 1.0
//        }, completion: completion)  }
//    
//    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
//        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
//            self.alpha = 0.0
//        }, completion: completion)
//    }
//    
//    
//}

extension UICollectionView {
    func load(layout: UICollectionViewLayout, _ duration: TimeInterval = 0.4, delay: TimeInterval = 0, damping: CGFloat = 0.8, velocity: CGFloat = 0.4, options: UIViewAnimationOptions = UIViewAnimationOptions.curveEaseInOut, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        self.reloadData {
           UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: {
            self.collectionViewLayout.invalidateLayout()
            self.setCollectionViewLayout(layout, animated: true)
        }, completion: { (Bool) in
            UIApplication.shared.endIgnoringInteractionEvents()
        }) 
        }
    }
}



