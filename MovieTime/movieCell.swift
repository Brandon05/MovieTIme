//
//  movieCell.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 1/15/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit
import AlamofireImage

class movieCell: UITableViewCell {

    @IBOutlet var moviePosterImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var voteAverageLabel: UILabel!
    
    @IBOutlet var voteCountLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var movie: Movie! {
        didSet {
            moviePosterImageView.af_setImage(withURL: URL(string: movie.posterPath)!)
            titleLabel.text = movie.title
            descriptionLabel.text = movie.overview
            voteAverageLabel.text = String(movie.voteAverage)
            voteCountLabel.text = String(movie.voteCount)
        }
    }

}
