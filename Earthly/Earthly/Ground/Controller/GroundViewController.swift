//
//  GroundViewController.swift
//  Earthly
//
//  Created by Max Rogers on 1/8/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import UIKit
import HDAugmentedReality
import MapKit

class GroundViewController: ARViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    var locationManager = CLLocationManager()
    var startedLoadingPlaces = false
    var places: [PlaceOfInterest] = [] {
        willSet {
            setAnnotations(newValue)
        }
    }
    var placeToSend: PlaceOfInterest!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        presenter.presenterTransform = ARPresenterStackTransform()
        presenter.maxVisibleAnnotations = 50        
        
        trackingManager.userDistanceFilter = 25
        trackingManager.reloadDistanceFilter = 75
        uiOptions.closeButtonEnabled = false
        locationManager.delegate = self
        
        presenter.distanceOffsetMode = .automaticOffsetMinDistance
        presenter.distanceOffsetMultiplier = 0.00001
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
        annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 60)
        
        return annotationView
    }
    
    
}

extension GroundViewController: AnnotationViewDelegate {
    
    func didTouch(annotationView: AnnotationView) {
        if let annotation = annotationView.annotation as? PlaceOfInterest {
            
            // Request location details
            ActivityIndicator.shared.startAnimating()
            let request = GooglePlacesRequest(requestType: .details, reference: annotation.reference)
            let dispatcher = NetworkDispatcher(request: request)
            
            placeToSend = PlaceOfInterest(location: annotation.location, reference: annotation.reference, name: annotation.placeName, address: annotation.address)
            
            dispatcher.requestDetails(
                onSuccess: { (detail) in
                    
                    self.placeToSend.phoneNumber = detail.phoneNumber
                    self.placeToSend.website = detail.website
                    
                    let dispatchGroup = DispatchGroup()
                    let imageQueue = DispatchQueue(label: "imageQueue")
                    
                    // Request images of the location
                    if let references = detail.imageReferences {
                        
                        imageQueue.async(group: dispatchGroup, execute: {
                            for imageRef in references {
                                dispatchGroup.enter()
                                let request = GooglePlacesRequest(requestType: .image, imageReference: imageRef)
                                let imageDispatcher = NetworkDispatcher(request: request)
                                
                                imageDispatcher.requestImage(
                                    onSuccess: { (image) in
                                        dispatchGroup.leave()
                                        self.placeToSend.images.append(image)
                                }, onFailure: { (error) in
                                    dispatchGroup.leave()
                                    print("Failure to retrieve image", error)
                                })
                            }
                        })
                    }
                    
                    // Images done downloading
                    dispatchGroup.notify(queue: imageQueue, execute: {
                        DispatchQueue.main.async {
                            ActivityIndicator.shared.stopAnimating()
                            self.performSegue(withIdentifier: "showPlaceDetail", sender: nil)
                        }
                    })
            }, onFailure: { (error) in
                ActivityIndicator.shared.stopAnimating()
                self.present(error: error)
            })
        }
        
    }
    
    // MARK: - Segue detail pass
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailVC = segue.destination as? PlaceDetailViewController {
            detailVC.placeDetail = placeToSend
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
                    let request = GooglePlacesRequest(requestType: .places, location: location, radius: 1500)
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
    
}


