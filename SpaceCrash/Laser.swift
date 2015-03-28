//
//  Laser.swift
//  SpaceCrash
//
//  Created by Simas Abramovas on 3/28/15.
//  Copyright (c) 2015 Simas Abramovas. All rights reserved.
//

import SpriteKit
import AVFoundation

class Laser : SKSpriteNode {
    
    let LASER_SIZE = CGSizeMake(5, 40)
    let LASER_SOUND_FILE = "LaserSound.mp3"
//    let laserSoundAction : SKAction
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {

        super.init(texture: nil, color: SKColor.redColor(), size: LASER_SIZE)
        
        // Preload sound
//        self.laughSound = [SKAction playSoundFileNamed:@"laugh.caf" waitForCompletion:NO];
//        self.owSound = [SKAction playSoundFileNamed:@"ow.caf" waitForCompletion:NO];
//        
//        NSURL *url = [[NSBundle mainBundle] URLForResource:@"whack" withExtension:@"caf"];
//        NSError *error = nil;
//        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//        
//        if (!self.audioPlayer) {
//            NSLog(@"Error creating player: %@", error);
//        }
//        
//        [self.audioPlayer play];
        
        
        
        
        // Physics
        physicsBody = SKPhysicsBody(rectangleOfSize: LASER_SIZE)
        physicsBody!.categoryBitMask = SpaceScene.Mask.LASER
        physicsBody!.contactTestBitMask = SpaceScene.Mask.LASER | SpaceScene.Mask.ASTEROID
        physicsBody!.collisionBitMask = SpaceScene.Mask.LASER | SpaceScene.Mask.ASTEROID
    }
    
    func startMovement() {
        runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.moveBy(CGVectorMake(0, 100), duration: 0.2),
            SKAction.runBlock({
                if self.position.y > self.parent?.frame.height {
                    self.remove()
                }
            }),
        ])))
        runAction(laserSound!)
    }
    
    func remove() {
        self.removeFromParent()
        self.removeAllActions()
    }

}
