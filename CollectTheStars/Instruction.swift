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
    
    override func didMove(to view: SKView) {
        let starField = SKEmitterNode(fileNamed: "StarField")!
        starField.position = CGPoint(x: frame.midX, y: frame.maxY)
        starField.zPosition = -20
        starField.advanceSimulationTime(TimeInterval(starField.particleLifetime))
        addChild(starField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let mainMenu = MainMenu(fileNamed: "MainMenu")!
        mainMenu.scaleMode = .aspectFill
        view?.presentScene(mainMenu, transition: SKTransition.crossFade(withDuration: 0.5))
    }
}
