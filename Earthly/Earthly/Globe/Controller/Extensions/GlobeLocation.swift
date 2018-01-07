//
//  GlobeLocation.swift
//  Earthly
//
//  Created by Max Rogers on 1/6/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import Foundation

extension GlobeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            earthlyLocationManager.startUpdatingLocation()
            guard let location = manager.location else { return }
            shouldZoom(toCoordinates: location.coordinate, withScope: .country, displayMarker: false)
        }
    }
    
}
