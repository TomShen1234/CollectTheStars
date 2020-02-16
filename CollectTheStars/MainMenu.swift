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
        let background = SKSpriteNode(imageNamed: "Original")
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        addChild(background)
        let label = SKLabelNode(fontNamed: "Marker Felt")
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        label.fontSize = 250
        label.name = "StartLabel";
        label.text = "Tap to Start"
        label.fontColor = SKColor.white
        label.zPosition = 100
        addChild(label)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let action = SKAction.fadeOut(withDuration: 1)
        let label = childNode(withName: "StartLabel")
        label?.run(action) {
            // Action Completion Block
            let instructionScene = Instruction(size: self.size)
            self.view?.presentScene(instructionScene)
        }
    }
}
