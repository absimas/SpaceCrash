//
//  SpaceShip.swift
//  SpaceCrash
//
//  Created by Simas Abramovas on 27/03/15.
//  Copyright (c) 2015 Simas Abramovas. All rights reserved.
//

import SpriteKit

class SpaceShip : SKSpriteNode {
    
    let ATLAS_NAME              = "SpaceShip"
    let TEXTURE_NAME_FORMAT     = "SpaceShip%d"
    let ACTION_MOVEMENT         = "movement_action"
    let ACTION_ANIMATE          = "animate_action"
    let ACTION_ANIMATE_RESTORE  = "animate_restore_action"
    
    let atlas: SKTextureAtlas
    let textureCountPerSide: Int
    let defaultTexture : SKTexture
    let leftTextures = [SKTexture]()
    let rightTextures = [SKTexture]()
    
    var queuedMovement : Direction?
    var movementDelay = NSTimeInterval(0)
    var restoring = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        // Texture atlas
        atlas = SKTextureAtlas(named: ATLAS_NAME)
        
        // Default texture
        defaultTexture = atlas.textureNamed(String(format: TEXTURE_NAME_FORMAT, arguments: [0]))

        // Left and right textures
        textureCountPerSide = (atlas.textureNames.count - 1) / 2;
        for i in reverse(-textureCountPerSide..<0) {
            leftTextures += [atlas.textureNamed(String(format: TEXTURE_NAME_FORMAT, arguments: [i]))]
        }
        for i in 1...textureCountPerSide {
            rightTextures += [atlas.textureNamed(String(format: TEXTURE_NAME_FORMAT, arguments: [i]))]
        }
        super.init(texture: defaultTexture, color: nil, size: CGSizeMake(102.4, 72.4))

        // Physics
        physicsBody = SKPhysicsBody(texture: texture, size: size)
        physicsBody!.dynamic = false
        physicsBody!.categoryBitMask = SpaceScene.Mask.SPACE_SHIP
        physicsBody!.contactTestBitMask = SpaceScene.Mask.SPACE_SHIP | SpaceScene.Mask.ASTEROID | SpaceScene.Mask.SCENE
        physicsBody!.collisionBitMask = SpaceScene.Mask.SPACE_SHIP | SpaceScene.Mask.ASTEROID | SpaceScene.Mask.SCENE
    }
    
    
    // ToDo Movement/Animation actions easeIn. When restoring everything should be faster.
    func move(direction: Direction) {
        if restoring {
            queuedMovement = direction
            return
        }
        
        // Restore default texture gradually
        returnToDefault()
        
        // ToDo queue animate after restoration
            // However movement will have to be executed
        
        
        // ToDo make a movement action that increases its speed gradually based on current texture index
        
        switch (direction) {
        case .Left:
            runAction(SKAction.animateWithTextures(leftTextures, timePerFrame: 0.1, resize: false, restore: false), withKey: ACTION_ANIMATE)
        case .Right:
            runAction(SKAction.animateWithTextures(rightTextures, timePerFrame: 0.1, resize: false, restore: false), withKey: ACTION_ANIMATE)
        default:
            return
        }
        movementBasedOnCurrentTexture()
    }
    
    func movementBasedOnCurrentTexture() {
        runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock({
                // Calc movement speed and duration based on current texture
                if let index = self.getCurrentTextureIndex() {
                    let index = CGFloat(index)
                    let by = CGVectorMake(1 * index, 0)
                    let duration = NSTimeInterval(abs(0.1 * index))
                    self.runAction(SKAction.moveBy(by, duration: duration))
                    self.movementDelay = duration
                }
            }),
            SKAction.waitForDuration(movementDelay)
        ])), withKey: self.ACTION_MOVEMENT)
    }
    
    func stopMovement() {
        queuedMovement = nil
        
        // Restore default texture gradually
        returnToDefault()
        
        // Remove movement and animation actions
        removeActionForKey(ACTION_ANIMATE)
    }
    
    func returnToDefault() {
        if let curTextureInfo = getCurrentTextureInfo() {
            var textures : [SKTexture]
            switch (curTextureInfo.1) {
            case .Left:
                // From left to default
                textures = Array(leftTextures[0...curTextureInfo.0].reverse())
            case .Right:
                // From right to default
                textures = Array(rightTextures[0...curTextureInfo.0].reverse())
            default:
                return
            }
            textures += [defaultTexture]
            
            runAction(SKAction.sequence([
                SKAction.runBlock({
                    self.restoring = true
                }),
                // ToDo make restoration faster also possibly easeIn
                SKAction.animateWithTextures(textures, timePerFrame: 0.1, resize: false, restore: false),
                SKAction.runBlock({
                    self.restoring = false
                    // Restoration done
                    // Remove ongoing movements
                    self.removeActionForKey(self.ACTION_MOVEMENT)
                    // Run queued movement (if any)
                    if let queuedMovement = self.queuedMovement {
                        self.move(queuedMovement)
                    }
                    // ToDo what about left -> release -> left before restoration ended?
                        // ToDo LEFT_RESTORATION / RIGHT_RESTORIATION if appropriate movement is executed, remove restoration and continue animate
                })
            ]), withKey: ACTION_ANIMATE_RESTORE)
        }
    }
    
    func getCurrentTextureInfo() -> (Int, Direction)? {
        if let texture = texture {
            if texture == defaultTexture {
                return (0, .None)
            } else if let index = find(leftTextures, texture) {
                return (index, .Left)
            } else if let index = find(rightTextures, texture) {
                return (index, .Right)
            }
        }
        
        return nil
    }
    
    func getCurrentTextureIndex() -> Int? {
        if let info = getCurrentTextureInfo() {
            switch (info.1) {
            case .Left:
                return -info.0
            case .Right:
                return info.0
            case .None:
                return 0
            default:
                return nil
            }
        }
        return nil
    }
    
    func shoot() {
        // ToDo delay between shots
        
        // ToDo based where the guns are, based on cur texture
//        getCurrentTextureIndex()
        
        let leftLaser = Laser()
        let rightLaser = Laser()
        
        // Position lasers (depends on the ship position and texture)
        leftLaser.position = scene!.convertPoint(CGPointMake(43, 50), fromNode: self)
        rightLaser.position = scene!.convertPoint(CGPointMake(-43, 50), fromNode: self)
        
        // Add the laser to scene
        scene?.addChild(leftLaser)
        scene?.addChild(rightLaser)

        // ToDo group movement?
        leftLaser.startMovement()
        rightLaser.startMovement()
    }
    
}