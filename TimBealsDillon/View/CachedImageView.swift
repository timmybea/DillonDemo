//
//  CachedImageView.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-04.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

//MARK: UIImage Cache Extension
extension UIImage {
    
    static let imageCache = NSCache<AnyObject, UIImage>()
    
    static func cacheImage(from artKey: String, completion: @escaping (UIImage?) -> ()) {
        
        APIService.fetchData(with: .artwork(artKey: artKey)) { (data, error) in
            
            guard error == nil else {
                completion(nil)
                return
            }
            
            guard let currData = data else {
                completion(nil)
                return
            }
            
            guard let image = UIImage(data: currData) else {
                completion(nil)
                return
            }

            imageCache.setObject(image, forKey: artKey as AnyObject)
            completion(image)
        }
    }
}

//MARK: CachedImageView
class CachedImageView: UIImageView {
    
    private var imageEndPoint: String?
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()
 
}

//MARK: CachedImageView Public Methods
extension CachedImageView {
 
    func loadImage(from endPoint: String, with renderingMode: UIImage.RenderingMode?) {
        
        func setImage(_ image: UIImage) {
            var image = image
            
            if let rend = renderingMode {
                image = image.withRenderingMode(rend)
            }
            
            DispatchQueue.main.async {
                self.image = image
                self.activityIndicatorView.stopAnimating()
            }
        }
        
        self.imageEndPoint = endPoint
        
        if let imageFromCache = UIImage.imageCache.object(forKey: endPoint as AnyObject) {
            setImage(imageFromCache)
            return
        }
        
        UIImage.cacheImage(from: endPoint) { (image) in
            guard let imageFromCache = image else {
                return
            }
            setImage(imageFromCache)
        }
    }
    
    override func layoutSubviews() {
        self.layer.masksToBounds = true
        
        activityIndicatorView.removeFromSuperview()
        
        addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                     activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)])
        
        if self.image == nil {
            activityIndicatorView.startAnimating()
        }
    }
}
