//
//  HomeViewControllerViewModel.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-05.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import Foundation

//MARK: HomeViewControllerViewModel
struct HomeViewControllerViewModel {
    
    private let movie: Movie
    let title: String
    let artKey: String
    
    init(movie: Movie) {
        self.movie = movie
        self.title = movie.title
        self.artKey = movie.artKey
    }
    
    func returnMovie() -> Movie {
        return self.movie
    }
    
}
