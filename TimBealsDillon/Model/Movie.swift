//
//  Movie.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-04.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

struct Movie: Decodable {
    
    let title: String
    let titleId: Int
    let artKey: String
    
    enum MovieKeys: String, CodingKey {
        case title, titleId, artKey
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        let titleId = try container.decode(Int.self, forKey: .titleId)
        let artKey = try container.decode(String.self, forKey: .artKey)
        
        self.init(title: title, titleId: titleId, artKey: artKey)
    }
    
    init(title: String, titleId: Int, artKey: String) {
        self.title = title
        self.titleId = titleId
        self.artKey = artKey
        
        UIImage.cacheImage(from: artKey) { (_) in }
    }
}

extension Movie : CustomStringConvertible {
    
    var description: String {
        return "Movie: \(title)"
    }
    
}
