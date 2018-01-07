//
//  SearchableLocation.swift
//  Earthly
//
//  Created by Max Rogers on 1/6/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import Foundation

struct SearchableLocation {
    
    // MARK: - Properties
    
    var name: String
    var coordinates: CLLocationCoordinate2D
    var scope: LocationScope
    
    // MARK: - Initialization
    
    init(name: String, coordinates: CLLocationCoordinate2D) {
        self.name = name
        self.coordinates = coordinates
        switch name.components(separatedBy: "•").count {
        case 0:
            scope = .country
        case 1:
            scope = .state
        case 2:
            scope = .city
        case 3:
            scope = .street
        default:
            scope = .state
        }
    }
}

// MARK: - Scope

enum LocationScope {
    case street, city, state, country
}

// MARK: - Format Location Name

extension CLPlacemark {
    
    var compactAddress: String? {
        if let name = name {
            
            var result = ""
            
            if let street = thoroughfare {
                result += "\(street) •"
            }
            
            if let city = locality {
                result += " \(city) •"
            }
            
            if let state = administrativeArea {
                result += " \(state) •"
            }
            
            if let country = country {
                result += " \(country)"
            }
            
            if result == "" {
                result = name
            }
            
            return result
        }
        
        return nil
    }
    
}
