//
//  GameFinished.swift
//  CannonGame
//
//  Created by Thomas Attermann on 03/05/2016.
//  Copyright © 2016 Thomas Attermann. All rights reserved.
//

import SpriteKit

class GameFinished: SKScene {
    
    var score = 0
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let game:GameScene = GameScene(fileNamed: "GameScene")!
        game.scaleMode = .AspectFill
        let transition = SKTransition.crossFadeWithDuration(1.0)
        self.view?.presentScene(game, transition: transition)    }
    
    override func didMoveToView(view: SKView) {
        
    }
    

}
