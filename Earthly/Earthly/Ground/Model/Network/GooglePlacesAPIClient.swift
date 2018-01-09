//
//  GooglePlacesAPIClient.swift
//  Earthly
//
//  Created by Max Rogers on 1/8/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import UIKit

typealias PlacesCallback = ([PlaceOfInterest]) -> Void
typealias PlaceDetailCallback = (PlaceDetail) -> Void
typealias ImageCallback = (UIImage) -> Void
typealias NetworkErrorCallback = (PlacesNetworkError) -> Void

protocol GooglePlacesAPIClient {
    func requestPlaces(onSuccess: @escaping PlacesCallback,
                              onFailure: @escaping NetworkErrorCallback)
    func requestDetails(onSuccess: @escaping PlaceDetailCallback, onFailure: @escaping NetworkErrorCallback)
    func requestImage(onSuccess: @escaping ImageCallback, onFailure: @escaping NetworkErrorCallback)
}

// MARK: - Network Error Enum

enum PlacesNetworkError: Error {
    case unknown
    case failedRequest
    case invalidResponse
}

