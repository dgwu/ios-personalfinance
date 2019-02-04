//
//  PresentationController.swift
//  PersonalFinance
//
//  Created by Gun Eight  on 04/02/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    fileprivate var cardView: UIView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        setupCardView()
    }
    
    override var frameOfPresentedViewInContainerView: CGRect{
        return CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height*0.25
        ), size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height))
    }
    
    //will run when dissmissed
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else
        {
            cardView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition:
            { _ in
                self.cardView.alpha = 0.0
        })
    }
    
    //will run when presented
    override func presentationTransitionWillBegin() {
        self.containerView?.addSubview(cardView)
        
        //constrain the cardview view to the edges of the container view so that it fills the entire screen.
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[cardView]|",
                                           options: [], metrics: nil, views: ["cardView": cardView]))
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[cardView]|",
                                           options: [], metrics: nil, views: ["cardView": cardView]))
        
        //set the cardview  alpha property to 1.0 along the presentation transition
        guard let coordinator = presentedViewController.transitionCoordinator else {
            cardView.alpha = 1.0
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.cardView.alpha = 1.0
        })
        
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.layer.masksToBounds = true
        presentedView!.layer.cornerRadius = 15
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        self.presentedView?.frame = frameOfPresentedViewInContainerView
        cardView.frame = containerView!.bounds
    }
    
    func setupCardView()
    {
        cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        cardView.alpha = 0.0
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        cardView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismiss(){
        presentingViewController.dismiss(animated: true, completion: nil)
        
    }
}
