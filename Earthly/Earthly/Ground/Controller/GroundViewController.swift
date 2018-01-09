//
//  GroundViewController.swift
//  Earthly
//
//  Created by Max Rogers on 1/8/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import UIKit
import HDAugmentedReality

class GroundViewController: ARViewController {
    
    var locationManager = CLLocationManager()
    var startedLoadingPlaces = false
    var places: [PlaceOfInterest] = [] {
        willSet {
            setAnnotations(newValue)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        presenter.verticalStackingEnabled = true
        presenter.maxVisibleAnnotations = 50        
        
        
        
        trackingManager.userDistanceFilter = 25
        trackingManager.reloadDistanceFilter = 75
        setAnnotations(places)
        //arViewController.uiOptions.debugEnabled = false
        uiOptions.closeButtonEnabled = false
        locationManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
    }


}

// MARK: - ARKit

extension GroundViewController: ARDataSource {
    
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let annotationView = AnnotationView()
        annotationView.annotation = viewForAnnotation
        annotationView.delegate = self
        annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        
        return annotationView
    }
    
    
}

extension GroundViewController: AnnotationViewDelegate {
    
    func didTouch(annotationView: AnnotationView) {
        if let annotation = annotationView.annotation as? PlaceOfInterest {
            
            ActivityIndicator.shared.startAnimating()
            let request = GooglePlacesRequest(requestType: .details, reference: annotation.reference)
            let dispatcher = NetworkDispatcher(request: request)
            
            
            dispatcher.requestDetails(
                onSuccess: { (detail) in
                    ActivityIndicator.shared.stopAnimating()
                    annotation.phoneNumber = detail.phoneNumber
                    annotation.website = detail.website
                    
                    self.presentInfo(forPlace: annotation)
            }, onFailure: { (error) in
                ActivityIndicator.shared.stopAnimating()
                
            })
        }
    }
}

// MARK: - Location Manager Delegate

extension GroundViewController: CLLocationManagerDelegate {
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let location = locations.last!
            if location.horizontalAccuracy < 100 {
                locationManager.stopUpdatingLocation()
                if !startedLoadingPlaces {
                    startedLoadingPlaces = true
                    
                    ActivityIndicator.shared.startAnimating()
                    let request = GooglePlacesRequest(requestType: .places, location: location, radius: 1000)
                    let dispatcher = NetworkDispatcher(request: request)
                    
                    
                    dispatcher.requestPlaces(
                        onSuccess: { (places) in
                        ActivityIndicator.shared.stopAnimating()
                        self.places = places
                    }, onFailure: { (error) in
                        ActivityIndicator.shared.stopAnimating()
                        self.present(error: error)
                    })
                }
                
            }
        }
    }
}

// MARK: - Alerts

extension GroundViewController {
    
    func present(error: PlacesNetworkError) {
        var errorMessage = ""
        switch error {
        case .failedRequest:
            errorMessage = "Network failure occured."
        case .invalidResponse:
            errorMessage = "Network authentication failed."
        case .unknown:
            errorMessage = "Not sure what went wrong!"
        }
        self.presentNetworkError(forFailure: errorMessage)
    }
    
    func presentInfo(forPlace place: PlaceOfInterest) {
        let alert = UIAlertController(title: place.placeName , message: place.infoText, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}


