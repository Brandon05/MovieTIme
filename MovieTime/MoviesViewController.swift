//
//  MoviesViewController.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 1/15/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit
import ConcentricProgressRingView

class MoviesViewController: UIViewController, UIScrollViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var moviesTableView: UITableView!
    @IBOutlet var moviesCollectionView: UICollectionView!
    
    var isGridFlowLayoutUsed = true
    
    // MARK:- Variables
    var gridFlowLayout = GridFlowLayout()
    var listFlowLayout = ListFlowLayout()
    
    let gridCell = UINib(nibName: "GridCell", bundle: nil)
    let listCell = UINib(nibName: "ListCell", bundle: nil)
    
    var progressRingView: ConcentricProgressRingView?
    var refreshRingView: ConcentricProgressRingView?
    var refreshRingViewSet = false
    
    var filteredData: [Movie]!
    
    var searchController: UISearchController!
    
    var endpoint: String!
    
    var movies = [Movie]() {
        
        didSet {
            self.refreshRingView?.arcs[1].strokeColor = UIColor.green.cgColor
            refreshRingView?.arcs[1].setProgress(progress: 1, duration: 0.5)
            let when = DispatchTime.now() + 0.35
            DispatchQueue.main.asyncAfter(deadline: when) {
            self.moviesCollectionView.reloadData()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
                self.refreshRingView?.arcs[1].strokeColor = UIColor.clear.cgColor
                
                }
            }
        }
    }
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        
        concentricProgressRing()
        print("viewDidLoad")
        
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        
        // add refresh control to table view
        moviesCollectionView.insertSubview(refreshControl, at: 0)
        moviesCollectionView.backgroundColor = UIColor.white
        initiateSearchController()
        searchController.searchBar.delegate = self
        // Do any additional setup after loading the view.
        
        // Must register nib to use them
        self.moviesCollectionView.register(gridCell, forCellWithReuseIdentifier: "gridCell")
        self.moviesCollectionView.register(listCell, forCellWithReuseIdentifier: "listCell")
        
        //setupInitialLayout() // collection view initializes blank, loadGridView causes autolayout loop onSwitch
        loadGridView()
    }
    
    // MARK: - Switch button between grid and list
    
    @IBAction func onSwitch(_ sender: Any) {
//        self.collectionView.scrollToTop(animated: false, completion: { })
        
            if(self.isGridFlowLayoutUsed){
                self.isGridFlowLayoutUsed = false
                //UIApplication.shared.beginIgnoringInteractionEvents()
                self.loadListView()
                //fadeOutGrid()
            } else {
                self.isGridFlowLayoutUsed = true
                //UIApplication.shared.beginIgnoringInteractionEvents()
                //self.fadeOutList()
                loadGridView()
            }
    }
    
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
                
            })

        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getMovies(fromService: MovieService(endpoint: endpoint))
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadCustomRefresh()
        refreshRingViewSet = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //refreshLoadingView.removeFromSuperview()
    }
    
    func initiateSearchController() {
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense. Should probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        //moviesCollectionView.tableHeaderView = searchController.searchBar
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
    }
    
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        guard filteredData != nil else {return}
        
        let data = filteredData
        if let searchText = searchController.searchBar.text {
            
            guard !searchText.isEmpty else {
                return
            }
            
            let titles = movies.flatMap {$0.title}

            let options = NSString.CompareOptions.caseInsensitive
            filteredData = movies.filter {
                return $0.title.range(of: searchController.searchBar.text!, options: options) != nil
            }
            print(filteredData)
            moviesCollectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard movies != nil else {fatalError("onCancel: movies is nil")}
        filteredData = movies
        moviesCollectionView.reloadData()
    }
    
    func concentricProgressRing() {
        let fgColor1 = UIColor.red
        let bgColor1 = UIColor.clear
//        let fgColor2 = UIColor.green
//        let bgColor2 = UIColor.clear
        
        let rings = [
            ProgressRing(color: fgColor1, backgroundColor: bgColor1, width: 15),
            //ProgressRing(color: fgColor2, backgroundColor: bgColor2, width: 30),
            ]
        
        let margin: CGFloat = 5
        let radius: CGFloat = 100
        progressRingView = ConcentricProgressRingView(center: view.center, radius: radius, margin: margin, rings: rings)
        
        view.addSubview(progressRingView!)
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
        refreshRingView = ConcentricProgressRingView(center: refreshLoadingView.center, radius: radius, margin: margin, rings: rings)
        print(refreshLoadingView.isDescendant(of: refreshControl))
        refreshLoadingView.backgroundColor = UIColor.clear
        refreshLoadingView.addSubview(refreshRingView!)
        refreshControl.addSubview(refreshLoadingView)
        print(refreshLoadingView.isDescendant(of: refreshControl))
        refreshLoadingView.clipsToBounds = true
        refreshControl.tintColor = UIColor.clear
        refreshControl.backgroundColor = UIColor.white
        refreshRingView?.arcs[1].setProgress(progress: 0, duration: 0)
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        //refreshRingView?.backgroundColor = UIColor.clear
        //refreshControl.tintColor = UIColor.clear
        getMovies(fromService: MovieService(endpoint: endpoint))
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.refreshRingView?.arcs[1].strokeColor = UIColor.clear.cgColor
        self.refreshRingView?.arcs[1].setProgress(progress: 0, duration: 0)
    }
    
    // variable to save the last position visited, default to zero
    private var lastContentOffset: CGFloat = 0
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = (scrollView.contentOffset.y * -1)
        
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            // move up
            //print("HERE!!!")
            
        
        switch offset {
        case 0...15:
            refreshRingView?.arcs[0].setProgress(progress: 0.5, duration: 0.1)
        case 15...25:
            refreshRingView?.arcs[0].setProgress(progress: 0.1, duration: 0.1)
        case 25...40:
            refreshRingView?.arcs[0].setProgress(progress: 0.2, duration: 0.1)
        case 40...45:
            refreshRingView?.arcs[0].setProgress(progress: 0.3, duration: 0.1)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard filteredData != nil else {return movies.count}
        
        return filteredData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? movieCell
        else {
            fatalError("Could not dequeue cell with identifier: movieCell")
        }
        
        if filteredData != nil {
            cell.movie = filteredData[indexPath.row]
        } else {
            cell.movie = movies[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        //let indexPath = moviesCollectionView.indexPathsForSelectedItems
        
        guard let movie = movies[(cell.tag)] as? Movie else {print("error passing data")}
        
        let detailViewController = segue.destination as! DetailViewController
        
        if filteredData != nil {
            detailViewController.movie = filteredData[cell.tag]
        } else {
            detailViewController.movie = movies[(cell.tag)]
        }
        
//        if segue.identifier == "DetailSegue" {
//            let detailsVC = segue.destination as! DetailViewController
//            guard let cell = sender as? UICollectionViewCell,
//                let indexPath = moviesCollectionView.indexPathForItem(at: cell) else {return}
//                // use indexPath
//                detailsVC.movieTitle = movies[indexPath.row].movieTitle!
//            
//        }

        
        
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}

private extension MoviesViewController {
    func getMovies<Service: Gettable>(fromService service: Service) where Service.data == [Movie] {
        
        for ring in (progressRingView?.arcs)! {
            ring.setProgress(progress: 0.5, duration: 2)
        }
        
        let when = DispatchTime.now() + 0.8
        
        // the get funciton is called here
        service.get() { [weak self] result in
            switch result {
            case .success(let movies):
                //print(movies)
                self?.filteredData = movies
                self?.removeProgressRing()
                DispatchQueue.main.asyncAfter(deadline: when) {
                    // Your code with delay
                    self?.progressRingView?.removeFromSuperview()
                    self?.movies = movies
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func removeProgressRing() {
        for ring in (self.progressRingView?.arcs)! {
            ring.setProgress(progress: 1, duration: 0.3)
        }
        
    }
}

// MARK: - UICollectionView Methods

extension MoviesViewController {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard filteredData != nil else {return movies.count}
        
        return filteredData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        var identifier: String
        
        
        /*
         Determine the nib file to load
         - Returns: The cell loaded from its nib file.
         */
        if isGridFlowLayoutUsed == false {
            
            identifier = "listCell"
            
            let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ListCell
            
            // Set width constraint
            //let cellWidth = collectionView.frame.width - 10
            //cell2.cellWidth.constant = collectionView.frame.width - 10
            
            cell = listCell
            if filteredData != nil {
                listCell.movie = filteredData[indexPath.row]
            } else {
                listCell.movie = movies[indexPath.row]
            }
            
        } else {
            
            identifier = "gridCell"
            let gridCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! GridCell
            
            // Set width constraint
//            let cellWidth = (collectionView.frame.width/2) - 20
//            cell1.cellWidth.constant = cellWidth
            
            cell = gridCell
            if filteredData != nil {
                gridCell.movie = filteredData[indexPath.row]
            } else {
                gridCell.movie = movies[indexPath.row]
            }
        }
        moviesCollectionView.setNeedsLayout()
        moviesCollectionView.layoutIfNeeded()
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = moviesCollectionView.cellForItem(at: indexPath)
//        cell?.tag = indexPath.row
//        DispatchQueue.main.async {
//            self.performSegue(withIdentifier: "DetailSegue", sender: cell)
//        }
        
    }
}

/*
 Completion handler for reloadData()
 - collection view flow layout is set in completion
 */

extension UICollectionView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
    
    
}

extension UIScrollView {
    func scrollToTop(animated: Bool, completion: @escaping () -> Void) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        UIView.animate(withDuration: 0, animations: { self.setContentOffset(topOffset, animated: animated) })
        { _ in completion() }
    }
}
















