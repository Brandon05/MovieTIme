//
//  NetworkRequest.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 1/15/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation
import MIAlertController

enum Result<T> {
    case success(T)
    case failure(Error)
}

struct MovieService: Gettable {
    
    var endpoint: String
    
    func get(completionHandler: @escaping (Result<[Movie]>) -> Void) {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            var movies: [Movie] = []
            
            guard let data = data,
                let dataDictionary = try!JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary,
                let results = dataDictionary["results"] as? [NSDictionary]
                else {
                //Alert().apiCall()
                completionHandler(Result.failure(error!))
                return
            }
            
            for case let result in results {
                if let movie = Movie(dictionary: result) {
                    movies.append(movie)
                }
                
            }
            
            completionHandler(Result.success(movies))
            
                
            
//            if let data = data {
//                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
//                    if let results = dataDictionary["results"] {
//                    for case let result in dataDictionary["results"] {
//                        
//                    }
//                    }
                    //print(dataDictionary)
                    //completionHandler(Result.success(dataDictionary["results"] as! [NSDictionary]))
//                }
//            }
        }
        
        task.resume()
        // make asynchronous API call
        // and return appropriate result
    }
    
}

protocol Gettable {
    associatedtype data
    
    func get(completionHandler: @escaping (Result<data>) -> Void)
}

struct Alert {
    
    func display() {
        let myEmoji = "1f625"
        let emoji = String(Character(UnicodeScalar(Int(myEmoji, radix: 16)!)!))
        
        var alert = MIAlertController(
            
            title: "Network Error",
            message: "It seems we can't connect to our network \(emoji)",
            buttons: [
                MIAlertController.Button(title: "Retry", action: {
                    //self.getMovies(fromService: MovieService(endpoint: self.endpoint))
                    //self.resignFirstResponder()
                    self.apiCall()
                }),
                MIAlertController.Button(title: "Cancel", action: {
                    print("button two tapped")
                })
            ]
            
            ).presentOn(MoviesViewController())
    }
    
    func apiCall() {
        MovieService(endpoint: "now_playing").get() { result in
            switch result {
            case .success(let movies):
                MoviesViewController().movies = movies
            case .failure(let error): break
                // Show Alert again
            }
        }
    }
}

