//
//  MainViewModel.swift
//  SnakeEye
//
//  Created by Oliver Nielsen on 13/12/15.
//  Copyright © 2015 Oliver Nielsen. All rights reserved.
//

import Foundation
import SwiftyJSON

class MainViewModel: NSObject {
    
    private let numberOfFood: NSInteger = 2
    
    // MARK: - Lazy instantiation
    
    lazy var trackArray: NSArray = {
        return []
    }()
    
    private lazy var resultTimesArray: NSArray = {
        return []
    }()
    
    private var startDate: NSDate?
    
    // MARK: - Implementation
    
    // MARK: - Game logic
    
    func startGame() {
        self.resultTimesArray = []
        self.startDate = NSDate()
    }
    
    func noteTime() -> Bool {
        if self.startDate != nil {
            var tempTimeInterval = abs(Double((self.startDate?.timeIntervalSinceNow)!)) // NSTimeInterval -> Double -> Abs of the double
            tempTimeInterval *= 1000 // sec to ms
            
            let timeInterval = self.threeDecimals(tempTimeInterval)
            self.resultTimesArray = self.resultTimesArray.arrayByAddingObject(timeInterval)
        }
        
        if self.resultTimesArray.count == self.numberOfFood {
            self.startDate = nil
            
            return true
        }
        else {
            self.startDate = NSDate()
            
            return false
        }
    }
    
    func averageResponseTime() -> Double {
        var tempTotalResult = 0.0;
        
        for (var i = 0; i < self.resultTimesArray.count; i++) {
            tempTotalResult += self.resultTimesArray[i].doubleValue
        }
        
        tempTotalResult /= Double(self.resultTimesArray.count)
        
        return self.threeDecimals(tempTotalResult)
    }
    
    // MARK: - File data
    
    func loadFile() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { () -> Void in
            let filePath = NSBundle.mainBundle().pathForResource("EyeTrackerTestDataArray", ofType: "json")
            
            var data: NSData?
            
            do {
                try data = NSData(contentsOfFile: filePath!, options: NSDataReadingOptions.DataReadingUncached)
            }
            catch {
                assert(false, "Something went wrong")
            }
            
            self.processData(data)
        }
    }
    
    private func processData(let data: NSData?) {
        let returnedData = data != nil ? JSON(data: data!) : nil
    
        
        for (_, values):(String, JSON) in returnedData {
            let dict = values[TrackConstants.kTrackValues][TrackConstants.kTrackValuesFrame][TrackConstants.kTrackValuesFrameAvg]
            let x = dict[TrackConstants.kTrackValuesFrameAvgX].numberValue
            let y = dict[TrackConstants.kTrackValuesFrameAvgY].numberValue
            
            let track = Track(x: x, y: y)
            
            self.trackArray = self.trackArray.arrayByAddingObject(track)
        }
    }
    
    // MARK: - Helpers
    
    // 3 decimals (2 decimals is 100 etc)
    func threeDecimals(number: Double) -> Double {
        return round(1000 * number) / 1000
    }
    
}
