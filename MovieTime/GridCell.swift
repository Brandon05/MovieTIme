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
    
    @IBOutlet var ratingImageView: UIImageView!
    
    @IBOutlet var reviewsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.layoutIfNeeded()
//        
//        configureCell()
//        baseView.layoutIfNeeded()
        //MaterialCard.addPulse(baseView)
//        UIView.animate(withDuration: 0.3, animations: { () -> Void in
//            self.moviePosterImageView.alpha = 1.0
//        })
        configureCell()
    }
    
    var movie: Movie! {
        didSet {
            moviePosterImageView.af_setImage(withURL: URL(string: movie.posterPath)!)
            //titleLabel.text = movie.title
            //descriptionLabel.text = movie.overview
            voteAverageLabel.text = String(movie.voteAverage)
            voteCountLabel.text = String(movie.voteCount)
            segueImageView.image = #imageLiteral(resourceName: "trailerIcon")
            
        }
    }
    
    func bind(_ movie: Movie) -> Self {
        //self.moviePosterImageView.alpha = 0
        moviePosterImageView.af_setImage(withURL: URL(string: movie.posterPath)!)
        //titleLabel.text = movie.title
        //descriptionLabel.text = movie.overview
        voteAverageLabel.text = String(movie.voteAverage)
        voteCountLabel.text = String(movie.voteCount)
        segueImageView.image = #imageLiteral(resourceName: "trailerIcon")
        ratingImageView.image = setRatingImage(for: movie.voteAverage)
        reviewsImageView.image = #imageLiteral(resourceName: "reviews")
        
        return self
    }
    
    func configureCell() {
        //baseView.layoutIfNeeded()
//        baseView.backgroundColor = UIColor.cyan
//        baseView.clipsToBounds = true
//        //baseView.layer.masksToBounds = true
        moviePosterImageView.clipsToBounds = true
        moviePosterImageView.layer.cornerRadius = 6
//        baseView.layer.cornerRadius = 6
//        let shadowPath = UIBezierPath(rect: baseView.bounds).cgPath
//        let shadow = UIBezierPath(roundedRect: baseView.bounds, cornerRadius: 6).cgPath
//        baseView.layer.shadowColor = UIColor.black.cgColor
//        baseView.layer.shadowOffset = CGSize(width: 0, height: 1)
//        baseView.layer.shadowOpacity = 0.6
//        baseView.layer.masksToBounds = false
//        baseView.layer.shadowPath = shadow
//        //baseView.layer.shadowRadius = 10
        voteAverageLabel.colorAndShadow()
        voteCountLabel.colorAndShadow()
        releaseDate.colorAndShadow()
        self.baseView.backgroundColor = Colors().secondaryColor //Colors().primaryColor?.lighten(byPercentage: 2)
    }
    
    func textShadow(onLabel: UILabel) {
        onLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        onLabel.layer.shadowOpacity = 1
        onLabel.layer.shadowRadius = 6
    }
    
//    func setRatingImage(for rating: Double) -> UIImage? {
//        switch rating {
//        case 7.0...10.0:
//            return #imageLiteral(resourceName: "happyImage")
//        case 5.0..<7.0:
//            return #imageLiteral(resourceName: "neutralImage")
//        case 0.0..<5.0:
//            return #imageLiteral(resourceName: "sadImage")
//        default:
//            break
//        }
//        return nil
//    }
    
//    override func layoutSubviews() {
//        //super.layoutSubviews()
//        configureCell()
//        //self.layoutSubviews()
//    }
}

//enum rating {
//    case happy = #imageLiteral(resourceName: "happyImage")
//    case neutral = #imageLiteral(resourceName: "neutralImage")
//    case sad = #imageLiteral(resourceName: "sadImage")
//}

extension UILabel {
    func colorAndShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 6
        self.textColor = Colors().white
    }
}

extension UITextView {
    func colorAndShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 6
        self.textColor = Colors().white
    }
}

extension UICollectionViewCell {
    
    func setRatingImage(for rating: Double) -> UIImage? {
        switch rating {
        case 7.0...10.0:
            return #imageLiteral(resourceName: "happyImage")
        case 5.0..<7.0:
            return #imageLiteral(resourceName: "neutralImage")
        case 0.0..<5.0:
            return #imageLiteral(resourceName: "sadImage")
        default:
            break
        }
        return nil
    }
    
}
