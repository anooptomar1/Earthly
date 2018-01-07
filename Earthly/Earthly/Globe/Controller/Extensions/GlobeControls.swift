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
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            CLLocationManager().requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            guard let location = CLLocationManager().location else { return }
            shouldZoom(toCoordinates: location.coordinate, withScope: .city)
        case .denied, .restricted:
            presentNoAuthorization(for: "Location")
        default:
            break
        }
        
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

extension GlobeViewController: GlobeDelegate {
    func shouldZoom(toCoordinates coordinates: CLLocationCoordinate2D, withScope scope: LocationScope) {
        searchContainerView.disappear()
        searchBar.resignFirstResponder()
        searchBar.text = ""
        let latitude = Float(coordinates.latitude)
        let longitude = Float(coordinates.longitude)
        switch scope {
        case .street:
            animate(toPosition: MaplyCoordinateMakeWithDegrees(longitude, latitude), time: 1)
        case .city:
            animate(toPosition: MaplyCoordinateMakeWithDegrees(longitude, latitude), time: 1)
        case .state:
            animate(toPosition: MaplyCoordinateMakeWithDegrees(longitude, latitude), time: 1)
        case .country:
            animate(toPosition: MaplyCoordinateMakeWithDegrees(longitude, latitude), time: 1)
        }
    }
}




