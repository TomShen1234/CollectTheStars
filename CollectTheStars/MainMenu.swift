//
//  MainMenu.swift
//  CollectTheStars
//
//  Created by Ming Shen on 4/11/15.
//  Copyright (c) 2015 Tom & Jerry. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {

    override func didMove(to view: SKView) {
        let starField = SKEmitterNode(fileNamed: "StarField")!
        starField.position = CGPoint(x: frame.midX, y: frame.maxY)
        starField.zPosition = -20
        starField.advanceSimulationTime(TimeInterval(starField.particleLifetime))
        addChild(starField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.nodes(at: location)
        let startLabel = childNode(withName: "StartLabel")!
        let instructionLabel = childNode(withName: "Instruction")!
        if node.contains(startLabel) {
            let action = SKAction.fadeOut(withDuration: 1)
            startLabel.run(action) {
                // Action Completion Block
                //let instructionScene = Instruction(size: self.size)
                
                // Aspect resize
                let newHeight = (self.view!.bounds.size.height * self.size.width) / self.view!.bounds.size.width
                
                let gameScene = GameScene(size: CGSize(width: self.size.width, height: newHeight))
                gameScene.scaleMode = .aspectFill
                self.view?.presentScene(gameScene, transition: SKTransition.crossFade(withDuration: 0.5))
            }
            instructionLabel.run(action)
        } else if node.contains(instructionLabel) {
            let instructionScene: Instruction
            if UI_USER_INTERFACE_IDIOM() == .pad {
                instructionScene = Instruction(fileNamed: "Instruction-iPad")!
            } else {
                instructionScene = Instruction(fileNamed: "Instruction")!
            }
            instructionScene.scaleMode = .aspectFill
            self.view?.presentScene(instructionScene, transition: SKTransition.crossFade(withDuration: 0.5))
        }
    }
}
