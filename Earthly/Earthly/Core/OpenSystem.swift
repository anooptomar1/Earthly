//
//  OpenSystem.swift
//  Earthly
//
//  Created by Max Rogers on 1/8/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import UIKit
import MapKit

class OpenSystem {
    
    static func phoneCall(withNumber number: String) {
        var phoneNumber = number.replacingOccurrences(of: "-", with: "")
        phoneNumber = number.replacingOccurrences(of: " ", with: "")
        phoneNumber = number.replacingOccurrences(of: "(", with: "")
        phoneNumber = number.replacingOccurrences(of: ")", with: "")
        phoneNumber = number.replacingOccurrences(of: "+", with: "")
        guard let number = URL(string: "tel://" + phoneNumber) else { return }
        self.openURL(url: number)
    }
    
    static func website(withURL url: URL) {
        self.openURL(url: url)
    }
    
    static func maps(forPlace place: PlaceOfInterest) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: place.location.coordinate, addressDictionary: nil))
        mapItem.name = place.placeName
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    fileprivate static func openURL(url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}
