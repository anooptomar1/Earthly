//
//  GlobeAnimation.swift
//  Earthly
//
//  Created by Max Rogers on 12/4/17.
//  Copyright © 2017 Max Rogers. All rights reserved.
//

import UIKit

extension GlobeViewController {
    
    // MARK: - Animation
    
    func configureAnimation() {
        
        let movement = AnimationMovement.randomMovement()
        var x: CGFloat!
        var y: CGFloat!
        
        switch movement {
        case .TopBottom:
            x = view.frame.minX
            y = view.frame.minY - view.frame.size.height
            translationOptions = (0, -view.frame.size.height)
        case .BottomTop:
            x = view.frame.minX
            y = view.frame.maxY
            translationOptions = (0, view.frame.size.height)
        case .LeftRight:
            x = view.frame.minX - view.frame.size.width
            y = view.frame.minY
            translationOptions = (view.frame.size.width, 0)
        case .RightLeft:
            x = view.frame.maxX
            y = view.frame.minY
            translationOptions = (-view.frame.size.width, 0)
        }
        view.frame = CGRect(x: x, y: y, width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func animateGlobeControllerIn() {
        view.transform = CGAffineTransform(translationX: translationOptions.x, y: translationOptions.y)
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.view.transform = CGAffineTransform.identity
        }, completion: {(_) in
            self.controlButton.appear()
        })
    }
    
}
