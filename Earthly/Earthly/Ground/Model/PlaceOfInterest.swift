//
//  PlaceOfInterest.swift
//  Earthly
//
//  Created by Max Rogers on 1/8/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import Foundation
import CoreLocation
import HDAugmentedReality

class PlaceOfInterest: ARAnnotation {
    
    // MARK: - Properties
    
    let reference: String
    let placeName: String
    let address: String
    var phoneNumber: String?
    var website: String?
    var images: [UIImage] = []
    
    var infoText: String {
        get {
            var info = "Address: \(address)"
            
            if phoneNumber != nil {
                info += "\nPhone: \(phoneNumber!)"
            }
            
            if website != nil {
                info += "\nWeb: \(website!)"
            }
            return info
        }
    }
    
    override var description: String {
        return placeName
    }
    
    // MARK: - Initialization
    
    init?(location: CLLocation, reference: String, name: String, address: String) {
        placeName = name
        self.reference = reference
        self.address = address

        super.init(identifier: nil, title: name, location: location)
    }

}
