//
//  MediaManager.swift
//  Earthly
//
//  Created by Max Rogers on 12/3/17.
//  Copyright © 2017 Max Rogers. All rights reserved.
//

import Foundation

class MediaManager {
    
    // MARK: - Properties
    
    private static let fileManager = FileManager.default
    
    // MARK: - Save video to documents
    
    static func downloadVideo(withURL url: URL) {
        do {
            let videoData = try Data(contentsOf: url)
            guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let videoPath = documentsDirectory.appendingPathComponent("/SpaceBackground.mov")
            try videoData.write(to: videoPath)
        } catch let error {
            print("Error downloading or saving video", error)
        }
    }
    
    // MARK: - Query documents for video
    
    static func retrieveVideoURL() -> URL? {
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let possibleFilePath = documentsDirectory.appendingPathComponent("/SpaceBackground.mov").path
        if fileManager.fileExists(atPath: possibleFilePath) {
            return URL(fileURLWithPath: possibleFilePath)
        } else {
            return nil
        }
    }
    
}
