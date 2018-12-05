//
//  MovieSelectedViewController.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-04.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

class MovieSelectedViewController: UIViewController {
    
    var backgroundImage: UIImage?
    var movie: Movie?
    
    @IBOutlet weak var backgroundImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = backgroundImage
    }

    @IBAction func cancelButtonTouched(_ sender: Any) {
        
    }
}

extension MovieSelectedViewController : Scaling {
    
    func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView? {
        return self.backgroundImageView
    }
    
}
