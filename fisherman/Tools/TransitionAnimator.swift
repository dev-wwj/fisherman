//
//  TransitionAnimator.swift
//  fisher
//
//  Created by wangwenjian on 2023/12/14.
//

import Foundation
import UIKit

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var originPoint: CGPoint = .zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to)
        else {
            return
        }
        let isPresenting = toVC.presentingViewController == fromVC
        let containerView = transitionContext.containerView
        
        var animateView: UIView!
        if isPresenting {
            animateView = toVC.view
        } else {
            animateView = fromVC.view
        }
        containerView.addSubview(animateView)
        let radiusMax = sqrt(pow(containerView.bounds.width, 2) + pow(containerView.bounds.height, 2))
        // 动画
        let bezierPathStart = UIBezierPath(arcCenter: originPoint, radius: 1, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        let bezierPathEnd = UIBezierPath(arcCenter: originPoint, radius: radiusMax, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.bounds = containerView.bounds
        shapeLayer.position = containerView.center
        if isPresenting {
            shapeLayer.path = bezierPathStart.cgPath
        } else {
            shapeLayer.path = bezierPathEnd.cgPath
        }
        animateView.layer.mask = shapeLayer
        
        let animation : RetroBasicAnimation = RetroBasicAnimation()
        animation.keyPath = "path"
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = transitionDuration(using: transitionContext)
        if isPresenting {
            animation.fromValue = bezierPathStart.cgPath
            animation.toValue = bezierPathEnd.cgPath
        } else {
            animation.fromValue =  bezierPathEnd.cgPath
            animation.toValue = bezierPathStart.cgPath
        }
        animation.autoreverses = false
        animation.onFinish = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.layer.mask = nil
        }
        shapeLayer.add(animation, forKey: "path")
    }
    
}

class RetroBasicAnimation : CABasicAnimation, CAAnimationDelegate {
    public var onFinish : (() -> (Void))?
    
    override init() {
        super.init()
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let onFinish = onFinish {
            onFinish()
        }
    }
}
