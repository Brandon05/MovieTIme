//
//  Movie.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 1/15/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation

struct Movie {
    var title: String
    let overview: String
    let imagePath: String
    let voteAverage: Double
    let voteCount: Int
    
}

extension Movie {
    init?(dictionary: NSDictionary){
        guard let title = dictionary["title"] as? String,
            let overview = dictionary["overview"] as? String,
            let imagePath = dictionary["poster_path"] as? String,
            let voteAverage = dictionary["vote_average"] as? Double,
            let voteCount = dictionary["vote_count"] as? Int
            else {
                return nil
        }
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        
        self.title = title
        self.overview = overview
        self.imagePath = baseURL + imagePath
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}
