//
//  Movie.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-04.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

//MARK: Movie Properties and Initializers
class Movie: Decodable {
    
    let title: String
    let titleId: Int
    let artKey: String
    var synopsis: String?
    var genres = [String]()
    var artistNames = [String]()
    let videoURLString = "https://wolverine.raywenderlich.com/content/ios/tutorials/video_streaming/foxVillage.m3u8"

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
}

//MARK: Static methods
extension Movie {
    
    static func getNewMovies(completion: @escaping ([Movie]?) -> Void) {
        APIService.fetchData(with: .topTitles) { (data, error) in
            guard error == nil else { return }
            
            if let unwrappedData = data {
                do {
                    let movies = try JSONDecoder().decode([Movie].self, from: unwrappedData)
                    completion(movies)
                } catch {
                    completion(nil)
                }
            }
        }
    }
}

//MARK: Instance Methods
extension Movie {
    
    private func getTitleInfo(for id: Int) {
        APIService.fetchData(with: .title(titleId: id)) { (data, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            guard let jsonDicts = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] else { return }
            guard let unwrappedJson = jsonDicts else { return }
            
            self.synopsis = unwrappedJson[TitleJSONKeys.synopsis.rawValue] as? String
            
            if let genres = unwrappedJson[TitleJSONKeys.genres.rawValue] as? [[String: Any]] {
                for genre in genres {
                    guard let name = genre[TitleJSONKeys.name.rawValue] as? String else { continue }
                    self.genres.append(name)
                }
            }
            
            if let artists = unwrappedJson[TitleJSONKeys.artists.rawValue] as? [[String : Any]] {
                for artist in artists {
                    guard let name = artist[TitleJSONKeys.name.rawValue] as? String else { continue}
                    self.artistNames.append(name)
                }
            }
        }
    }
}

//MARK: Extension Custom String Convertible
extension Movie : CustomStringConvertible {
    
    var description: String {
        return "Movie: \(title), genre: \(genres), synopsis: \(String(describing: synopsis)), artists: \(artistNames)"
    }
    
}
