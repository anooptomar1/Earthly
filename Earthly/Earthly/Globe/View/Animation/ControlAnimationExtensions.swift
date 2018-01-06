//
//  ControlAnimationExtensions.swift
//  Earthly
//
//  Created by Max Rogers on 12/5/17.
//  Copyright © 2017 Max Rogers. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: - Functions to animate control buttons and views
    
    func animateControlViewIn() {
        self.isHidden = false
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [.curveEaseOut, .allowUserInteraction],
                       animations: {
                        self.transform = CGAffineTransform(translationX: self.frame.size.width, y: 0)
                        self.alpha = 1.0
        }, completion: nil)
    }
    
    func animateControlViewOut() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.transform = CGAffineTransform.identity
                        self.alpha = 0.0
        }, completion: nil)
    }
    
    func animateControlViewUpAndOut() {
        let upAndOutTransform = CGAffineTransform(translationX: 0, y: -self.frame.size.height)
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.transform = upAndOutTransform
                        self.alpha = 0.0
        }, completion: nil)
    }
    
    func animateButton() {
        let expandTransform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        self.transform = expandTransform
        UIView.animate(withDuration: 1.6,
                       delay:0.0,
                       usingSpringWithDamping:0.40,
                       initialSpringVelocity:0.1,
                       options: [.curveEaseOut, .allowUserInteraction],
                       animations: {
                        self.transform = expandTransform.inverted()
                        self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func appear() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0.9
            self.isHidden = false
        }
    }
    
    func disappear() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0.0
            self.isHidden = true
        }
    }
    
}
