//
//  MovieCollectionViewCell.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-04.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cachedImageView: CachedImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let reuseId = "MovieCollectionViewCell"
    
    func configure(with movie: Movie) {
        cachedImageView.contentMode = .scaleAspectFill
        layer.cornerRadius = 10.0
        titleLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        titleLabel.text = movie.title
        cachedImageView.loadImage(from: movie.artKey, with: nil)
        self.layoutIfNeeded()
    }
}
