//
//  Custom Refresh.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 2/7/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation
import UIKit
import ConcentricProgressRingView

extension MoviesViewController {
    
    func concentricProgressRing() -> ConcentricProgressRingView {
        
        let rings = [
                    ProgressRing(color: Colors().white!, backgroundColor: UIColor.clear, width: 15),
                    //ProgressRing(color: fgColor2, backgroundColor: bgColor2, width: 30),
                    ]
        
        let margin: CGFloat = 5
        let radius: CGFloat = 100
        let progressRingView = ConcentricProgressRingView(center: view.center, radius: radius, margin: margin, rings: rings)
                
        view.addSubview(progressRingView)
        
        self.progressRingView = progressRingView
        
        return progressRingView
    }

  
    
    func loadCustomRefresh() {
        
        let fgColor1 = UIColor.red
        let bgColor1 = UIColor.clear
        let fgColor2 = UIColor.clear
        let bgColor2 = UIColor.clear
        
        let rings = [
            ProgressRing(color: fgColor1, backgroundColor: bgColor1, width: 2),
            ProgressRing(color: fgColor2, backgroundColor: bgColor2, width: 5),
            ]
        
        let refreshLoadingView = UIView(frame: self.refreshControl.bounds)
        
        let margin: CGFloat = 2
        let radius: CGFloat = 20
        
        
        guard refreshRingViewSet == false else {print("no"); return}
        let refreshRingView = ConcentricProgressRingView(center: refreshControl.center, radius: radius, margin: margin, rings: rings)
        refreshLoadingView.backgroundColor = UIColor.clear
        refreshLoadingView.addSubview(refreshRingView)
        refreshControl.addSubview(refreshRingView)
        refreshLoadingView.clipsToBounds = true
        refreshControl.tintColor = UIColor.clear
        refreshControl.backgroundColor = UIColor.white
        refreshRingView.arcs[1].setProgress(progress: 0, duration: 0)
        
        self.refreshRingView = refreshRingView
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        //refreshRingView?.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.flatBlack
        getMovies(fromService: MovieService(endpoint: endpoint))
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.refreshRingView?.arcs[1].strokeColor = UIColor.clear.cgColor
        self.refreshRingView?.arcs[1].setProgress(progress: 0, duration: 0)
    }
    
    func updateRefreshRing(withValue offset: CGFloat) {
        switch offset {
        case 6...15:
            refreshRingView?.arcs[0].setProgress(progress: 0.05, duration: 0.1)
        case 15...25:
            refreshRingView?.arcs[0].setProgress(progress: 0.08, duration: 0.1)
        case 25...40:
            refreshRingView?.arcs[0].setProgress(progress: 0.15, duration: 0.1)
        case 40...45:
            refreshRingView?.arcs[0].setProgress(progress: 0.28, duration: 0.1)
        case 45...60:
            refreshRingView?.arcs[0].setProgress(progress: 0.4, duration: 0.1)
        case 60...75:
            refreshRingView?.arcs[0].setProgress(progress: 0.5, duration: 0.1)
        case 75...90:
            refreshRingView?.arcs[0].setProgress(progress: 0.6, duration: 0.1)
        case 90...110:
            refreshRingView?.arcs[0].setProgress(progress: 0.7, duration: 0.1)
        case 110...125:
            refreshRingView?.arcs[0].setProgress(progress: 0.8, duration: 0.1)
        case 125...150:
            refreshRingView?.arcs[0].setProgress(progress: 0.9, duration: 0.1)
        case _ where offset > 150:
            refreshRingView?.arcs[0].setProgress(progress: 1, duration: 0.1)
        //
        default: break
        }
    }

}
