//
//  WatchLaterMovie.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 2/9/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation
import CoreData

@objc(WatchLaterMovie)
class WatchLaterMovie: NSManagedObject {
    @NSManaged var title: String?
    @NSManaged var overview: String?
    @NSManaged var posterPath: String?
    @NSManaged var backdropPath: String?
    @NSManaged var voteAverage: NSNumber?
    @NSManaged var voteCount: NSNumber?
    @NSManaged var id: NSNumber?
    
}

extension WatchLaterMovie {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<WatchLaterMovie> {
            return NSFetchRequest<WatchLaterMovie>(entityName: "WatchLaterMovie");
    }

}
