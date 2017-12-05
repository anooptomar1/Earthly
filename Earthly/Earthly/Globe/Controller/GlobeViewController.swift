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
    
    // Control properties
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var controlView: UIView!
    var controlsVisible = false
    
    // Globe animation properties
    private var firstAppearance = true
    var translationOptions: (x: CGFloat, y: CGFloat)!
    
    private var layer: MaplyQuadImageTilesLayer!

    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayer()
        configureAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstAppearance {
            firstAppearance = false
            animate(toPosition: MaplyCoordinateMakeWithDegrees(-98.583333, 39.833333), time: 1)
            animateGlobeControllerIn()
        }
    }
    
    // MARK: - Setup Tiles
    
    func setupLayer() {
        guard let localTileSource = MaplyMBTileSource(mbTiles: LocalTile.colored.rawValue) else { return }
        layer = MaplyQuadImageTilesLayer(coordSystem: localTileSource.coordSys, tileSource: localTileSource)
    
        layer.handleEdges = true
        layer.coverPoles = true
        layer.requireElev = false
        layer.waitLoad = false
        layer.drawPriority = 0
        layer.singleLevelLoading = false
        clearColor = UIColor.clear
        
        add(layer)
        height = 1.4
        frameInterval = 1
        setZoomLimitsMin(0.001, max: 3.5)
        
    }
    
}
