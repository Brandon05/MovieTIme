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
import ChameleonFramework
import QuartzCore


class MoviesViewController: UIViewController, UIScrollViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, CoreData {

    @IBOutlet var moviesTableView: UITableView!
    @IBOutlet var moviesCollectionView: UICollectionView!
    
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
    
    let color = Colors()
    
    //let nav = UINavigationController(rootViewController: MoviesViewController())
    
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
    var switchButton: UIBarButtonItem!
    var switchButtonMaterial = MaterialButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //deleteRecords()
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        deleteRecords()
        clearDefaults()
        
        //refreshRingView?.arcs[0].setProgress(progress: 1, duration: 0.1)
        
        //self.navigationItem.setRightBarButton(switchButton, animated: true)
        
        concentricProgressRing()
        
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        
        // add refresh control to table view
        moviesCollectionView.insertSubview(refreshControl, at: 0)
        //moviesCollectionView.backgroundColor = UIColor.white
        initiateSearchController()
        searchController.searchBar.delegate = self
        
        // Must register nib to use them
        moviesCollectionView.register(GridCell.self)
        moviesCollectionView.register(ListCell.self)
        
        // Set Default Layout for CollectionView
        moviesCollectionView.load(layout: gridFlowLayout)
        //moviesCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        changeSwitchButton(with: #imageLiteral(resourceName: "listIcon"))
        configureViewColors()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getMovies(fromService: MovieService(endpoint: endpoint))
        searchController.searchBar.text = ""
        searchController.dismiss(animated: true, completion: nil)
        
        self.navigationController?.navigationBar.topItem?.titleView = searchController.searchBar
        switchButtonMaterial.addTarget(self, action: #selector(MoviesViewController.onSwitch(_:)), for: UIControlEvents.valueChanged)
        switchButtonMaterial.backgroundColor = UIColor.flatRed
        switchButtonMaterial.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        switchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "gridIcon"), style: .plain, target: self, action: #selector(onSwitch(_:)))
        let switchButtonCustom = UIBarButtonItem(customView: switchButtonMaterial)
        //switchButton.customView = switchButtonMaterial
        changeSwitchButton(with: #imageLiteral(resourceName: "listIcon"))
//        self.navigationItem.rightBarButtonItem  = switchButton
        //self.navigationController?.navigationBar.topItem?.setRightBarButton(switchButton, animated: true)
        //addFadeLayer()
    }
    
    func changeSwitchButton(with image: UIImage) {
        let switchButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(onSwitch(_:)))
        //self.navigationItem.rightBarButtonItem  = switchButton
        self.navigationController?.navigationBar.topItem?.setRightBarButton(switchButton, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //loadCustomRefresh()
        refreshRingViewSet = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addFadeLayer()
    }
    
    // Collection View Colors
    func configureViewColors() {
        // Collectionview
        moviesCollectionView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: self.view.frame, andColors: [Colors().primaryColor!, Colors().secondaryColor!])
        searchController.searchBar.tintColor = color.secondaryColor?.lighten(byPercentage: 0.5)
        var textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        searchController.searchBar.setSearchColor()
        searchController.searchBar.setSerchTextcolor(color: UIColor.flatWhite)
        
        textFieldInsideSearchBar?.textColor = UIColor.flatWhite
        textFieldInsideSearchBar?.backgroundColor = color.secondaryColor
        
        // Navbar
        self.navigationController?.navigationBar.tintColor = Colors().secondaryColor// items
        //self.navigationController?.navigationBar.barTintColor = color.primaryColor
        
        //Tab bar
        self.tabBarController?.tabBar.tintColor = Colors().primaryColor
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor.flatWhite
        //self.tabBarController?.tabBar.barTintColor = color.secondaryColor
    }
    
    func addFadeLayer() {
        if (self.moviesCollectionView.layer.mask == nil) {
            
            //If you are using auto layout
            //self.view.layoutIfNeeded()
            
            let maskLayer: CAGradientLayer = CAGradientLayer()
            
            maskLayer.locations = [0.0,0.1,0.8,0.85]
            let width = self.moviesCollectionView.frame.size.width
            let height = self.moviesCollectionView.frame.size.height
            maskLayer.bounds = CGRect(x: 0.0, y: 0.0, width: width, height: height)
            maskLayer.anchorPoint = CGPoint.zero // Swift 3.0 update
            
            self.moviesCollectionView.layer.mask = maskLayer
        }
        
        scrollViewDidScroll(self.moviesCollectionView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let outerColor = UIColor(white: 1.0, alpha: 0.0).cgColor
        let innerColor = UIColor(white: 1.0, alpha: 1.0).cgColor
        
        var colors = [AnyObject]()
        
        if (scrollView.contentOffset.y+scrollView.contentInset.top <= 0) {
            colors = [innerColor, innerColor, innerColor, outerColor]
        }else if (scrollView.contentOffset.y+scrollView.frame.size.height >= scrollView.contentSize.height){
            colors = [outerColor, innerColor, innerColor, innerColor]
        }else{
            colors = [outerColor, innerColor, innerColor, outerColor]
        }
        if colors != nil {
        (scrollView.layer.mask as! CAGradientLayer).colors = colors
            
        } else {
            print(colors)
            print(colors)
        }
        
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        scrollView.layer.mask?.position = CGPoint(x: 0.0, y: scrollView.contentOffset.y)
        CATransaction.commit()
    }
    
    // MARK: - Switch button between grid and list
    
    func onSwitch(_ sender: Any) {
        
            if(self.isGridFlowLayoutUsed){
                self.isGridFlowLayoutUsed = false
                UIApplication.shared.beginIgnoringInteractionEvents()
                self.moviesCollectionView.load(layout: listFlowLayout)
                changeSwitchButton(with: #imageLiteral(resourceName: "gridIcon"))
            } else {
                self.isGridFlowLayoutUsed = true
                UIApplication.shared.beginIgnoringInteractionEvents()
                self.moviesCollectionView.load(layout: gridFlowLayout)
                changeSwitchButton(with: #imageLiteral(resourceName: "listIcon"))

            }
    }
    
    func didTap(_ sender: UICollectionViewCell) {
        performSegue(withIdentifier: "DetailSegue", sender: sender.superview)
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

extension UISearchBar {
    public func setSerchTextcolor(color: UIColor) {
        let clrChange = subviews.flatMap { $0.subviews }
        guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
        sc.textColor = color
        UISearchBar.appearance().setImage(#imageLiteral(resourceName: "searchIcon"), for: UISearchBarIcon.search, state: UIControlState.normal)
    }
    
    func setSearchColor() {
        let placeholderAttributes: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.flatWhite, NSFontAttributeName: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
        let attributedPlaceholder: NSAttributedString = NSAttributedString(string: "Search Movies", attributes: placeholderAttributes)
        let textFieldPlaceHolder = self.value(forKey: "searchField") as? UITextField
        textFieldPlaceHolder?.attributedPlaceholder = attributedPlaceholder
    }
}

struct Colors {
    var primaryColor = UIColor(hexString: "#4e69ac")
    var secondaryColor = UIColor(hexString: "#70a5d9")
    var white = UIColor(hexString: "#Fbfcfb")
}
