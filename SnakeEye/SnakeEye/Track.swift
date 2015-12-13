//
//  Track.swift
//  SnakeEye
//
//  Created by Oliver Nielsen on 13/12/15.
//  Copyright © 2015 Oliver Nielsen. All rights reserved.
//

import Foundation

public struct TrackConstants {
    static let kTrackValues = "values"
    static let kTrackValuesFrame = "frame"
    static let kTrackValuesFrameAvg = "avg"
    static let kTrackValuesFrameAvgX = "x"
    static let kTrackValuesFrameAvgY = "y"
}

class Track: NSObject {
    
    var x: NSNumber
    var y: NSNumber
    
    
    override init() {
        self.x = 0
        self.y = 0
    }
    
    convenience init(let x: NSNumber, let y: NSNumber) {
        self.init()
        
        self.x = x
        self.y = y
    }
    
}