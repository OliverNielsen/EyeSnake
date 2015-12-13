//
//  MainViewController.swift
//  SnakeEye
//
//  Created by Oliver Nielsen on 13/12/15.
//  Copyright © 2015 Oliver Nielsen. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class MainViewController: ViewController {
    
    private let viewSize: CGFloat = 20
    private let timeInterval: Double = 0.05
    
    // MARK: - Lazy instantiation
    
    lazy var fromIntro: Bool = {
        return false;
    }()
    
    lazy var playerView: UIView = {
        var playerView = UIView()
        playerView.layer.cornerRadius = 20 / 2
        playerView.backgroundColor = .greenColor()
        
        return playerView
    }()
    
    lazy var foodView: UIView = {
        var foodView = UIView()
        foodView.backgroundColor = .redColor()
        
        return foodView
    }()
    
    lazy var mainViewModel: MainViewModel = {
        return MainViewModel()
    }()
    
    var gameUpdateTimer: NSTimer?
    
    
    // MARK: - Implementation
    
    override init() {
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainViewModel.loadFile()
        
        self.setupSubviews()
        self.resetGame()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Find a smarter way to handle startup of game
        if self.fromIntro {
            self.startGame()
        }
        else {
            self.fromIntro = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.resetGame()
    }
    
    private func setupSubviews() -> Void {
        self.view.addSubview(self.foodView)
        self.view.addSubview(self.playerView)
    }
    
    // MARK: - Game logic
    
    private func startGame() -> Void {
        self.mainViewModel.startGame()
        
        self.gameUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(self.timeInterval), target: self, selector: "detectContact", userInfo: nil, repeats: true)
            
        for var i = 0; i < self.mainViewModel.trackArray.count; i++ {
            let track = self.mainViewModel.trackArray[i]
            
            self.performSelector(Selector("performMove:"), withObject: track, afterDelay: NSTimeInterval(Double(i + 1) * self.timeInterval))
        }
    }
    
    private func resetGame() -> Void {
        self.gameUpdateTimer?.invalidate()
        
        self.playerView.snp_updateConstraints { (make) -> Void in
            make.width.height.equalTo(viewSize)
            make.center.equalTo(self.playerView.superview!)
        }
        
        self.foodView.snp_updateConstraints { (make) -> Void in
            make.width.height.equalTo(viewSize)
            make.center.equalTo(self.handleCoordinate(Track(x: 300, y: 600)))
        }
    }
    
    func performMove(let track: Track) -> Void {
        self.playerView.snp_updateConstraints { (make) -> Void in
            make.width.height.equalTo(viewSize)
            make.center.equalTo(self.handleCoordinate(track))
        }
    }
    
    func detectContact() -> Void {
        if CGRectIntersectsRect(self.playerView.frame, self.foodView.frame) {
            self.handleContact()
        }
    }
    
    private func handleContact() -> Void {
        let finished = self.mainViewModel.noteTime()
        
        
        if finished {
            self.gameUpdateTimer?.invalidate()
            
            self.handleFinishedGame()
        }
        else {
            self.foodView.snp_updateConstraints { (make) -> Void in
                make.width.height.equalTo(viewSize)
                make.center.equalTo(self.handleCoordinate(Track(x: 50, y: 50))) // These should be random values in the future
            }
        }
    }
    
    private func handleFinishedGame() {
        let avgResponseTime = self.mainViewModel.averageResponseTime()
        
        let finishedAlert = UIAlertController(title: "Game Completed", message: "Your average response time was " + String(avgResponseTime) + "ms", preferredStyle: UIAlertControllerStyle.Alert)
        let againAlertAction = UIAlertAction(title: "Want to play again?", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.resetGame()
            self.startGame()
        }
        
        finishedAlert.addAction(againAlertAction)
        
        self.presentViewController(finishedAlert, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func handleCoordinate(let track: Track) -> CGPoint {
        let screenWidth = self.view.frame.width / 2
        let screenHeight = self.view.frame.height / 2
        
        let xValue = CGFloat(track.x) - screenWidth
        let yValue = screenHeight - CGFloat(track.y)
        
        return CGPointMake(xValue, yValue)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}