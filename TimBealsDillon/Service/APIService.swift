//
//  APIService.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-04.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import Foundation

//MARK: APIServiceError
enum APIServiceError: Error {
    case noData
}

//MARK: APIService
struct APIService {
    
    static fileprivate let basePath: String = "https://hoopla-ws.hoopladigital.com/"
    static fileprivate let titlesEndPoint: String = "kinds/7/titles/top"
    static fileprivate let artworkEndPoint: String = "https://d2snwnmzyr8jue.cloudfront.net/"
    
    enum APIURL {
        case topTitles
        case title(titleId: Int)
        case artwork(artKey: String)
        
        var path: String {
            switch self {
            case .topTitles: return APIService.basePath + APIService.titlesEndPoint
            case .title(let titleId): return APIService.basePath + "titles/\(titleId)"
            case .artwork(let artKey): return APIService.artworkEndPoint + "\(artKey)_270.jpeg"
            }
        }
        
        var url: URL? {
            return URL(string: self.path)
        }
    }
    
    static func fetchData(with apiURL: APIURL, completion: @escaping (Data?, Error?) -> ()) {
        guard let url = apiURL.url else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let unwrapData = data else {
                completion(nil, APIServiceError.noData)
                return
            }
            
            completion(unwrapData, nil)
        }.resume()
    }
}
