//
//  DetailViewExtensions.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 2/9/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation
import UIKit

extension DetailViewController {

    func youtube(movieID: String) {
        
        //let id = movieID!
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(apiKey)&language=en-US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            var movies: [Movie] = []
            
            guard let data = data,
                let dataDictionary = try!JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary,
                let results = dataDictionary["results"] as? [NSDictionary],
                let movieKey = results[0]["key"] as? String
                else { fatalError(error as! String) }
            
            
            let youtubeBaseUrl = "https://www.youtube.com/embed/\(movieKey)"
            
            self.youtubeWebView.allowsInlineMediaPlayback = true
            self.youtubeWebView.loadRequest(URLRequest(url: URL(string: youtubeBaseUrl)!))
            //youtubeWebView.loadHTMLString("<iframe width=\"\(youtubeWebView.frame.width)\" height=\"\(youtubeWebView.frame.height)\" src=\"\(youtubeBaseUrl)?&playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
        }
        
        task.resume()
    }
    
    func getRecommendedMovies(movieID: String, completion: @escaping (Result<[Movie]>) -> Void) {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/recommendations?api_key=\(apiKey)&language=en-US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            var movies: [Movie] = []
            
            guard let data = data,
                let dataDictionary = try!JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary,
                let results = dataDictionary["results"] as? [NSDictionary]
                //let movieKey = results[0]["key"] as? String
                else { fatalError(error as! String) }
            
            for case let result in results {
                if let movie = Movie(dictionary: result) {
                    movies.append(movie)
                }
                
                completion(Result.success(movies))
            }
            
        }
        task.resume()
    }
    
}
