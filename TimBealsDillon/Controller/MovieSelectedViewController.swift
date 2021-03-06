//
//  MovieSelectedViewController.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-04.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

//MARK: MovieSelectedViewController Properties
class MovieSelectedViewController: UIViewController {
    
    var movieSelectedViewModel: MovieSelectedViewModel?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    @IBOutlet weak var videoPlayerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoPlayerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var movieInfoTextView: UITextView!

    @IBAction func cancelButtonTouched(_ sender: UIButton) {
        videoPlayerView.pauseVideo()
        UIView.animate(withDuration: 0.3, animations: {
            self.videoPlayerView.alpha = 0.0
            self.movieInfoTextView.alpha = 0.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                sender.alpha = 0
            }, completion: { _ in
                self.navigationController?.popViewController(animated: true)
            })
        })
    }
}

//MARK: Lifecycle Methods
extension MovieSelectedViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.videoPlayerView.alpha = 0.0
        self.movieInfoTextView.alpha = 0.0
    }
    
    override func viewWillLayoutSubviews() {
        setBackgroundImage()
        setConstraintsForVideoPlayer()
        setupMovieInfoTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let path = movieSelectedViewModel?.movieURLString else { return }
        videoPlayerView.addVideo(with: path)
        
        UIView.animate(withDuration: 0.6, animations: {
            self.videoPlayerView.alpha = 1.0
            self.movieInfoTextView.alpha = 1.0
        })
    }
}

//MARK: MovieSelectedViewController Methods
extension MovieSelectedViewController {
    
    func setConstraintsForVideoPlayer() {
        let isPortrait = UIScreen.main.bounds.width < UIScreen.main.bounds.height
        let height: CGFloat = isPortrait ? (view.bounds.width / 4.0) * 3.0 : min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
        let top: CGFloat = isPortrait ? 8.0 : 0.0
        videoPlayerHeightConstraint.constant = height
        videoPlayerTopConstraint.constant = top
        videoPlayerView.layoutSubviews()
    }
    
    func setBackgroundImage() {
        let isPortrait = UIScreen.main.bounds.width < UIScreen.main.bounds.height
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

//MARK: MovieSelectedViewController Scaling Protocol (Transition)
extension MovieSelectedViewController : Scaling {
    
    func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView? {
        return self.backgroundImageView
    }
    
}
