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
