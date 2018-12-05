//
//  ScaleTransitioningDelegate.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-04.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

//MARK: Scaling Protocol
protocol Scaling {
    func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView?
}

//MARK: Transition State
enum TransitionState {
    case begin
    case end
}

//MARK: ScaleTransitioningDelegate Properties
class ScaleTransitioningDelegate: NSObject {
    let animationDuration = 0.5
    var navigationControllerOperation: UINavigationController.Operation = .none
}

//MARK: ScaleTransitioningDelegate UIViewControllerAnimatedTransitioning Methods
extension ScaleTransitioningDelegate : UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        let backgroundVC = navigationControllerOperation == .pop ? toVC : fromVC
        let foregroundVC = navigationControllerOperation == .pop ? fromVC : toVC
        
        guard let backgroundImageView = (backgroundVC as? Scaling)?.scalingImageView(transition: self) else { return }
        guard let foregroundImageView = (foregroundVC as? Scaling)?.scalingImageView(transition: self) else { return }
        
        let imageViewSnapshot = UIImageView(image: backgroundImageView.image)
        imageViewSnapshot.contentMode = .scaleAspectFill
        imageViewSnapshot.layer.masksToBounds = true
        
        if navigationControllerOperation == .pop {
            imageViewSnapshot.layer.cornerRadius = 10
        }
        
        backgroundImageView.isHidden = true
        foregroundImageView.isHidden = true
        
        let foregroundBGColor = foregroundVC.view.backgroundColor
        foregroundVC.view.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.white
        
        containerView.addSubview(backgroundVC.view)
        containerView.addSubview(foregroundVC.view)
        containerView.addSubview(imageViewSnapshot)
        
        let transitionStateA = navigationControllerOperation == .pop ? TransitionState.end : TransitionState.begin
        let transitionStateB = navigationControllerOperation == .pop ? TransitionState.begin : TransitionState.end

        prepareViews(for: transitionStateA, containerView: containerView, backgroundViewController: backgroundVC, backgroundImageView: backgroundImageView, foregroundImageView: foregroundImageView, snapshotImageView: imageViewSnapshot)
        
        foregroundVC.view.layoutIfNeeded()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: [], animations: {
            self.prepareViews(for: transitionStateB, containerView: containerView, backgroundViewController: backgroundVC, backgroundImageView: backgroundImageView, foregroundImageView: foregroundImageView, snapshotImageView: imageViewSnapshot)
        }) { _ in
            backgroundVC.view.transform = .identity
            imageViewSnapshot.removeFromSuperview()
            backgroundImageView.isHidden = false
            foregroundImageView.isHidden = false
            foregroundVC.view.backgroundColor = foregroundBGColor
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func prepareViews(for state: TransitionState, containerView: UIView, backgroundViewController: UIViewController, backgroundImageView: UIImageView, foregroundImageView: UIImageView, snapshotImageView: UIImageView) {
        switch state {
        case .begin:
            backgroundViewController.view.transform = .identity
            backgroundViewController.view.alpha = 1
            snapshotImageView.frame = containerView.convert(backgroundImageView.frame, from: backgroundImageView.superview)
            return
        case .end:
            backgroundViewController.view.alpha = 0
            snapshotImageView.frame = containerView.convert(foregroundImageView.frame, from: foregroundImageView.superview)
            return
        }
    }
}

//MARK: ScaleTransitioningDelegate UINavigationControllerDelegate
extension ScaleTransitioningDelegate : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC is Scaling && toVC is Scaling {
            self.navigationControllerOperation = operation
            let navbarVisible = operation == .pop
            navigationController.setNavigationBarHidden(!navbarVisible, animated: true)
            return self
        } else {
            return nil
        }
    }
}
