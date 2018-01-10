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
            marker.layoutImportance = MAXFLOAT - 500
            let newMarker = addScreenMarkers([marker], desc: nil)
            activeObjects.append(newMarker!)
            earthlyMarkers.append(marker)
            
            if earthlyMarkers.count > 1 {
                let lastIndex = earthlyMarkers.endIndex - 1
                let firstLocation = earthlyMarkers[lastIndex - 1]
                let secondLocation = earthlyMarkers[lastIndex]
                let distance = MaplyGreatCircleDistance(firstLocation.loc, secondLocation.loc)
                let miles = Double(round(100 * (distance * 0.000621371))/100)
                
                let boldAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.boldSystemFont(ofSize: 21)]
                let milesText = NSMutableAttributedString(string: "\(miles) miles", attributes: boldAttributes)
                
                let firstLocationName = (firstLocation.userObject as! String)
                let firstShorthand = firstLocationName.components(separatedBy: "•").first
                let secondLocationName = (secondLocation.userObject as! String)
                let secondShorthand = secondLocationName.components(separatedBy: "•").first
                
                let normalAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 21)]
                let secondHalf = NSMutableAttributedString(string:" away from \n\(secondShorthand ?? secondLocationName)", attributes: normalAttributes)
                let text = NSMutableAttributedString(string: "\(firstShorthand ?? firstLocationName) is\n", attributes: normalAttributes)
                text.append(milesText)
                text.append(secondHalf)
    
                milesViewLabel.attributedText = text
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
        print(selectedObj.hashValue)
        
        if let marker = selectedObj as? MaplyScreenMarker {
            if !locationsMarked.contains(where: { $0.x == marker.loc.x && $0.y == marker.loc.y } ) {
                print(marker.loc)
                let title = marker.userObject as? String ?? "Unknown"
                let annotation = MaplyAnnotation()
                annotation.title = title
                //annotation.subTitle = subtitle
                addAnnotation(annotation, forPoint: marker.loc, offset: CGPoint(x: 0, y: 0))
                if !locationsMarked.contains(where: { $0.x == marker.loc.x && $0.y == marker.loc.y } ) {
                    locationsMarked.append(marker.loc)
                }
            } else {
                print(marker.loc)
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
