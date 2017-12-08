//
//  GlobeManager.swift
//  Earthly
//
//  Created by Max Rogers on 12/3/17.
//  Copyright © 2017 Max Rogers. All rights reserved.
//

import Foundation
import WhirlyGlobe

class GlobeManager {
    
    // MARK: - Properties
    
    var globeController: GlobeViewController
    var remoteTiles: [RemoteTile]
    var currentLayer: MaplyQuadImageTilesLayer!
    
    
    // MARK: - Initialization
    
    init(controller: GlobeViewController, remoteTiles: [RemoteTile] = []) {
        globeController = controller
        self.remoteTiles = remoteTiles
        
        if let file = Bundle.main.url(forResource: "RemoteTiles", withExtension: "json") {
            do {
                let data = try Data(contentsOf: file, options: .uncached)
                self.remoteTiles = try JSONDecoder().decode([RemoteTile].self, from: data)
            } catch let error {
                print("Error parsing remotetile json file", error)
            }
        }
        
    }
    
    // MARK: - Display a science tile
    
    // MARK: - Display a remote tile
    
    func display(remoteTile tile: RemoteTile) {
        
        let baseCacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let tilesCacheDir = "\(baseCacheDir)/stamentiles/"
        
        guard let remoteTileSource = MaplyRemoteTileSource(baseURL: tile.url,
                                                           ext: tile.ext,
                                                           minZoom: tile.minZoom,
                                                           maxZoom: tile.maxZoom) else { return }
        remoteTileSource.cacheDir = tilesCacheDir
        currentLayer = MaplyQuadImageTilesLayer(coordSystem: remoteTileSource.coordSys, tileSource: remoteTileSource)
        presentLayer()

    }
    
    // MARK: - Display a local tile
    
    func display(localTile tile: LocalTile) {
        guard let localTileSource = MaplyMBTileSource(mbTiles: tile.rawValue) else { return }
        currentLayer = MaplyQuadImageTilesLayer(coordSystem: localTileSource.coordSys, tileSource: localTileSource)
        presentLayer()
    }
    
    // MARK: - Ready the layer and present it
    
    func presentLayer() {
        currentLayer.handleEdges = true
        currentLayer.coverPoles = true
        currentLayer.requireElev = false
        currentLayer.waitLoad = false
        currentLayer.drawPriority = 0
        currentLayer.singleLevelLoading = false
        globeController.add(currentLayer)
    }
    
    
}
