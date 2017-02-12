//
//  WatchLaterViewController.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 2/9/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit
import CoreData

class WatchLaterViewController: UIViewController {

    @IBOutlet var watchLaterCollectionView: UICollectionView!
    @IBOutlet var searchView: UIView!
    
    var watchLaterAll = [Movie]()
    var watchLaterFiltered = [Movie]()
    var movies = [Movie]()
    
    var gridFlowLayout = GridFlowLayout()
    var listFlowLayout = ListFlowLayout()
    
    var isGridFlowLayoutUsed = true
    
    var searchController: UISearchController!
    //let context = getContext() //(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiateSearchController()
        searchController.searchBar.delegate = self
        
        watchLaterCollectionView.delegate = self
        watchLaterCollectionView.dataSource = self
        watchLaterCollectionView.register(GridCell.self)
        watchLaterCollectionView.register(ListCell.self)
        watchLaterCollectionView.collectionViewLayout = GridFlowLayout()
        watchLaterCollectionView.insertSubview(refreshControl, at: 0)
        watchLaterCollectionView.load(layout: gridFlowLayout)
        
        //watchLaterCollectionView.collectionViewLayout = GridFlowLayout()
        
        
        refreshControl.addTarget(self, action: #selector(WatchLaterViewController.refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchController.searchBar.text = ""
        searchController.dismiss(animated: true, completion: nil)
        getData()
        
        self.navigationController?.navigationBar.topItem?.title = "Watch Later"
        let switchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "gridIcon"), style: .plain, target: self, action: #selector(onSwitch(_:)))
        self.navigationItem.rightBarButtonItem  = switchButton
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = switchButton
        //self.watchLaterCollectionView.load(layout: gridFlowLayout)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        //refreshRingView?.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.flatBlack
        getData()
        
    }
    
    func onSwitch(_ sender: Any) {
        
        if(self.isGridFlowLayoutUsed){
            self.isGridFlowLayoutUsed = false
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.watchLaterCollectionView.load(layout: listFlowLayout)
            watchLaterCollectionView.reloadData()
        } else {
            self.isGridFlowLayoutUsed = true
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.watchLaterCollectionView.load(layout: gridFlowLayout)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
