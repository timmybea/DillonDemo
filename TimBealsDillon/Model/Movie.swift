//
//  Movie.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-04.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

class Movie: Decodable {
    
    let title: String
    let titleId: Int
    let artKey: String
    var synopsis: String?
    var genres = [String]()
    var artistNames = [String]()
    
    enum MovieKeys: String, CodingKey {
        case title, titleId, artKey
    }

    required convenience init(from decoder: Decoder) throws {
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
        getTitleInfo(for: titleId)
        
    }
    
    private func getTitleInfo(for id: Int) {
        
        APIService.fetchData(with: .title(titleId: id)) { (data, error) in

            guard error == nil else { return }

            guard let data = data, let jsonDicts = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] else { return }
            guard let unwrappedJson = jsonDicts else { return }
            
            self.synopsis = unwrappedJson["synopsis"] as? String
            if let genres = unwrappedJson["genres"] as? [[String: Any]] {
                for genre in genres {
                    guard let name = genre["name"] as? String else { continue }
                    self.genres.append(name)
                }
            }
            if let artists = unwrappedJson["artists"] as? [[String : Any]] {
                for artist in artists {
                    guard let name = artist["name"] as? String else { continue}
                    self.artistNames.append(name)
                }
            }
            
            print(self)
        }
    }
    
}

extension Movie : CustomStringConvertible {
    
    var description: String {
        return "Movie: \(title), genre: \(genres), synopsis: \(synopsis), artists: \(artistNames)"
    }
    
}
