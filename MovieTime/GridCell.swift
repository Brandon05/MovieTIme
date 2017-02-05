//
//  GridCell.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 1/30/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit

class GridCell: UICollectionViewCell {

    @IBOutlet var cellWidth: NSLayoutConstraint!
    
    @IBOutlet var moviePosterImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var voteAverageLabel: UILabel!
    @IBOutlet var voteCountLabel: UILabel!
    @IBOutlet var voteCountImageView: UIImageView!
    @IBOutlet var voteAverageImageView: UIImageView!
    @IBOutlet var releaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func prepareForReuse() {
        //super.prepareForReuse()
        //Not sure why: stops autolayout loop
    }
    
    /**
     Allows you to generate a cell without dequeueing one from a table view.
     - Returns: The cell loaded from its nib file.
     */
    class func fromNib() -> GridCell?
    {
        var cell: GridCell?
        let nibViews = Bundle.main.loadNibNamed("GridCell", owner: nil, options: nil)
        for nibView in nibViews! {
            if let cellView = nibView as? GridCell {
                cell = cellView
            }
        }
        return cell
    }
    
    /*
     Configure data from model and set style
     */
    func configureWithIndexPath(_ indexPath: IndexPath)
    {
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.black.cgColor
//        backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    }
    
    var movie: Movie! {
        didSet {
            moviePosterImageView.af_setImage(withURL: URL(string: movie.posterPath)!)
            titleLabel.text = movie.title
            //descriptionLabel.text = movie.overview
            voteAverageLabel.text = String(movie.voteAverage)
            voteCountLabel.text = String(movie.voteCount)
        }
    }

}
