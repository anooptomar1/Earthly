//
//  GlobeControlActionSheets.swift
//  Earthly
//
//  Created by Max Rogers on 12/6/17.
//  Copyright © 2017 Max Rogers. All rights reserved.
//

import UIKit

extension GlobeViewController {
    
    // MARK: - Action sheet for changing layers
    
    func presentLayersActionSheet() {
        let actionSheet = UIAlertController(title: "Change Globe Layer", message: "Select a Layer", preferredStyle: .actionSheet)
        
        for layer in LocalTile.allValues {
            let name = "\(layer)"
            let layerOption = UIAlertAction(title: name.capitalizingFirstLetter(), style: .default, handler: { (_) in
                self.removeLayers([self.globeManager.currentLayer])
                self.globeManager.display(localTile: layer)
            })
            actionSheet.addAction(layerOption)
        }
        
        for remoteTile in globeManager.remoteTiles {
            let layerOption = UIAlertAction(title: remoteTile.name, style: .default, handler: { (_) in
                self.removeLayers([self.globeManager.currentLayer])
                self.globeManager.display(remoteTile: remoteTile)
            })
            actionSheet.addAction(layerOption)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancel)
        
        actionSheet.view.tintColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
        present(actionSheet, animated: true, completion: nil)
        
        UIVisualEffectView.appearance(whenContainedInInstancesOf: [UIAlertController.classForCoder() as! UIAppearanceContainer.Type]).effect = UIBlurEffect(style: .dark)
    }
    
}

// MARK: - Extension to capitlize local tile enum

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
