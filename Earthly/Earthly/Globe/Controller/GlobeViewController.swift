//
//  GlobeViewController.swift
//  Earthly
//
//  Created by Max Rogers on 12/3/17.
//  Copyright © 2017 Max Rogers. All rights reserved.
//

import UIKit
import WhirlyGlobe

class GlobeViewController: WhirlyGlobeViewController {
    
    // MARK: - Properties
    
    var layer: MaplyQuadImageTilesLayer!

    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayer()
    }
    
    // MARK: - Setup Tiles
    
    func setupLayer() {
        guard let localTileSource = MaplyMBTileSource(mbTiles: LocalTiles.colored.rawValue) else { return }
        layer = MaplyQuadImageTilesLayer(coordSystem: localTileSource.coordSys, tileSource: localTileSource)
    
        layer.handleEdges = true
        layer.coverPoles = true
        layer.requireElev = false
        layer.waitLoad = false
        layer.drawPriority = 0
        layer.singleLevelLoading = false
        
        add(layer)
        height = 0.8
        clearColor = UIColor.black
        frameInterval = 2
        
        animate(toPosition: MaplyCoordinateMakeWithDegrees(-3.6704803, 40.5023056), time: 1.0)
    }

}
