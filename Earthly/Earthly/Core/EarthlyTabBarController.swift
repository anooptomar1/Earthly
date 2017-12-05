//
//  EarthlyTabBarController.swift
//  
//
//  Created by Max Rogers on 12/4/17.
//

import UIKit

class EarthlyTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    // MARK: - Animate tab bar items on selection
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let view = item.value(forKey: "view") as? UIView,
            let image = view.subviews.first as? UIImageView {

            let expandTransform = CGAffineTransform(scaleX: 2, y: 2)
            let rotateTransform = CGAffineTransform(rotationAngle: CGFloat.pi)
            image.transform = expandTransform
            image.transform = rotateTransform
            UIView.animate(withDuration: 1.5,
                                       delay:0.0,
                                       usingSpringWithDamping:0.40,
                                       initialSpringVelocity:0.1,
                                       options: .curveEaseOut,
                                       animations: {
                                        image.transform = expandTransform.inverted()
                                        image.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
}

extension EarthlyTabBarController: UITabBarControllerDelegate {
    
    // MARK: - Dissolve transition for changing tabs
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if selectedViewController == nil || viewController == selectedViewController {
            return false
        }
        
        let fromView = selectedViewController!.view
        let toView = viewController.view
        
        UIView.transition(from: fromView!, to: toView!, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        
        return true
    }
    
}
