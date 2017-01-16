//
//  MoviesViewController.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 1/15/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit
import ConcentricProgressRingView

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var moviesTableView: UITableView!
    
    var progressRingView: ConcentricProgressRingView?
    
    var movies = [Movie]() {
        didSet {
            moviesTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        
        concentricProgressRing()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getMovies(fromService: MovieService())
        
    }
    
    func concentricProgressRing() {
        let fgColor1 = UIColor.yellow
        let bgColor1 = UIColor.darkGray
        let fgColor2 = UIColor.green
        let bgColor2 = UIColor.darkGray
        
        let rings = [
            ProgressRing(color: fgColor1, backgroundColor: bgColor1, width: 18),
            ProgressRing(color: fgColor2, backgroundColor: bgColor2, width: 18),
            ]
        
        let margin: CGFloat = 2
        let radius: CGFloat = 80
        progressRingView = ConcentricProgressRingView(center: view.center, radius: radius, margin: margin, rings: rings)
        
        view.addSubview(progressRingView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //guard movies != nil else {return 0}
        
        return movies.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? movieCell
        else {
            fatalError("Could not dequeue cell with identifier: movieCell")
        }
        
        cell.movie = movies[indexPath.row]
        
        return cell
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

private extension MoviesViewController {
    func getMovies<Service: Gettable>(fromService service: Service) where Service.data == [Movie] {
        //animateProgressRing()
        
        
        for ring in (progressRingView?.arcs)! {
            ring.setProgress(progress: 0.5, duration: 2)
            print("first loop")
        }
        
        let when = DispatchTime.now() + 0.8
        // the get funciton is called here
        service.get() { [weak self] result in
            switch result {
            case .success(let movies):
                print(movies)
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
            print("here")
        }
//        let when = DispatchTime.now() + 0.8 // change 2 to desired number of seconds
//        DispatchQueue.main.asyncAfter(deadline: when) {
//            // Your code with delay
//            self.removeRings()
//        }
        
    }
}














