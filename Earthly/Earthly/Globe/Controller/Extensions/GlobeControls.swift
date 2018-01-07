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
            earthlyLocationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            guard let location = earthlyLocationManager.location else { return }
            shouldZoom(toCoordinates: location.coordinate, withScope: .city, name: "Current Location", displayMarker: true)
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
    
    // MARK: - Helpers
    
    func removeSearchBar() {
        searchBar.animateControlViewOut()
        searchContainerView.disappear()
        searchBar.text = ""
        searchViewController?.placesOfInterest.removeAll()
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - Delegate for zooming

extension GlobeViewController: GlobeDelegate {
    
    func shouldZoom(toCoordinates coordinates: CLLocationCoordinate2D, withScope scope: LocationScope, name: String, displayMarker: Bool) {
        searchContainerView.disappear()
        searchBar.resignFirstResponder()
        searchBar.text = ""
        let latitude = Float(coordinates.latitude)
        let longitude = Float(coordinates.longitude)
        if displayMarker {
            let marker = MaplyScreenMarker()
            marker.image = #imageLiteral(resourceName: "GPS")
            marker.loc = MaplyCoordinateMakeWithDegrees(longitude, latitude)
            marker.size = CGSize(width: 40, height: 40)
            marker.userObject = name
            addScreenMarkers([marker], desc: nil)
            earthlyMarkers.append(marker)
            
            if earthlyMarkers.count > 1 {
                let lastIndex = earthlyMarkers.endIndex - 1
                let firstLocation = earthlyMarkers[lastIndex - 1]
                let secondLocation = earthlyMarkers[lastIndex]
                let distance = MaplyGreatCircleDistance(firstLocation.loc, secondLocation.loc)
                let miles = distance * 0.000621371
                print("Miles = \(distance * 0.000621371)")
                let text = "\(firstLocation.userObject as! String) is \(miles) miles away from \(secondLocation.userObject as! String)"
                milesViewLabel.text = text
                milesView.animateMilesViewUp()
            }
        }
        
        
        switch scope {
        case .street:
            animate(toPosition: MaplyCoordinateMakeWithDegrees(longitude, latitude), height: 0.0001, heading: 0.0, time: 1)
        case .city:
            animate(toPosition: MaplyCoordinateMakeWithDegrees(longitude, latitude), height: 0.005, heading: 0.0, time: 1)
        case .state:
            animate(toPosition: MaplyCoordinateMakeWithDegrees(longitude, latitude), height: 0.1, heading: 0.0, time: 1)
        case .country:
            animate(toPosition: MaplyCoordinateMakeWithDegrees(longitude, latitude), height: 0.8, heading: 0.0, time: 1)
        }
    }
    
}

// MARK: - Mark selection

extension GlobeViewController: WhirlyGlobeViewControllerDelegate {
    
    func globeViewController(_ viewC: WhirlyGlobeViewController, didSelect selectedObj: NSObject) {
        
        if let marker = selectedObj as? MaplyScreenMarker {
            if !locationsMarked.contains(where: { $0.x == marker.loc.x && $0.y == marker.loc.y } ) {
                let title = marker.userObject as? String ?? "Unknown"
                let annotation = MaplyAnnotation()
                annotation.title = title
                //annotation.subTitle = subtitle
                addAnnotation(annotation, forPoint: marker.loc, offset: CGPoint(x: 0, y: 0))
                locationsMarked.append(marker.loc)
            } else {
                let currentAnnotations = annotations() as? [MaplyAnnotation]
                if let annotationToRemove = currentAnnotations?.filter({ $0.loc.x == marker.loc.x && $0.loc.y == marker.loc.y }).first {
                    removeAnnotation(annotationToRemove)
                    if let index = locationsMarked.index(where: { $0.x == annotationToRemove.loc.x && $0.y == annotationToRemove.loc.y } ) {
                        locationsMarked.remove(at: index)
                    }
                }
            }
        }
        
    }
    
}




