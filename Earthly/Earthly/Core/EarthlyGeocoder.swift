//
//  EarthlyGeocoder.swift
//  Earthly
//
//  Created by Max Rogers on 1/6/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import Foundation

class EarthlyGeocoder {
    
    // MARK: - Properties
    
    static let shared = EarthlyGeocoder()
    lazy var geocoder = CLGeocoder()
    
    // MARK: - Forward Geocode
    
    func forwardGeocode(textQuery text: String, completion: @escaping (_ locations: [SearchableLocation]) -> Void) {
        geocoder.geocodeAddressString(text) { (placemarks, error) in
            let newLocations = self.processGeocodeResponse(withPlacemarks: placemarks, error: error)
            completion(newLocations)
        }
    }
    
    func processGeocodeResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) -> [SearchableLocation] {
        guard error == nil else { print("Didn't find location"); return [] }
        
        var searchableLocations: [SearchableLocation] = []
        
        if let placemarks = placemarks, placemarks.count > 0 {
            for placemark in placemarks {
                if let location = placemark.location {
                    searchableLocations.append(SearchableLocation(name: placemark.compactAddress ?? "", coordinates: location.coordinate))
                }
            }
        }
        
        return searchableLocations
    }
    
    
}
