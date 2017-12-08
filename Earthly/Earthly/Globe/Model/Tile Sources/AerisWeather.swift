//
//  AerisWeather.swift
//  Earthly
//
//  Created by Max Rogers on 12/7/17.
//  Copyright © 2017 Max Rogers. All rights reserved.
//

import Foundation

class AerisWeather {
    
    // MARK: - Properties
    
    var aerisID: String
    var aerisKey: String
    var frameCount: Int
    var animationPeriod: Float
    var importanceScale: Float
    var layerCode: String
    
    var aerisLayer: MaplyQuadImageTilesLayer!
    var layerInfo: MaplyAerisLayerInfo!
    var layerTileSet: MaplyAerisTileSet!
    var refreshTimer: Timer?
    
    
    init(aerisID: String, aerisKey: String, frameCount: Int = 6, animationPeriod: Float = 3.0, importanceScale: Float = 1.0/16.0, layerCode: String = "radar") {
        self.aerisID = aerisID
        self.aerisKey = aerisKey
        self.frameCount = frameCount
        self.animationPeriod = animationPeriod
        self.importanceScale = importanceScale
        self.layerCode = layerCode
    }
    
    func setupOverlayLayer() {
        let aerisTiles = MaplyAerisTiles(aerisID: aerisID, secretKey: aerisKey)
        let layerInfoDict = aerisTiles?.layerInfo()
        layerInfo = layerInfoDict?[layerCode] as? MaplyAerisLayerInfo
        
        guard let layerInfo = layerInfo else {
            print("Error finding aeris radar layer parameters.")
            return
        }
        
        layerTileSet = MaplyAerisTileSet(
            aerisID: aerisID,
            secretKey: aerisKey,
            layerInfo: layerInfo,
            tileSetCount: UInt32(frameCount))
        
        refreshTimer = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(GlobeManager.refreshAerisOverlayLayer), userInfo: nil, repeats: true)
    }
    
    
}
