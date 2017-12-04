//
//  AnimationMovement.swift
//  Earthly
//
//  Created by Max Rogers on 12/4/17.
//  Copyright © 2017 Max Rogers. All rights reserved.
//

import Foundation

enum AnimationMovement: UInt32 {
    case TopBottom
    case BottomTop
    case LeftRight
    case RightLeft
    
    private static let count: AnimationMovement.RawValue = {
        var maxValue: UInt32 = 0
        while let _ = AnimationMovement(rawValue: maxValue) {
            maxValue += 1
        }
        return maxValue
    }()
    
    static func randomMovement() -> AnimationMovement {
        let random = arc4random_uniform(count)
        return AnimationMovement(rawValue: random)!
    }
    
}
