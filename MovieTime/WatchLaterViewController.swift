//
//  WatchLaterViewController.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 2/9/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit

struct WatchLater {
    
    static var movies = [Movie]()
}

class WatchLaterViewController: UIViewController {

    @IBOutlet var watchLaterCollectionView: UICollectionView!
    @IBOutlet var searchView: UIView!
    
    var watchLater = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        watchLater = WatchLater.movies
        print(watchLater)
        
        watchLaterCollectionView.delegate = self
        watchLaterCollectionView.dataSource = self
        watchLaterCollectionView.register(GridCell.self)
        watchLaterCollectionView.collectionViewLayout = GridFlowLayout()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
