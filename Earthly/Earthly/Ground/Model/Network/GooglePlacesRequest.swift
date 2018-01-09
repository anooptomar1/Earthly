//
//  GooglePlacesRequest.swift
//  Earthly
//
//  Created by Max Rogers on 1/8/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import Foundation

struct GooglePlacesRequest {
    
    // MARK: - Properties
    
    let urlString: String
    var endPointURL: URL? {
        return URL(string: urlString)
    }
    let requestType: RequestType
    
    init(requestType: RequestType, location: CLLocation, radius: Int) {
        self.requestType = requestType
        if let path = Bundle.main.path(forResource: "GoogleKeys", ofType: "plist") {
            guard let key = NSDictionary(contentsOfFile: path) as? [String : String],
                let apiKey = key["apiKey"] else { urlString = ""; return}
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            if requestType == .places {
                urlString = GoogleURL.base + "nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&sensor=true&types=establishment&key=\(apiKey)"
            } else {
                urlString = ""
            }
        } else {
            urlString = ""
        }
    }
    
    init(requestType: RequestType, reference: String) {
        self.requestType = requestType
        if let path = Bundle.main.path(forResource: "GoogleKeys", ofType: "plist") {
            guard let key = NSDictionary(contentsOfFile: path) as? [String : String],
                let apiKey = key["apiKey"] else { urlString = ""; return }
            if requestType == .details {
                urlString = GoogleURL.base + "details/json?reference=\(reference)&sensor=true&key=\(apiKey)"
            } else {
                urlString = ""
            }
        } else {
            urlString = ""
        }
    }
    
    init(requestType: RequestType, imageReference: String) {
        self.requestType = requestType
        if let path = Bundle.main.path(forResource: "GoogleKeys", ofType: "plist") {
            guard let key = NSDictionary(contentsOfFile: path) as? [String : String],
                let apiKey = key["apiKey"] else { urlString = ""; return }
            if requestType == .image {
                urlString = GoogleURL.base + "photo?maxwidth=350&photoreference=\(imageReference)&key=\(apiKey)"
            } else {
                urlString = ""
            }
        } else {
            urlString = ""
        }
    }
    
}

enum RequestType {
    case places, details, image
}

struct GoogleURL {
    
    static let base = "https://maps.googleapis.com/maps/api/place/"
    
}
