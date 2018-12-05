//
//  VideoPlayerView.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-05.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit
import AVFoundation

//MARK: VideoPlayerView Properties & Initializer
class VideoPlayerView: UIView {
    
    private var CONTROLS_HEIGHT: CGFloat = 24.0
    private var PAD: CGFloat = 8.0
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var isSettingPlay = true
    
    private let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var videoLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor.lightGray
        slider.maximumTrackTintColor = UIColor.white
        slider.setThumbImage(UIImage.ProjectAssets.sliderThumb.image, for: .normal)
        slider.addTarget(self, action: #selector(handleSliderChangedValue), for: .valueChanged)
        return slider
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    @objc private func handlePausePlayTouch() {
        if isSettingPlay {
            player?.pause()
            isSettingPlay = false
        } else {
            player?.play()
            isSettingPlay = true
        }
    }
    
    @objc private func handleSliderChangedValue() {
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(slider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (_) in })
        }
    }

}

//MARK: UILayout & Overrides
extension VideoPlayerView {
    
    private func setupSubviews() {
        controlsContainerView.frame = self.bounds
        self.addSubview(controlsContainerView)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePausePlayTouch)))

        let blackView = UIView()
        blackView.translatesAutoresizingMaskIntoConstraints = false
        blackView.backgroundColor = UIColor.black
        controlsContainerView.addSubview(blackView)
        NSLayoutConstraint.activate([
            blackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blackView.heightAnchor.constraint(equalToConstant: CONTROLS_HEIGHT)
            ])
        
        controlsContainerView.addSubview(videoLengthLabel)
        NSLayoutConstraint.activate([
            videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -PAD),
            videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            videoLengthLabel.widthAnchor.constraint(equalToConstant: 45),
            videoLengthLabel.heightAnchor.constraint(equalToConstant: CONTROLS_HEIGHT - 2)
            ])
        
        controlsContainerView.addSubview(currentTimeLabel)
        NSLayoutConstraint.activate([
            currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: PAD),
            currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            currentTimeLabel.widthAnchor.constraint(equalToConstant: 45),
            currentTimeLabel.heightAnchor.constraint(equalToConstant: CONTROLS_HEIGHT - 2)
            ])
        
        controlsContainerView.addSubview(slider)
        NSLayoutConstraint.activate([
            slider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor),
            slider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            slider.heightAnchor.constraint(equalToConstant: CONTROLS_HEIGHT)
            ])
    }
    
    func redrawLayers() {
        playerLayer?.frame = self.bounds
    }
}

//MARK: Player logic
extension VideoPlayerView {
    
    func addVideo(with path: String) {
        addPlayer(with: path)
        player?.play()
        player?.pause()
        player?.addObserver(self, forKeyPath: AVPlayer.observableKey.loadedTimeRanges.rawValue, options: .new, context: nil)
        trackVideoProgress()
    }
    
    func pauseVideo() {
        player?.pause()
    }
    
    private func addPlayer(with urlPath: String) {
        let videoURL = NSURL(string: urlPath)!
        player = AVPlayer(url: videoURL as URL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.addSublayer(playerLayer)
        playerLayer.frame = layer.bounds
        bringSubviewToFront(controlsContainerView)
    }
    
    private func trackVideoProgress() {
        let interval = CMTime(value: 1, timescale: 2)
        player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            self.currentTimeLabel.text = String.duration(from: progressTime)
            if let player = self.player {
                self.slider.setSliderValue(for: player, progress: progressTime)
            }
        })
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == AVPlayer.observableKey.loadedTimeRanges.rawValue else { return }
        guard let duration = player?.currentItem?.duration else { return }
        videoLengthLabel.text = String.duration(from: duration)
    }

}
