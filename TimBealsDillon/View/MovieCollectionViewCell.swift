//
//  MovieCollectionViewCell.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-04.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

//MARK: MovieCollectionViewCell Properties
class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cachedImageView: CachedImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let reuseId = "MovieCollectionViewCell"
}

//MARK: MovieCollectionViewCell Public Methods
extension MovieCollectionViewCell {
    
    func configure(with homeViewMovieViewModel: HomeViewControllerViewModel) {
        cachedImageView.contentMode = .scaleAspectFill
        cachedImageView.loadImage(from: homeViewMovieViewModel.artKey, with: nil)
        
        titleLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        titleLabel.text = homeViewMovieViewModel.title
        
        layer.cornerRadius = 10.0
        
        self.layoutIfNeeded()
    }
}


