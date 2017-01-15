//
//  NetworkRequest.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 1/15/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

struct MovieService: Gettable {
    
    func get(completionHandler: @escaping (Result<[Movie]>) -> Void) {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            var movies: [Movie] = []
            
            guard let data = data,
                let dataDictionary = try!JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary,
                let results = dataDictionary["results"] as? [NSDictionary]
                else { fatalError() }
            
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


