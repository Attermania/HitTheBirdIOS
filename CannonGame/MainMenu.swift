//
//  MainMenu.swift
//  CannonGame
//
//  Created by Thomas Attermann on 01/05/2016.
//  Copyright © 2016 Thomas Attermann. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let game:GameScene = GameScene(fileNamed: "GameScene")!
        game.scaleMode = .AspectFill
        let transition = SKTransition.crossFadeWithDuration(1.0)
        self.view?.presentScene(game, transition: transition)
    }

}
