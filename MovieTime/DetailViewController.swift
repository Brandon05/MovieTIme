//
//  DetailViewController.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 1/20/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit
import ChameleonFramework
import CoreData

class DetailViewController: UIViewController {
    
    @IBOutlet var watchBackgroundView: MaterialCard!
    @IBOutlet var buyBackgroundView: MaterialCard!
    @IBOutlet var watchLaterButton: UIButton!
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var baseView: UIView!
    @IBOutlet var backdropImageView: UIImageView!
    @IBOutlet var voteCountLabel: UILabel!
    @IBOutlet var voteAverageLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var youtubeWebView: MaterialWebView!
    @IBOutlet var recommendedCollectionView: UICollectionView!
    
    @IBOutlet var voteCountImageView: UIImageView!
    @IBOutlet var ratingImageView: UIImageView!
    
    let defaults = UserDefaults.standard
    var recommendedMovies = [Movie]()
    
    var movie: Movie! {
        didSet {
            print(movie)
            youtube(movieID: String(movie.id))
            getRecommendedMovies(movieID: String(movie.id)) { (result) in
                switch result {
                case .success(let movies):
                    self.recommendedMovies = movies
                    self.recommendedCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.scrollView.bounces = false
        self.view.backgroundColor = colorSheet().alabaster
        self.baseView.backgroundColor = colorSheet().alabaster
        self.scrollView.backgroundColor = colorSheet().alabaster
        self.baseView.translatesAutoresizingMaskIntoConstraints = false
        
        // UI
        setLabelColors(color: Colors().white!)
        setMovieDetails()
        configureViews()
            
        // CollectionView
        recommendedCollectionView.register(GridCell.self)
        recommendedCollectionView.delegate = self
        recommendedCollectionView.dataSource = self
        recommendedCollectionView.backgroundColor = UIColor.clear
        
        // Button Configuration
        buyButton.addTarget(self, action: #selector(DetailViewController.didHold(sender:)), for: UIControlEvents.touchDown)
        buyButton.addTarget(self, action: #selector(DetailViewController.didRelease(sender:)), for: UIControlEvents.touchDown)
        // If movie.id is already saved, do not add target
//        if defaults.bool(forKey: "\(movie.id)") != true {
//        watchLaterButton.addTarget(self, action: #selector(DetailViewController.didSave(sender:)), for: UIControlEvents.touchDown)
//        } else {
//        watchLaterButton.addTarget(self, action: #selector(DetailViewController.didRemove(sender:)), for: UIControlEvents.touchDown)
//        }
        //let saveTarget = watchLaterButton.addTarget(self, action: #selector(DetailViewController.didSave(sender:)), for: UIControlEvents.touchDown)
        defaults.bool(forKey: "\(movie.id)") != true ? addSaveTarget() : addRemoveTarget()
        
        // Do any additional setup after loading the view.
    }
    
    func addSaveTarget() {
        watchLaterButton.removeTarget(self, action: #selector(DetailViewController.didRemove(sender:)), for: UIControlEvents.touchDown)
        watchLaterButton.addTarget(self, action: #selector(DetailViewController.didSave(sender:)), for: UIControlEvents.touchDown)
    }
    
    func addRemoveTarget() {
        watchLaterButton.removeTarget(self, action: #selector(DetailViewController.didSave(sender:)), for: UIControlEvents.touchDown )
        watchLaterButton.addTarget(self, action: #selector(DetailViewController.didRemove(sender:)), for: UIControlEvents.touchDown)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configure(button: buyButton, withTitle: " Tickets ")
        configure(button: watchLaterButton, withTitle: " Watch Later ")
        //self.navigationController?.navigationBar.topItem?.title = "\(movie.title)"
    }
    
    func setMovieDetails() {
        if let movie = movie {
            titleLabel.text = movie.title
            descriptionLabel.text = movie.overview
            //print(descriptionLabel.text)
            voteCountLabel.text = String(movie.voteCount)
            voteAverageLabel.text = String(movie.voteAverage)
            voteCountImageView.image = #imageLiteral(resourceName: "reviews")
            ratingImageView.image = setRatingImage(for: movie.voteAverage)
            
            //backdropImageView.af_setImage(withURL: URL(string: movie.backdropPath)!)
            //backdropImageView.contentMode = .scaleAspectFill
            let url = URL(string: movie.backdropPath)!
            let data = try! Data(contentsOf: url)
            let image = UIImage(data: data)
            let test = CGSize(width: 500, height: 600)
            let resizedImage = image?.af_imageAspectScaled(toFill: test)
            //image?.resizedImageWithinRect(rectSize: test)
            
            backdropImageView.image = image
            backdropImageView.contentMode = .scaleAspectFill
            
            // Image from colors
            let colorsFromMovie = ColorsFromImage(image!, withFlatScheme: true)
            let gradient = GradientColor(.topToBottom, frame: self.view.frame, colors: [colorsFromMovie[2], colorsFromMovie[3], colorsFromMovie[4]]) //
            self.view.backgroundColor = gradient
            self.baseView.backgroundColor = UIColor.clear
            self.scrollView.backgroundColor = UIColor.clear
            //self.navigationController?.navigationBar.tintColor = colorsFromMovie[0]
            print(colorsFromMovie)
            
            // Gradient for backdrop picture
            var imageGradient: CAGradientLayer = CAGradientLayer()
            imageGradient.frame = self.backdropImageView.frame
            imageGradient.colors = [UIColor.clear.cgColor, gradient.cgColor]
            imageGradient.locations = [0.1, 0.9]
            self.backdropImageView.layer.insertSublayer(imageGradient, at: 0)
        }
    }
    
    // MARK:- UI
    func configureViews() {
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.backdropImageView.frame
        gradient.colors = [UIColor.clear.cgColor, Colors().white?.cgColor]
        gradient.locations = [0.1, 0.9]
        //backdropImageView.layer.insertSublayer(gradient, at: 0)
        
        //Material Button
//        buyButton.backgroundColor = UIColor.clear
//        buyButton.setTitle("Tickets", for: [])
//        buyButton.titleLabel?.textColor = UIColor.flatWhite
//        buyBackgroundView.backgroundColor = UIColor.flatRed
        //buyButton.titleColor(for: .selected) = UIColor.flatGray
    
    }
    
    func didHold(sender: UIButton) {
        sender.superview?.backgroundColor = Colors().white?.darken(byPercentage: 0.5)
    }
    
    func didRelease(sender: UIButton) {
        sender.superview?.backgroundColor = Colors().white
    }
    
    func didSave(sender: UIButton) {
        save(self.movie)
        defaults.set(true, forKey: "\(movie.id)")
        sender.superview?.backgroundColor = Colors().white?.darken(byPercentage: 0.5)
        sender.setTitle(" Saved ", for: [])
        UIView.animate(withDuration: 0.2) { 
            sender.layoutIfNeeded()
        }
        //sender.layoutIfNeeded()
        // Remove save target to avoid duplicates
        addRemoveTarget()
//        sender.removeTarget(self, action: #selector(DetailViewController.didSave(sender:)), for: UIControlEvents.touchDown )
//        sender.addTarget(self, action: #selector(DetailViewController.didRemove(sender:)), for: UIControlEvents.touchDown)
    }
    
    func didRemove(sender: UIButton) {
        // Remove from Core Data
        removeData(for: self.movie)
        sender.superview?.backgroundColor = Colors().white
        sender.setTitle(" Watch Later ", for: [])
        UIView.animate(withDuration: 0.2) {
            sender.layoutIfNeeded()
        }
        addSaveTarget()
//        sender.removeTarget(self, action: #selector(DetailViewController.didRemove(sender:)), for: UIControlEvents.touchDown )
//        sender.addTarget(self, action: #selector(DetailViewController.didSave(sender:)), for: UIControlEvents.touchDown)
        defaults.set(false, forKey: "\(movie.id)")
    }
    
    func configure(button: UIButton, withTitle title: String) {
        
        // Check if movie has been saved already
        if title == " Watch Later " && defaults.bool(forKey: "\(movie.id)") == true {
            button.setTitle(" Saved ", for: [])
            button.superview?.backgroundColor = Colors().white?.darken(byPercentage: 0.5)
        } else {
            button.setTitle(title, for: [])
            button.superview?.backgroundColor = Colors().white
        }
        
        button.setTitleColor(Colors().primaryColor, for: .normal)
        button.backgroundColor = UIColor.clear
    }
        
    
    func setLabelColors(color: UIColor) {
        titleLabel.textColor = color
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        descriptionLabel.textColor = color
        voteCountLabel.textColor = color
        voteAverageLabel.textColor = color
    }

    @IBAction func onBuy(_ sender: Any) {
        let movieTitle = movie.title.replacingOccurrences(of: " ", with: "+")
        guard let url = URL(string: "http://www.google.com/search?q=imdb.com/showtimes/+\(movieTitle)+showtimes+&btnI")
            else {return} // Maybe an Alert?
        UIApplication.shared.open(url, options: [:]) { (Bool) in
            
        }
    }
    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK:- Image extention for backdrop image

extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
    /// Note that the new image size is not rectSize, but within it.
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        
        let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
    
}



// Tests
//guard let url = NSURL(string: "http://placehold.it/300x150") else { fatalError("Bad URL") }
//guard let data = NSData(contentsOfURL: url) else { fatalError("Bad data") }
//guard let img = UIImage(data: data) else { fatalError("Bad data") }
//
//let outImageFit = img.resizedImageWithinRect(CGSize(width: 200, height: 200))
//let outImageFill = img.resizedImage(CGSize(width: 200, height: 200))
