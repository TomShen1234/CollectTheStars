//
//  Instruction.swift
//  CollectTheStars
//
//  Created by Ming Shen on 4/11/15.
//  Copyright (c) 2015 Tom & Jerry. All rights reserved.
//

import Foundation
import SpriteKit

class Instruction: SKScene {
    
    let label = SKLabelNode(fontNamed: "MarkerFelt-Wide")
    var updateTime = 0
    var value = 1
    let background = SKSpriteNode(imageNamed: "Original")
    let instruction = SKSpriteNode(imageNamed: "Instruction")
    
    override func didMove(to view: SKView) {
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        background.zPosition = -1
        addChild(background)
        instruction.position = CGPoint(x: size.width / 2, y: size.height / 2)
        instruction.zPosition = 0
        instruction.setScale(0)
        addChild(instruction)
        let wait = SKAction.wait(forDuration: 2.0)
        let block = SKAction.run(presentNextScreen)
        let scaleUp = SKAction.scale(to: 1, duration: 0.5)
        instruction.run(scaleUp)
        run(SKAction.sequence([wait, block]))
        
    }
    
    func presentNextScreen() {
        let transition = SKTransition.doorway(withDuration: 1.0)
        let scene = GameScene(size: self.size)
        self.view?.presentScene(scene, transition: transition)
    }
}
