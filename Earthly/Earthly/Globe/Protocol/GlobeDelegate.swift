//
//  GlobeProtocol.swift
//  Earthly
//
//  Created by Max Rogers on 1/6/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import Foundation

protocol GlobeDelegate: class {
    func shouldZoom(toCoordinates coordinates: CLLocationCoordinate2D, withScope scope: LocationScope)
}
