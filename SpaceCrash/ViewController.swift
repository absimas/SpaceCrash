//
//  ViewController.swift
//  SpaceCrash
//
//  Created by Simas Abramovas on 27/03/15.
//  Copyright (c) 2015 Simas Abramovas. All rights reserved.
//

import SpriteKit

class ViewController: UIViewController {
    
    var skView: SKView { return self.view as SKView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skView.presentScene(SpaceScene(size: skView.frame.size))
    }
    
    // Auto layout methods
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        updateSceneSize(toInterfaceOrientation)
    }
    
    func updateSceneSize(toInterfaceOrientation: UIInterfaceOrientation) {
        skView.scene?.size = view.frame.size
        if let scene = skView.scene as? Resizable {
            scene.resize()
        }
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.All.rawValue)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


}

