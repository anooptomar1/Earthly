//
//  GlobeControlActionSheets.swift
//  Earthly
//
//  Created by Max Rogers on 12/6/17.
//  Copyright © 2017 Max Rogers. All rights reserved.
//

import UIKit
import WhirlyGlobeMaplyComponent

extension GlobeViewController {
    
    // MARK: - Action sheet for changing layers
    
    func presentLayersActionSheet() {
        let layerSheet = UIAlertController(title: "Change Globe", message: "Select a Layer", preferredStyle: .actionSheet)
        
        for layer in LocalTile.allValues {
            let name = "\(layer)"
            let layerOption = UIAlertAction(title: name.capitalizingFirstLetter(), style: .default, handler: { (_) in
                self.removeLayers([self.globeManager.currentLayer])
                self.globeManager.display(localTile: layer)
            })
            layerSheet.addAction(layerOption)
        }
        
        for remoteTile in globeManager.remoteTiles {
            let layerOption = UIAlertAction(title: remoteTile.name, style: .default, handler: { (_) in
                self.removeLayers([self.globeManager.currentLayer])
                self.globeManager.display(remoteTile: remoteTile)
            })
            layerSheet.addAction(layerOption)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        layerSheet.addAction(cancel)
        display(sheet: layerSheet)
        
    }
    
    // MARK: - Action sheet for weather choices
    
    func presentWeatherActionSheets() {
        let weatherSheet = UIAlertController(title: "Weather", message: "Select Weather Style", preferredStyle: .actionSheet)
        let global = UIAlertAction(title: "Global Satellite", style: .default) { (_) in
            self.globeManager.aeris.layerCode = "sat-global"
            self.globeManager.displayWeatherData()
        }
        weatherSheet.addAction(global)
        let hires = UIAlertAction(title: "Hi-Res Visible Satellite", style: .default) { (_) in
            self.globeManager.aeris.layerCode = "sat-vis-hires"
            self.globeManager.displayWeatherData()
        }
        weatherSheet.addAction(hires)
        let infrared = UIAlertAction(title: "Infrared Satellite", style: .default) { (_) in
            self.globeManager.aeris.layerCode = "satellite"
            self.globeManager.displayWeatherData()
        }
        weatherSheet.addAction(infrared)
        let radar = UIAlertAction(title: "Radar", style: .default) { (_) in
            self.globeManager.aeris.layerCode = "radar"
            self.globeManager.displayWeatherData()
        }
        weatherSheet.addAction(radar)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        weatherSheet.addAction(cancel)
        
        display(sheet: weatherSheet)
    }
    
    // MARK: - Style & Present Action Sheet
    
    func display(sheet: UIAlertController) {
        sheet.view.tintColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
        present(sheet, animated: true, completion: nil)
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
