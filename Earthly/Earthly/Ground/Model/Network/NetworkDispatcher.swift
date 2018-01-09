//
//  NetworkDispatcher.swift
//  Earthly
//
//  Created by Max Rogers on 1/8/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import Foundation

class NetworkDispatcher: GooglePlacesAPIClient {
    
    // MARK: - Properties
    
    private let googlePlacesRequest: GooglePlacesRequest
    
    // MARK: - Initialization
    
    required init(request: GooglePlacesRequest) {
        googlePlacesRequest = request
    }
    
    // MARK: - Network Request
    
    func requestPlaces(onSuccess: @escaping PlacesCallback, onFailure: @escaping NetworkErrorCallback) {
        
        guard let url = googlePlacesRequest.endPointURL else { onFailure(.unknown); return }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else { onFailure(.failedRequest); return }
            if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    onSuccess(JSONParser.parsePlaces(withData: data) ?? [])
                } else {
                    onFailure(.failedRequest)
                }
            } else {
                onFailure(.unknown)
            }
        }.resume()
    }
    
    func requestDetails(onSuccess: @escaping PlaceDetailCallback, onFailure: @escaping NetworkErrorCallback) {
        
        guard let url = googlePlacesRequest.endPointURL else { onFailure(.unknown); return }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else { onFailure(.failedRequest); return }
            if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    if let details = JSONParser.parseDetails(withData: data) {
                        onSuccess(details)
                    } else {
                        onFailure(.unknown)
                    }
                } else {
                    onFailure(.failedRequest)
                }
            } else {
                onFailure(.unknown)
            }
        }.resume()
    }
    
    
}
