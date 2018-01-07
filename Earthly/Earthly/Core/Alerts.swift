//
//  Alerts.swift
//  Earthly
//
//  Created by Max Rogers on 1/6/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Map Settings
    
    func presentNoAuthorization(for feature: String) {
        DispatchQueue.main.async {
            let authController = UIAlertController(title: "Access Error",
                                                   message: "To use this feature, Earthly requires access to your \(feature). You can enable this in your app settings.",
                preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { (_) in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            })
            authController.addAction(settingsAction)
            authController.preferredAction = settingsAction
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            authController.addAction(cancelAction)
            
            self.present(authController, animated: true, completion: nil)
        }
    }
    
    
}

// MARK: - Activity Indicator

class ActivityIndicator {
    
    static let shared = ActivityIndicator()
    lazy var activityIndicator = EarthlyActivityIndicator()
    
    
    func startAnimating() {
        DispatchQueue.main.async {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                let frame = CGRect(x: topController.view.frame.midX - 50, y: topController.view.frame.midY - 40, width: 100, height: 80)
                self.activityIndicator = EarthlyActivityIndicator(frame: frame)
                topController.view.addSubview(self.activityIndicator)
            }
        }
    }
    
    func stopAnimating() {
        DispatchQueue.main.async {
            self.activityIndicator.layer.removeAllAnimations()
            self.activityIndicator.removeFromSuperview()
        }
    }
    
}

