//
//  GlobeControls.swift
//  Earthly
//
//  Created by Max Rogers on 12/5/17.
//  Copyright © 2017 Max Rogers. All rights reserved.
//

import UIKit

extension GlobeViewController {
    
    // MARK: - Actions
    
    @IBAction func controlTapped(_ sender: UIButton) {
        controlButton.animateButton()
        
        if !controlsVisible {
            controlView.animateControlViewIn()
            controlView.appear()
        } else {
            controlView.animateControlViewOut()
        }
        
        if searchVisible {
            removeSearchBar()
            searchVisible = !searchVisible
        }
        
        controlsVisible = !controlsVisible
    }
    
    @IBAction func gpsTapped(_ sender: UIButton) {
        gpsButton.animateButton()
        
    }
    
    @IBAction func layersTapped(_ sender: UIButton) {
        layersButton.animateButton()
        presentLayersActionSheet()
        
    }
    
    @IBAction func scienceTapped(_ sender: UIButton) {
        scienceButton.animateButton()
        presentWeatherActionSheets()
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        searchButton.animateButton()
        if !searchVisible {
            controlView.animateControlViewUpAndOut()
            controlsVisible = !controlsVisible
            searchBar.animateControlViewIn()
            searchBar.appear()
            searchBar.becomeFirstResponder()
        } else {
            removeSearchBar()
        }
        searchVisible = !searchVisible
    }
    
    // MARK: Helpers
    
    func removeSearchBar() {
        searchBar.animateControlViewOut()
        searchContainerView.disappear()
        searchBar.text = ""
        searchViewController?.placesOfInterest.removeAll()
        searchBar.resignFirstResponder()
    }
    
}


