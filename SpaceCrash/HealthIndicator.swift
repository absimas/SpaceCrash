//
//  HealthIndicator.swift
//  SpaceCrash
//
//  Created by Simas Abramovas on 3/28/15.
//  Copyright (c) 2015 Simas Abramovas. All rights reserved.
//

import SpriteKit

class HealthIndicator : SKSpriteNode {
    
    struct Const {
        static let TOTAL_HEALTH = 10 as CGFloat
        static let STROKE_WIDTH = 4 as CGFloat
        static let INDICATOR_SIZE = CGSizeMake(100 + Const.STROKE_WIDTH, 20 + Const.STROKE_WIDTH)
        static let HEALTH_SIZE = CGSizeMake(Const.INDICATOR_SIZE.width - Const.STROKE_WIDTH,
            Const.INDICATOR_SIZE.height - Const.STROKE_WIDTH)
        static let RESIZE_DURATION = 0.5
    }
    
    let healthNode : SKSpriteNode
    
    var health = Const.TOTAL_HEALTH
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        healthNode = SKSpriteNode(texture: nil, color: SKColor.redColor(), size: Const.HEALTH_SIZE)
        super.init(texture: nil, color: SKColor.blackColor(), size: Const.INDICATOR_SIZE)

        // Anchors
        let anchor = CGPointMake(0, 1)
        healthNode.anchorPoint = anchor
        anchorPoint = anchor
        
        // Position (to make the bg indicator visible)
        healthNode.position = CGPointMake(Const.STROKE_WIDTH / 2, -Const.STROKE_WIDTH / 2)
        
        // Fill up with health
        addChild(healthNode)
    }
    
    func decreaseHealth() -> Bool {
        println("Dec health. Cur is \(health)")
        if health > 0 {
            --health
            let width = Const.TOTAL_HEALTH * health
            healthNode.runAction(SKAction.resizeToWidth(width, duration: Const.RESIZE_DURATION))
            return true
        } else {
            return false
        }
    }
    
}