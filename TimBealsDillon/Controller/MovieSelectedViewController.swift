//
//  MovieSelectedViewController.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-04.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

class MovieSelectedViewController: UIViewController {
    
//    var backgroundImage: UIImage?
    
    var movieSelectedViewModel: MovieSelectedViewModel?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    @IBOutlet weak var videoPlayerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var videoPlayerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var movieInfoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
    }
    
    override func viewWillLayoutSubviews() {
        setBackgroundImage()
        setConstraintsForVideoPlayer()
        setupMovieInfoTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let path = movieSelectedViewModel?.movieURLString else { return }
        videoPlayerView.addVideo(with: path)
    }

    @IBAction func cancelButtonTouched(_ sender: UIButton) {
        videoPlayerView.pauseVideo()
        UIView.animate(withDuration: 0.2, animations: {
            sender.alpha = 0
        }, completion: { _ in
            self.navigationController?.popViewController(animated: true)
        })
    }
}

extension MovieSelectedViewController {
    
    func setConstraintsForVideoPlayer() {
        let isPortrait = UIDevice.isPortrait
        let height: CGFloat = isPortrait ? (view.bounds.width / 4.0) * 3.0 : min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
        let top: CGFloat = isPortrait ? 8.0 : 0.0
        videoPlayerHeightConstraint.constant = height
        videoPlayerTopConstraint.constant = top
        videoPlayerView.layoutSubviews()
    }
    
    func setBackgroundImage() {
        let isPortrait = UIDevice.isPortrait
        self.backgroundImageView.backgroundColor = UIColor.black
        backgroundImageView.contentMode = .scaleAspectFill
        self.backgroundImageView.image = isPortrait ? movieSelectedViewModel?.thumbnailImage : nil
    }
    
    
    func setupMovieInfoTextView() {
        movieInfoTextView.textContainer.lineFragmentPadding = 8.0
        movieInfoTextView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        movieInfoTextView.layer.cornerRadius = 10.0
    
        movieInfoTextView.attributedText = movieSelectedViewModel?.movieInfoText
        movieInfoTextView.isEditable = false
    }
    
}

extension MovieSelectedViewController : Scaling {
    
    func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView? {
        return self.backgroundImageView
    }
    
}
