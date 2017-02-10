//
//  MoviesViewController.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 1/15/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit
import ConcentricProgressRingView
import MIAlertController
import CoreData


class MoviesViewController: UIViewController, UIScrollViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, CoreData {

    @IBOutlet var moviesTableView: UITableView!
    @IBOutlet var moviesCollectionView: UICollectionView!
    @IBOutlet var searchView: UIView!
    
    var isGridFlowLayoutUsed = true
    
    // MARK:- Variables
    var gridFlowLayout = GridFlowLayout()
    var listFlowLayout = ListFlowLayout()
    
    var progressRingView: ConcentricProgressRingView!
    var refreshRingView: ConcentricProgressRingView?
    
    var refreshRingViewSet = false
    
    var filteredData = [Movie]()
    
    var searchController: UISearchController!
    
    var endpoint: String!
    
    var movies = [Movie]() {
        
        didSet {
            //self.refreshRingView?.arcs[1].strokeColor = UIColor.green.cgColor
            //refreshRingView?.arcs[1].setProgress(progress: 1, duration: 0.5)
            let when = DispatchTime.now() + 0.35
            DispatchQueue.main.asyncAfter(deadline: when) {
            self.filteredData = self.movies
            self.moviesCollectionView.reloadData()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
                //self.refreshRingView?.arcs[1].strokeColor = UIColor.clear.cgColor
                
                }
            }
        }
    }
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //deleteRecords()
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        //refreshRingView?.arcs[0].setProgress(progress: 1, duration: 0.1)
        
        concentricProgressRing()
        
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        
        // add refresh control to table view
        moviesCollectionView.insertSubview(refreshControl, at: 0)
        moviesCollectionView.backgroundColor = UIColor.white
        initiateSearchController()
        searchController.searchBar.delegate = self
        
        // Must register nib to use them
        moviesCollectionView.register(GridCell.self)
        moviesCollectionView.register(ListCell.self)
        
        // Set Default Layout for CollectionView
        moviesCollectionView.load(layout: gridFlowLayout)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getMovies(fromService: MovieService(endpoint: endpoint))
        searchController.searchBar.text = ""
        searchController.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //loadCustomRefresh()
        refreshRingViewSet = true
    }
    
    // MARK: - Switch button between grid and list
    
    @IBAction func onSwitch(_ sender: Any) {
        
            if(self.isGridFlowLayoutUsed){
                self.isGridFlowLayoutUsed = false
                UIApplication.shared.beginIgnoringInteractionEvents()
                self.moviesCollectionView.load(layout: listFlowLayout)
            } else {
                self.isGridFlowLayoutUsed = true
                UIApplication.shared.beginIgnoringInteractionEvents()
                self.moviesCollectionView.load(layout: gridFlowLayout)
            }
    }
    
    // MARK: - Custom Refresh
    
    private var lastContentOffset: CGFloat = 0
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        let offset = (scrollView.contentOffset.y * -1)
        
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            // move up
            //print("\(self.lastContentOffset) vs \(scrollView.contentOffset.y)")
            
            //updateRefreshRing(withValue: offset)
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
        
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
        
    }
    
    func showAlert() {
        
        let myEmoji = "1f625"
        let emoji = String(Character(UnicodeScalar(Int(myEmoji, radix: 16)!)!))
        
        var alert = MIAlertController(
            
            title: "Network Error",
            message: "It seems we can't connect to our network \(emoji)",
            buttons: [
                MIAlertController.Button(title: "Retry", action: {
                    self.getMovies(fromService: MovieService(endpoint: self.endpoint))
                    //self.resignFirstResponder()
                }),
                MIAlertController.Button(title: "Cancel", action: {
                    print("button two tapped")
                })
            ]
            
            ).presentOn(self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        
        guard let movie = movies[(cell.tag)] as? Movie else {print("error passing data")}
        
        let detailViewController = segue.destination as! DetailViewController
        
        if filteredData != nil {
            detailViewController.movie = filteredData[cell.tag]
        } else {
            detailViewController.movie = movies[(cell.tag)]
        }
    }
    

 

}
