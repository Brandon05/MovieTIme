//
//  ListCell.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 2/5/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit
import AlamofireImage
import ChameleonFramework

class ListCell: UICollectionViewCell {

    @IBOutlet var baseView: MaterialCard!
    
    @IBOutlet var moviePosterImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var voteAverageLabel: UILabel!
    
    @IBOutlet var voteCountLabel: UILabel!

    @IBOutlet var releaseDate: UILabel!
    
    @IBOutlet var segueImageView: UIImageView!
    
    @IBOutlet var descriptionTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureCell()
    }
    
    var movie: Movie! {
        didSet {
            moviePosterImageView.af_setImage(withURL: URL(string: movie.posterPath)!)
            titleLabel.text = movie.title
            //descriptionLabel.text = movie.overview
            voteAverageLabel.text = String(movie.voteAverage)
            voteCountLabel.text = String(movie.voteCount)
            segueImageView.image = #imageLiteral(resourceName: "segueIconLarge")
        }
    }
    
    func bind(_ movie: Movie) -> Self {
        moviePosterImageView.af_setImage(withURL: URL(string: movie.posterPath)!)
        titleLabel.text = movie.title
        //descriptionLabel.text = movie.overview
        voteAverageLabel.text = String(movie.voteAverage)
        voteCountLabel.text = String(movie.voteCount)
        segueImageView.image = #imageLiteral(resourceName: "trailerIcon")
        descriptionTextView.text = movie.overview
        descriptionTextView.backgroundColor = Colors().secondaryColor
        
        
        return self
    }
    
    func configureCell() {
        baseView.backgroundColor = Colors().secondaryColor
//        baseView.clipsToBounds = true
        moviePosterImageView.clipsToBounds = true
        moviePosterImageView.layer.cornerRadius = 6
//        let shadowPath = UIBezierPath(rect: baseView.bounds).cgPath
//        baseView.layer.shadowColor = UIColor.black.cgColor
//        baseView.layer.shadowOffset = CGSize(width: 3, height: 3)
//        baseView.layer.shadowOpacity = 0.6
//        baseView.layer.masksToBounds = false
//        baseView.layer.shadowPath = shadowPath
//        baseView.layer.shadowRadius = 6
        voteCountLabel.addTextColor()
        voteAverageLabel.addTextColor()
        releaseDate.addTextColor()
        descriptionTextView.colorAndShadow()
        
//        let colorFromImage = ColorsFromImage(moviePosterImageView.image!, withFlatScheme: true)
//        let gradient = GradientColor(.topToBottom, frame: baseView.frame, colors: [colorFromImage[0], colorFromImage[1]])
//        baseView.backgroundColor = gradient
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        let colorFromImage = ColorsFromImage(moviePosterImageView.image!, withFlatScheme: true)
//        let gradient = GradientColor(.topToBottom, frame: baseView.frame, colors: [colorFromImage[0], colorFromImage[1]])
//        baseView.backgroundColor = gradient

    }
}
