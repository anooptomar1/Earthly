//
//  ControlAnimationExtensions.swift
//  Earthly
//
//  Created by Max Rogers on 12/5/17.
//  Copyright © 2017 Max Rogers. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: - functions to animate control buttons and views
    
    func animateControlViewIn() {
        UIView.animate(withDuration: 1.6,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [UIViewAnimationOptions.curveEaseOut],
                       animations: {
                        self.transform = CGAffineTransform(translationX: self.frame.size.width - 30, y: 0)
        }, completion: nil)
    }
    
    func animateControlViewOut() {
        UIView.animate(withDuration: 1.6,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [UIViewAnimationOptions.curveEaseOut],
                       animations: {
                        self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func animateControlButton() {
        let expandTransform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        self.transform = expandTransform
        UIView.animate(withDuration: 1.6,
                       delay:0.0,
                       usingSpringWithDamping:0.40,
                       initialSpringVelocity:0.1,
                       options: .curveEaseOut,
                       animations: {
                        self.transform = expandTransform.inverted()
                        self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
}
