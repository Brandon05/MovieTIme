//
//  MoviesViewController.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 1/15/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var moviesTableView: UITableView!
    
    var movies = [Movie]() {
        didSet {
            moviesTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        getMovies(fromService: MovieService())
        // Do any additional setup after loading the view.
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
        
        cell.textLabel?.text = "row \(movies[indexPath.row].title)"
        
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

extension MoviesViewController {
    func getMovies<Service: Gettable>(fromService service: Service) where Service.data == [Movie] {
        // the get funciton is called here
        service.get() { [weak self] result in
            switch result {
            case .success(let movies):
                print(movies)
                self?.movies = movies
            case .failure(let error):
                print(error)
            }
        }
    }
}














