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
    @IBOutlet weak var gpsButton: UIButton!
    @IBOutlet weak var layersButton: UIButton!
    @IBOutlet weak var scienceButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var controlViewXConstraint: NSLayoutConstraint!
    var controlsVisible = false
    
    // Globe animation properties
    private var firstAppearance = true
    var translationOptions: (x: CGFloat, y: CGFloat)!
    
    var globeManager: GlobeManager!

    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
        configureAnimation()
        globeManager.display(localTile: LocalTile.starter)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstAppearance {
            let newX = (view.frame.minX - (controlView.frame.size.width + 25))
            controlViewXConstraint.constant = newX
            firstAppearance = false
            animate(toPosition: MaplyCoordinateMakeWithDegrees(-98.583333, 39.833333), time: 1)
            animateGlobeControllerIn()
        }
    }
    
    // MARK: - Configure
    
    func configureController() {
        globeManager = GlobeManager(controller: self)
        
        clearColor = UIColor.clear
        height = 1.4
        frameInterval = 1
        setZoomLimitsMin(0.0001, max: 3.5)
    }
    
}
