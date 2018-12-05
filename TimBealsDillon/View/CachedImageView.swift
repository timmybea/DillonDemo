//
//  CachedImageView.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-04.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

extension UIImage {
    
    static let imageCache = NSCache<AnyObject, AnyObject>()
    
    static func cacheImage(from artKey: String, completion: @escaping (UIImage?) -> ()) {
        
        var output: UIImage? = nil
        
        APIService.fetchData(with: .artwork(artKey: artKey)) { (data, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let currData = data else {
                return
            }
            
            guard let image = UIImage(data: currData) else {
                return
            }
            
//            DispatchQueue.main.async {
                imageCache.setObject(image, forKey: artKey as AnyObject)
//            }
            
            output = image
            
        }
        completion(output)
    }
}

class CachedImageView: UIImageView {
    
    private var imageEndPoint: String?
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    
    override func layoutSubviews() {
        self.layer.masksToBounds = true
        
        activityIndicatorView.removeFromSuperview()
        
        addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ])
        
        if self.image == nil {
            activityIndicatorView.startAnimating()
        }
    }
    
    func loadImage(from endPoint: String, with renderingMode: UIImage.RenderingMode?) {
        
        self.imageEndPoint = endPoint
        
        func setImage(_ image: UIImage) {
            var img = image
            
            if let rend = renderingMode {
                img = img.withRenderingMode(rend)
            }
            
            DispatchQueue.main.async {
                self.image = img
                self.activityIndicatorView.stopAnimating()
            }
        }
        
        if let imageFromCache = UIImage.imageCache.object(forKey: endPoint as AnyObject) as? UIImage {
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
    
}
