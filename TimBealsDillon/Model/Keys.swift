//
//  TitleJSONKeys.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-05.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import Foundation

//MARK: Sender Keys
enum SenderKeys: String {
    case movie
    case image
}

//MARK: Segue Identifiers
enum SegueIdentifiers {
    case movieSelected
    
    var string: String {
        switch self {
        case .movieSelected: return "MovieSelected"
        }
    }
}

//MARK: JSON Keys
enum TitleJSONKeys: String {
    case synopsis
    case genres
    case artists
    case name
}


