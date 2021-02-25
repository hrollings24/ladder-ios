//
//  SlideInTransition.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 13/08/2020.
//

import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting = false
    var dimmingView = UIView()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toVC = transitionContext.viewController(forKey: .to),
              let fromVC = transitionContext.viewController(forKey: .from) else { return }
        let containerView = transitionContext.containerView
        var finalWidth = CGFloat(toVC.view.bounds.width * 0.7)

        if UIDevice.current.userInterfaceIdiom == .pad{
            let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
            if orientation!.isLandscape {
                finalWidth = toVC.view.bounds.width * 0.3

            }
            else{
                finalWidth = toVC.view.bounds.width * 0.7

            }
        }
                
                
        let finalHeight = toVC.view.bounds.height
        
        if isPresenting{
            //add dimming view
            dimmingView.backgroundColor = .black
            dimmingView.alpha = 0
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds
            //Add menu VC to container
            containerView.addSubview(toVC.view)
            
            //init frame off the screen
            toVC.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
        }
        
        //Animate onto screen
        let transform = {
            self.dimmingView.alpha = 0.5
            toVC.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }
        
        //Animate back off screen
        let identity = {
            self.dimmingView.alpha = 0
            fromVC.view.transform = .identity
        }
        
        //animation of the transition
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration) {
            self.isPresenting ? transform() : identity()
        } completion: { (_) in
            transitionContext.completeTransition(!isCancelled)
        }


    }
    

}
