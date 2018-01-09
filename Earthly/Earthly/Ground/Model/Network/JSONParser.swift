//
//  JSONParser.swift
//  Earthly
//
//  Created by Max Rogers on 1/8/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import Foundation

class JSONParser {
    
    static func parsePlaces(withData data: Data) -> [PlaceOfInterest]? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonData = json as? [String : Any],
            let placesArray = jsonData["results"] as? [NSDictionary] else { return nil }
            
            var placesOfInterest: [PlaceOfInterest] = []
            for place in placesArray {
                guard let latitude = place.value(forKeyPath: "geometry.location.lat") as? CLLocationDegrees,
                let longitude = place.value(forKeyPath: "geometry.location.lng") as? CLLocationDegrees,
                let reference = place.object(forKey: "reference") as? String,
                let name = place.object(forKey: "name") as? String,
                let address = place.object(forKey: "vicinity") as? String
                    else { continue }
                let location = CLLocation(latitude: latitude, longitude: longitude)
                if let newPlace = PlaceOfInterest(location: location, reference: reference, name: name, address: address) {
                    placesOfInterest.append(newPlace)
                }
            }
            
            return placesOfInterest

        } catch let parseError {
            print("Error Parsing JSON", parseError)
            return nil
        }
    }
    
    static func parseDetails(withData data: Data) -> PlaceDetail? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonData = json as? [String : Any],
                let detailDict = jsonData["result"] as? [String : Any] else { return nil }
            
            let phoneNumber = detailDict["formatted_phone_number"] as? String
            let website = detailDict["website"] as? String
            
            var imageRefs: [String]? = []
            if let photos = detailDict["photos"] as? [[String : Any]] {
                for (index, photo) in photos.enumerated() {
                    if index <= 4 {
                        if let refString = photo["photo_reference"] as? String {
                            imageRefs?.append(refString)
                        }
                    } else {
                        break
                    }
                }
            }
            
            if imageRefs?.count == 0 {
                imageRefs = nil
            }
            
            return PlaceDetail(phoneNumber: phoneNumber, website: website, imageReferences: imageRefs)
            
        } catch let parseError {
            print("Error Parsing JSON", parseError) 
            return nil
        }
    }
    
    
}
