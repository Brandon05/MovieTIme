//
//  GridCell.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 2/5/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit

class GridCell: UICollectionViewCell {

    @IBOutlet var baseView: MaterialCard!
    
    @IBOutlet var moviePosterImageView: UIImageView!
    
    @IBOutlet var voteAverageLabel: UILabel!
    
    @IBOutlet var voteCountLabel: UILabel!
    
    @IBOutlet var releaseDate: UILabel!
    
    @IBOutlet var segueImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.layoutIfNeeded()
//        
//        configureCell()
//        baseView.layoutIfNeeded()
        //MaterialCard.addPulse(baseView)
    }
    
    var movie: Movie! {
        didSet {
            moviePosterImageView.af_setImage(withURL: URL(string: movie.posterPath)!)
            //titleLabel.text = movie.title
            //descriptionLabel.text = movie.overview
            voteAverageLabel.text = String(movie.voteAverage)
            voteCountLabel.text = String(movie.voteCount)
            segueImageView.image = #imageLiteral(resourceName: "segueIconSmall")
            
        }
    }
    
    func configureCell() {
        //baseView.layoutIfNeeded()
        baseView.backgroundColor = UIColor.cyan
        baseView.clipsToBounds = true
        //baseView.layer.masksToBounds = true
        moviePosterImageView.clipsToBounds = true
        moviePosterImageView.layer.cornerRadius = 6
        baseView.layer.cornerRadius = 6
        let shadowPath = UIBezierPath(rect: baseView.bounds).cgPath
        let shadow = UIBezierPath(roundedRect: baseView.bounds, cornerRadius: 6).cgPath
        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.layer.shadowOffset = CGSize(width: 0, height: 1)
        baseView.layer.shadowOpacity = 0.6
        baseView.layer.masksToBounds = false
        baseView.layer.shadowPath = shadow
        //baseView.layer.shadowRadius = 10
    }
    
//    override func layoutSubviews() {
//        //super.layoutSubviews()
//        configureCell()
//        //self.layoutSubviews()
//    }
}
