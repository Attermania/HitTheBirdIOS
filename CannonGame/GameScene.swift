//
//  GameScene.swift
//  CannonGame
//
//  Created by Thomas Attermann on 01/05/2016.
//  Copyright (c) 2016 Thomas Attermann. All rights reserved.
//

import SpriteKit

let wallMask:UInt32 = 0x1 << 0 // 1
let ballMask:UInt32 = 0x1 << 1 // 2
let birdMask:UInt32 = 0x1 << 2 // 4

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var cannon: SKSpriteNode!
    var touchLocation:CGPoint = CGPointZero
    var ball: SKSpriteNode!
    var scoreLabel : SKLabelNode!
    
    var score = 0
    
    var background = SKSpriteNode(imageNamed: "background")
    
    override func didMoveToView(view: SKView)
    {
        /* Setup your scene here */
        cannon = self.childNodeWithName("cannon") as! SKSpriteNode
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
                
        self.physicsWorld.contactDelegate = self
        
        addChild(background)
        
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(GameScene.spawnBird), userInfo: nil, repeats: true)

        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
       /* Called when a touch begins */
        touchLocation = touches.first!.locationInNode(self)
       
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        touchLocation = touches.first!.locationInNode(self)
        
    }
    
    // Spawning ball - define physicsbody.
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        let ball: SKSpriteNode = SKScene(fileNamed: "Ball")!.childNodeWithName("ball")! as! SKSpriteNode
        ball.removeFromParent()
        self.addChild(ball)
        ball.zPosition = 1
        ball.position = cannon.position
        let angleInRadions = Float(cannon.zRotation)
        let speed = CGFloat(75.0)
        let vx:CGFloat = CGFloat(cosf(angleInRadions)) * speed
        let vy:CGFloat = CGFloat(sinf(angleInRadions)) * speed
        ball.physicsBody?.applyImpulse(CGVectorMake(vx, vy))
        
        // Define what objects colled - defined in top.
        ball.physicsBody?.collisionBitMask = wallMask | ballMask | birdMask
        
        ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask | birdMask
        
    }
   
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
        let percent = touchLocation.x / size.width
        let newAngle = percent * 180 - 180
        cannon.zRotation = CGFloat(newAngle) * CGFloat(M_PI) / 180
    }
    
    // Method for spawning bird node - called in didMovetoView
    func spawnBird()
    {
        let bird: SKSpriteNode = SKScene(fileNamed: "Bird")!.childNodeWithName("bird")! as! SKSpriteNode
        bird.removeFromParent()
        bird.position = CGPoint(x: Int(arc4random_uniform(640) + 1) , y: Int(arc4random_uniform(800) + 1))
        self.addChild(bird)
    }
    
    func didBeginContact(contact: SKPhysicsContact)
    {
        let ball = (contact.bodyA.categoryBitMask == ballMask) ? contact.bodyA : contact.bodyB
        let other = (ball == contact.bodyA) ? contact.bodyB : contact.bodyA
        
        if other.categoryBitMask == birdMask {
            print("hit bird")
            other.node?.removeFromParent()
            score += 1
            scoreLabel.text = "Score: \(score)"
            ball.node?.removeFromParent()
            didHitBird(other)
            
            // Transition to gameFinished scene, when x points are reached.
            if score == 10 {
                let gameFinished:GameScene = GameScene(fileNamed: "GameFinished")!
                gameFinished.scaleMode = .AspectFill
                let transition = SKTransition.crossFadeWithDuration(1.0)
                self.view?.presentScene(gameFinished, transition: transition)
                
            }

            
        }
        else if other.categoryBitMask == wallMask {
            print("Wall")
        }
        else if other.categoryBitMask == ballMask {
            print("Ball")
            other.node?.removeFromParent()
        }
        
        
    }
    
    // Add spark when bird hit - called in didBeginContact
    func didHitBird(bird : SKPhysicsBody)
    {
        let spark: SKEmitterNode = SKEmitterNode(fileNamed: "Spark")!
        spark.position = (bird.node?.position)!
        spark.zPosition = 3
        self.addChild(spark)
        
        // Apply sound when bird is hit
        self.runAction(SKAction.playSoundFileNamed("impact.wav", waitForCompletion: true))
    }
    
    
}
