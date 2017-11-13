//
//  SideMenuPresentationManager.swift
//  Starbet24
//
//  Created by Oleh Korchytskyi on 19/05/2017.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

fileprivate let DimmingViewTag: Int = 888
fileprivate let ShadowImageViewTag: Int = 777


enum SideMenuPresentationMode : Equatable {
    case FullSpace
    case LeftSpace(CGFloat)
    case RightSpace(CGFloat)
    
    func viewFrameInContainer(rect: CGRect) -> CGRect {
        switch self {
        case .FullSpace:
            return CGRect(origin: .zero, size: rect.size)
        case .LeftSpace(let space):
            return CGRect(x: space, y: 0, width: rect.width - space, height: rect.height)
        case .RightSpace(let space):
            return CGRect(x: 0, y: 0, width: rect.width - space, height: rect.height)
        }
    }
    
    public static func ==(lhs: SideMenuPresentationMode, rhs: SideMenuPresentationMode) -> Bool {
        switch (lhs, rhs) {
        case (.FullSpace, .FullSpace):
            return true
        case ( .LeftSpace(_), .LeftSpace(_)):
            return true
        case ( .RightSpace(_), .RightSpace(_)):
            return true
        default:
            return false
        }
    }
}

final class SideMenuPresentationManager: NSObject, UIViewControllerTransitioningDelegate {
    
    var mode: SideMenuPresentationMode = .FullSpace
    
    var dississInteractionPanRecognizer: UIPanGestureRecognizer?
    var presentInteractionScreenEdgePanRecognizer: UIScreenEdgePanGestureRecognizer?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SideMenuPresentationAnimator(mode)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SideMenuDissmissAnimator(mode)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let dississInteractionPanRecognizer = dississInteractionPanRecognizer else {
            return nil
        }
        
        return SideMenuDissmissInteractionAnimator(dississInteractionPanRecognizer)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let presentInteractionScreenEdgePanRecognizer = presentInteractionScreenEdgePanRecognizer else {
            return nil
        }
        
        return SideMenuInteractivePresentationAnimator(presentInteractionScreenEdgePanRecognizer)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = SideMenuPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.mode = mode
        return presentationController
    }
}

final class SideMenuInteractivePresentationAnimator: UIPercentDrivenInteractiveTransition {
    
    var screenEdgePanRecognizer: UIScreenEdgePanGestureRecognizer?
    
    convenience init(_ screenEdgePanRecognizer: UIScreenEdgePanGestureRecognizer) {
        self.init()
        self.screenEdgePanRecognizer = screenEdgePanRecognizer
        screenEdgePanRecognizer.addTarget(self, action: #selector(self.didPanWith(recognizer:)))
        completionCurve = .easeOut
        
        timingCurve = UICubicTimingParameters(animationCurve: .linear)
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        
    }
    
    func didPanWith(recognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = recognizer.translation(in: recognizer.view)
        
        let d = -translation.x / (recognizer.view?.bounds.width ?? 0) * 0.5
        
        switch recognizer.state {
        case .changed:
            update(d)
            break
        default:
            if (d > 0.2) {
                finish()
            } else {
                cancel()
            }
            break
        }
    }
    
    
}

final class SideMenuDissmissInteractionAnimator: UIPercentDrivenInteractiveTransition {
    
    var panRecognizer: UIPanGestureRecognizer?
    
    convenience init(_ panRecognizer: UIPanGestureRecognizer) {
        self.init()
        self.panRecognizer = panRecognizer
        panRecognizer.addTarget(self, action: #selector(self.didPanWith(recognizer:)))
        completionCurve = .easeOut

        timingCurve = UICubicTimingParameters(animationCurve: .linear)
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        
    }
    
    func didPanWith(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: recognizer.view)
        let d =  -translation.x / (recognizer.view?.bounds.width ?? 0) * 0.5

        switch recognizer.state {
        case .changed:
            update(d)
            break
        default:
            if (d > 0.2) {
                finish()
            } else {
                cancel()
            }
            break
        }
    }
}

protocol SideMenuAnimator: class {
    var mode: SideMenuPresentationMode { get set }
    var transitionDuration: TimeInterval { get }
    init()
    init(_ presentationMode: SideMenuPresentationMode)
}

extension SideMenuAnimator {
    var transitionDuration: TimeInterval { return 0.35 }
    init(_ presentationMode: SideMenuPresentationMode) {
        self.init()
        mode = presentationMode
    }
}

final class SideMenuPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning, SideMenuAnimator {
    var mode: SideMenuPresentationMode = .FullSpace

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        let animatedViewController = transitionContext.viewController(forKey: .to)
        
        let shadowImageView = UIImageView(image: #imageLiteral(resourceName: "side_menu_right_shadow"))
        shadowImageView.tag = ShadowImageViewTag
        
        if let animatingView = animatedViewController?.view {
            
            container.addSubview(animatingView)
            shadowImageView.sizeToFit()
            container.insertSubview(shadowImageView, belowSubview: animatingView)
        }
        
        let duration = self.transitionDuration(using: transitionContext)
        
        let frame = mode.viewFrameInContainer(rect: container.frame)
        animatedViewController?.view.frame = frame
        let shadowX = (mode == .RightSpace(0)) ? frame.width : frame.origin.x - shadowImageView.bounds.width
        shadowImageView.frame = CGRect(x: shadowX, y: frame.origin.y, width: shadowImageView.bounds.width, height: frame.height)
        
        let leftTransform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        let rightTransform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
        
        let transform = (mode == .RightSpace(0)) ? rightTransform : leftTransform
        animatedViewController?.view.transform = transform
        shadowImageView.transform = transform
        
        let parameters = UICubicTimingParameters(animationCurve: .easeOut)
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: parameters)
        
        animator.addAnimations {
            animatedViewController?.view.transform = .identity
            shadowImageView.transform = .identity
        }
        
        animator.addCompletion { (state) in
            let finished = state == UIViewAnimatingPosition.end
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled && finished)
        }
        
        animator.startAnimation()
    }
}

final class SideMenuDissmissAnimator: NSObject, UIViewControllerAnimatedTransitioning, SideMenuAnimator {
    var mode: SideMenuPresentationMode = .FullSpace

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        
        let animatedViewController = transitionContext.viewController(forKey: .from)
        
        let duration = self.transitionDuration(using: transitionContext)
        
//        animatedViewController?.view.transform = .identity
        
        let parameters = UICubicTimingParameters(animationCurve: .easeOut)
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: parameters)

        let shadowImageView = container.subviews.filter({$0.tag == ShadowImageViewTag}).first
        
        let screenWidht = UIScreen.main.bounds.width
        let translation = (mode == .RightSpace(0)) ? -screenWidht : screenWidht
        
        animator.addAnimations {
            let transform = CGAffineTransform(translationX: translation, y: 0)
            animatedViewController?.view.transform = transform
            shadowImageView?.transform = transform
        }
        
        animator.addCompletion { (state) in
            let finished = state == UIViewAnimatingPosition.end
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled && finished)
        }
        
        animator.startAnimation()
    }
}

class SideMenuPresentationController: UIPresentationController {
    
    var mode: SideMenuPresentationMode = .FullSpace
    var dississInteractionPanRecognizer: UIPanGestureRecognizer?
    
    var dimmingView: UIView?
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    func setupDimmingView() {
        
        let tag = DimmingViewTag
        
        if let dimmingView = containerView?.subviews.filter({$0.tag == tag}).first {
            self.dimmingView = dimmingView
        } else {
            dimmingView = UIView(frame: containerView?.bounds ?? .zero)
            dimmingView?.tag = tag
            dimmingView?.backgroundColor = .clear
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(tapRecognizer:)))
            dimmingView?.addGestureRecognizer(tapRecognizer)
            
            let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dimmingViewDidPan(panRecognizer:)))
            dimmingView?.addGestureRecognizer(panRecognizer)
            dississInteractionPanRecognizer = panRecognizer
        }
    }
    
    func dimmingViewTapped(tapRecognizer: UITapGestureRecognizer) {
        let manager = SideMenuPresentationManager()
        manager.mode = mode
        
        presentedViewController.transitioningDelegate = manager
        presentedViewController.modalPresentationStyle = .custom
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    func dimmingViewDidPan(panRecognizer: UIPanGestureRecognizer) {
        switch panRecognizer.state {
        case .began:
            let manager = SideMenuPresentationManager()
            manager.mode = mode
            manager.dississInteractionPanRecognizer = panRecognizer
            presentedViewController.transitioningDelegate = manager
            presentedViewController.modalPresentationStyle = .custom
            presentedViewController.dismiss(animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    override func presentationTransitionWillBegin() {
        
        dimmingView?.frame = containerView?.bounds ?? .zero
        dimmingView?.alpha = 0.0
        
        containerView?.insertSubview(dimmingView ?? UIView(), at: 0)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (_) in
            self?.dimmingView?.alpha = 1
            }, completion: { (_) in
                
        })
        
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (_) in
            self?.dimmingView?.alpha = 0
            }, completion: { (_) in
                
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        dimmingView?.frame = containerView?.bounds ?? .zero
    }
    
}
