//
//  GlobeManager.swift
//  Earthly
//
//  Created by Max Rogers on 12/3/17.
//  Copyright © 2017 Max Rogers. All rights reserved.
//

import Foundation

class GlobeManager {
    
    // MARK: - Properties
    
    var globeController: GlobeViewController
    var remoteTiles: [RemoteTile]
    var aeris: AerisWeather
    var currentLayers: [MaplyQuadImageTilesLayer] = []
    
    
    // MARK: - Initialization
    
    init(controller: GlobeViewController, remoteTiles: [RemoteTile] = []) {
        globeController = controller
        self.remoteTiles = remoteTiles
        self.aeris = AerisWeather(aerisID: "", aerisKey: "")
        
        if let file = Bundle.main.url(forResource: "RemoteTiles", withExtension: "json") {
            do {
                let data = try Data(contentsOf: file, options: .uncached)
                self.remoteTiles = try JSONDecoder().decode([RemoteTile].self, from: data)
            } catch let error {
                print("Error parsing remotetile json file", error)
            }
        }
        
        if let path = Bundle.main.path(forResource: "AerisKeys", ofType: "plist") {
            guard let key = NSDictionary(contentsOfFile: path) as? [String : String],
                let secretKey = key["SecretKey"],
                let accessID = key["AccessID"] else { return }
            
            self.aeris = AerisWeather(aerisID: accessID, aerisKey: secretKey)
        }
    }
    
    // MARK: - Display a local tile
    
    func display(localTile tile: LocalTile) {
        guard let localTileSource = MaplyMBTileSource(mbTiles: tile.rawValue) else { return }
        currentLayers.append(MaplyQuadImageTilesLayer(coordSystem: localTileSource.coordSys, tileSource: localTileSource)!)
        presentLayer()
    }
    
    
    // MARK: - Display a remote tile
    
    func display(remoteTile tile: RemoteTile) {
        
        let baseCacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let tilesCacheDir = "\(baseCacheDir)/stamentiles/"
        
        guard let remoteTileSource = MaplyRemoteTileSource(baseURL: tile.url,
                                                           ext: tile.ext,
                                                           minZoom: tile.minZoom,
                                                           maxZoom: tile.maxZoom) else { return }
        remoteTileSource.cacheDir = tilesCacheDir
        currentLayers.append(MaplyQuadImageTilesLayer(coordSystem: remoteTileSource.coordSys, tileSource: remoteTileSource)!)
        presentLayer()

    }
    
    // MARK: - Display aeris weather data
    
    func displayWeatherData() {
        // switch to terrain
        let remoteTile = remoteTiles.filter { $0.name == "Terrain" }
        if let tile = remoteTile.first {
            globeController.removeLayers(currentLayers)
            display(remoteTile: tile)
        }
        aeris.setupOverlayLayer()
        refreshAerisOverlayLayer()
    }
    
    @objc func refreshAerisOverlayLayer() {
        aeris.layerTileSet.startFetch(success: { tileSources in
            
            let multiSource = MaplyMultiplexTileSource(sources: tileSources!)
            
            if let aerisLayer = self.aeris.aerisLayer {
                self.globeController.remove(aerisLayer)
            }
            
            self.aeris.aerisLayer = MaplyQuadImageTilesLayer(coordSystem: multiSource!.coordSys, tileSource: multiSource!)
            
            if let aerisLayer = self.aeris.aerisLayer {
                aerisLayer.imageDepth = UInt32(self.aeris.frameCount)
                aerisLayer.animationPeriod = self.aeris.animationPeriod
                aerisLayer.imageFormat = MaplyQuadImageFormat.imageUShort5551
                aerisLayer.maxTiles = 1000
                aerisLayer.importanceScale = self.aeris.importanceScale
                aerisLayer.drawPriority = INT_MAX
                self.currentLayers.append(aerisLayer)
                self.presentLayer()
            }
        },
                                      failure: { (NSError) in
                                        print("FAILURe", NSError.localizedDescription)
        })
    }
    
    
    // MARK: - Ready the layer and present it
    
    func presentLayer() {
        currentLayers.last?.handleEdges = true
        currentLayers.last?.coverPoles = true
        currentLayers.last?.requireElev = false
        currentLayers.last?.waitLoad = false
        currentLayers.last?.drawPriority = 1
        currentLayers.last?.singleLevelLoading = false
        globeController.add(currentLayers.last!)
    }
    
    
}
