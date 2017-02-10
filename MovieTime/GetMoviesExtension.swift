//
//  GetMovies Extention.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 2/7/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation

// Is private level access necessary?

extension MoviesViewController {
    func getMovies<Service: Gettable>(fromService service: Service) where Service.data == [Movie] {
        
        for ring in (progressRingView.arcs) {
            ring.setProgress(progress: 0.5, duration: 2)
        }
        
        let when = DispatchTime.now() + 1.2
        
        // the get funciton is called here
        service.get() { [weak self] result in
            switch result {
            case .success(let movies):
                //print(movies)
                self?.filteredData = movies
                self?.removeProgressRing()
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self?.progressRingView.removeFromSuperview()
                    self?.movies = movies
                }
            case .failure(let error):
                print(error)
                self?.showAlert()
            }
        }
    }
    
    func removeProgressRing() {
        for ring in (self.progressRingView.arcs) {
            ring.setProgress(progress: 1, duration: 0.3)
        }
        
    }
}
