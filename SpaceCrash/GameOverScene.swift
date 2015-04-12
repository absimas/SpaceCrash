//
//  GameOverScene.swift
//  SpaceCrash
//
//  Created by Simas Abramovas on 3/28/15.
//  Copyright (c) 2015 Simas Abramovas. All rights reserved.
//

import SpriteKit

class GameOverScene : SKScene, Resizable {
    
    let GAME_OVER_TEXT = "Game Over..."
    let RESTART_TEXT = "Restart!"
    let FONT_SIZE = 60 as CGFloat
    
    var endLabel : SKLabelNode?
    var restartLabel : ClickableLabel?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        scaleMode = .AspectFit
        
        endLabel = SKLabelNode(text: GAME_OVER_TEXT)
        endLabel!.fontName = "Optima-ExtraBlack"
        endLabel!.horizontalAlignmentMode = .Left
        endLabel!.verticalAlignmentMode = .Center
        // Size: default or fit to width
        endLabel!.fontSize = FONT_SIZE
        while (endLabel?.frame.width > frame.width) {
            --endLabel!.fontSize
        }
        addChild(endLabel!)
        
        // Restart label
        restartLabel = ClickableLabel(text: RESTART_TEXT, began: nil) { () -> () in
            let doorsOpenX = SKTransition.doorsOpenHorizontalWithDuration(0.5)
            self.view?.presentScene(SpaceScene(size: self.size), transition: doorsOpenX)
        }
        restartLabel!.fontName = "Optima-ExtraBlack"
        restartLabel!.horizontalAlignmentMode = .Left
        restartLabel!.verticalAlignmentMode = .Center
        restartLabel!.fontColor = UIColor.redColor()
        // Size: default or fit to width
        restartLabel!.fontSize = FONT_SIZE
        while (restartLabel?.frame.width > frame.width) {
            --restartLabel!.fontSize
        }
        addChild(restartLabel!)
        
        resize()
    }
    
    func resize() {
        if let endLabel = endLabel {
            endLabel.position = CGPoint(x: (frame.width - endLabel.frame.width) / 2,
                y: frame.height / 2 + endLabel.frame.height)
            
            if let restartLabel = restartLabel {
                restartLabel.position = CGPoint(x: (frame.width - restartLabel.frame.width) / 2,
                    y: frame.height / 2 - endLabel.frame.height)
            }
        }
    }
    
}