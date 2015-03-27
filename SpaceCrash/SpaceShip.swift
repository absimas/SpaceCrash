//
//  SpaceShip.swift
//  SpaceCrash
//
//  Created by Simas Abramovas on 27/03/15.
//  Copyright (c) 2015 Simas Abramovas. All rights reserved.
//

import SpriteKit

class SpaceShip : SKSpriteNode {
    
    let ATLAS_NAME = "SpaceShip"
    let TEXTURE_NAME_FORMAT = "SpaceShip%d"
    let ACTION_MOVEMENT_LEFT    = "movement_left_action"
    let ACTION_MOVEMENT_RIGHT   = "movement_right_action"
    let ACTION_ANIMATE          = "animate_action"
    let ACTION_ANIMATE_RESTORE  = "animate_restore_action"
    let atlas: SKTextureAtlas
    
    let defaultTexture : SKTexture
    let leftTextures = [SKTexture]()
    let rightTextures = [SKTexture]()
    
    var queuedMovement : Direction?
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
        let textureCount = (atlas.textureNames.count - 1) / 2;
        for i in reverse(-textureCount..<0) {
            leftTextures += [atlas.textureNamed(String(format: TEXTURE_NAME_FORMAT, arguments: [i]))]
        }
        for i in 1...textureCount {
            rightTextures += [atlas.textureNamed(String(format: TEXTURE_NAME_FORMAT, arguments: [i]))]
        }
        
        println("\(leftTextures.count) vs \(rightTextures.count)")
        super.init(texture: defaultTexture, color: nil, size: CGSize(width: 102.4, height: 72.4))
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
        switch (direction) {
        case .Left:
            runAction(SKAction.repeatActionForever(SKAction.moveBy(CGVector(dx: -5, dy: 0), duration: 0.03)), withKey: ACTION_MOVEMENT_LEFT)
            runAction(SKAction
                .animateWithTextures(leftTextures, timePerFrame: 0.1, resize: false, restore: false), withKey: ACTION_ANIMATE)
            return
        case .Right:
            runAction(SKAction.repeatActionForever(SKAction.moveBy(CGVector(dx: 5, dy: 0), duration: 0.03)), withKey: ACTION_MOVEMENT_RIGHT)
            runAction(SKAction
                .animateWithTextures(rightTextures, timePerFrame: 0.1, resize: false, restore: false), withKey: ACTION_ANIMATE)
            return
        default:
            return
        }
    }
    
    func stopMovement() {
        queuedMovement = nil
        
        // Restore default texture gradually
        returnToDefault()
        
        // Remove movement and animation actions
        removeActionForKey(ACTION_MOVEMENT_LEFT)
        removeActionForKey(ACTION_MOVEMENT_RIGHT)
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
                    // Restoration done, can run queued movement now
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
                return nil
            } else if let index = find(leftTextures, texture) {
                return (index, .Left)
            } else if let index = find(rightTextures, texture) {
                return (index, .Right)
            }
        }
        
        return nil
    }
    
}