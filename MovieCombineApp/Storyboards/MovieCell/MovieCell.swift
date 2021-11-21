//
//  MovieCell.swift
//  CombineMovieApp
//
//  Created by Amr Ali on 21/11/2021.
//

import UIKit
import SDWebImage

class MovieCell: UITableViewCell {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieDesc: UILabel!
    
    var movieObject: Result!{
        didSet {
            setupData()
        }
    }
    
    func setupData(){
        guard let unwrappedMovieName = movieObject.title,
            let unwrappedMovieDetails = movieObject.resultDescription
        else { return }
        
        movieName.text = unwrappedMovieName
        movieDesc.text = unwrappedMovieDetails
        
        if let unwrappedMovieImage = movieObject.image,
           let imageURL = URL(string: unwrappedMovieImage) {
            movieImage.activateSdWebImageLoader()
            movieImage.sd_setImage(with: imageURL, completed: nil)
        } else {
            movieImage.image = UIImage(named: "placeholder-image")
        }
    }
    
}
