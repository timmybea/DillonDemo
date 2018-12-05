//
//  Extensions_UIKit.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-05.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit
import AVFoundation

//MARK: String Extensions
extension String {
    
    static func duration(from time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let secondsText = String(format: "%02d", Int(totalSeconds) % 60)
        let minutesText = String(format: "%02d", Int(totalSeconds) / 60)
        return  "\(minutesText):\(secondsText)"
    }
    
}

//MARK: UIImage Extension
extension UIImage {
    
    enum ProjectAssets {
        case pauseButton
        case playButton
        case sliderThumb
        case closeButton
        
        var imageName: String {
            switch self {
            case .pauseButton: return "pauseButton"
            case .playButton: return "playButton"
            case .sliderThumb: return "sliderThumb"
            case .closeButton: return "closeButton"
            }
        }
        
        var image: UIImage {
            return UIImage(named: self.imageName) ?? UIImage()
        }
        
    }
    
}


//MARK: Slider Extensions
extension UISlider {
    
    func setSliderValue(for player: AVPlayer, progress: CMTime) {
        guard let duration = player.currentItem?.duration else { return }
        let totalSeconds = CMTimeGetSeconds(duration)
        let progressSeconds = CMTimeGetSeconds(progress)
        self.value = Float(progressSeconds / totalSeconds)
    }
}

//MARK: UIApplication Extension
extension UIDevice {
    
    static var isPortrait: Bool {
        return UIDevice.current.orientation.isPortrait
    }
    
}

//MARK: AVPlayer Extension
extension AVPlayer {
    
    enum observableKey: String {
        case loadedTimeRanges = "currentItem.loadedTimeRanges"
    }
    
}

//MARK: UIFont Extensions
extension UIFont {
    
    enum Theme {
        
        case navText
        case header
        case subHeader
        case bodyText
        case footNote
        case contact
        
        var size: CGFloat {
            switch self {
            case .navText:      return 20
            case .header:       return 18
            case .contact:      return 16
            case .subHeader:    return 18
            case .bodyText:     return 16
            case .footNote:     return 14
            }
        }
        
        var font: UIFont {
            switch self {
            case .navText:      return UIFont.systemFont(ofSize: size, weight: .medium)
            case .header:       return UIFont.systemFont(ofSize: size, weight: .heavy)
            case .contact:      return UIFont.systemFont(ofSize: size, weight: .regular)
            case .subHeader:    return UIFont.systemFont(ofSize: size, weight: .medium)
            case .bodyText:     return UIFont.systemFont(ofSize: size, weight: .regular)
            case .footNote:     return UIFont.systemFont(ofSize: size, weight: .light)
            }
            
        }
    }
}

//MARK: AttributedParagraph
class AttributedParagraph {
    
    let attributedText = NSMutableAttributedString()
    let style = NSMutableParagraphStyle()
    
    func append(text: String, font: UIFont, alignment: NSTextAlignment) {
        self.style.alignment = alignment
        let new = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font,
                                                                NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                NSAttributedString.Key.paragraphStyle: self.style])
        self.attributedText.append(new)
    }
}
