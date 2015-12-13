//
//  IntroViewController.swift
//  SnakeEye
//
//  Created by Oliver Nielsen on 13/12/15.
//  Copyright © 2015 Oliver Nielsen. All rights reserved.
//

import Foundation
import UIKit


class IntroViewController: ViewController {
    
    
    lazy var startButton: UIButton = {
        var button = UIButton(type: .Custom)
        button.layer.cornerRadius = 10
        button.backgroundColor = .greenColor()
        button.addTarget(self, action: "startGame:", forControlEvents: .TouchUpInside)
        button.setTitle("Start Game", forState: UIControlState.Normal)
        
        return button
    }()
    
    override init() {
        super.init()
        
        self.view.backgroundColor = UIColor.orangeColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSubviews()
        self.setupConstraints()
    }
    
    private func setupSubviews() {
        self.view.addSubview(self.startButton)
    }
    
    private func setupConstraints() {
        self.startButton.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.centerY.equalTo(self.startButton.superview!)
            make.left.equalTo(self.startButton.superview!).offset(40)
            make.right.equalTo(self.startButton.superview!).offset(-40)
        }
    }
    
    func startGame(sender: UIButton!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
}
