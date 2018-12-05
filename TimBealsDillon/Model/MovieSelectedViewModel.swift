//
//  MovieSelectedViewModel.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-05.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

//MARK: MovieSelectedViewModel Properties and Initializer
struct MovieSelectedViewModel {
    
    private let movie: Movie
    let movieURLString: String
    let movieInfoText: NSAttributedString
    let thumbnailImage: UIImage
    
    init(movie: Movie, thumbnail: UIImage) {
        self.movie = movie
        self.movieURLString = movie.videoURLString
        self.movieInfoText = MovieSelectedViewModel.getMovieInfoText(movie)
        self.thumbnailImage = thumbnail
    }
}

//MARK: MovieSelectedViewModel Static Methods (instance setup)
extension MovieSelectedViewModel {

    private static func getMovieInfoText(_ movie: Movie) -> NSAttributedString {
        let attributedParagraph = AttributedParagraph()
        attributedParagraph.append(text: "\(movie.title)\n\n", font: UIFont.Theme.header.font, alignment: .left)
        if let synopsis = movie.synopsis {
            attributedParagraph.append(text: "\(synopsis)\n\n", font: UIFont.Theme.bodyText.font, alignment: .left)
        }
        attributedParagraph.append(text: "Genres: ", font: UIFont.Theme.subHeader.font, alignment: .left)
        attributedParagraph.append(text: "\(getCommaString(from: movie.genres))\n\n", font: UIFont.Theme.bodyText.font, alignment: .left)
        attributedParagraph.append(text: "Featuring: ", font: UIFont.Theme.subHeader.font, alignment: .left)
        attributedParagraph.append(text: "\(getCommaString(from: movie.artistNames))", font: UIFont.Theme.bodyText.font, alignment: .left)
        return attributedParagraph.attributedText
    }
    
    private static func getCommaString(from list: [String]) -> String {
        
        func addComma() -> String {
            return ", "
        }
        
        var output = ""
        
        for i in 0..<list.count {
            output.append(list[i])
            if i != list.count - 1 {
                output.append(addComma())
            }
        }
        return output
    }
}
