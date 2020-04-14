//
//  GameOverScene.swift
//  CollectTheStars
//
//  Created by Ming Shen on 4/11/15.
//  Copyright (c) 2015 Tom & Jerry. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    var labeltext : String
    var imageName : String
    init(size: CGSize, won:Bool) {
        if won {
            labeltext = "You Win!"
            imageName = "MySpaceship"
        } else {
            labeltext = "You Lost!"
            imageName = "Bomb"
        }
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.black
        
        let starField = SKEmitterNode(fileNamed: "StarField")!
        starField.position = CGPoint(x: frame.midX, y: frame.maxY)
        starField.zPosition = -20
        starField.advanceSimulationTime(TimeInterval(starField.particleLifetime))
        addChild(starField)
        
        let label = SKLabelNode(fontNamed: "Marker Felt")
        label.text = labeltext
        label.position = CGPoint(x: size.width / 2 + 300, y: size.height / 2 + 200)
        label.fontSize = 250
        addChild(label)
        
        let decorationNode = SKSpriteNode(imageNamed: imageName)
        decorationNode.position = CGPoint(x: size.width / 2 - 700, y: size.height / 2)
        let spriteImageName = imageName as NSString
        if spriteImageName.isEqual(to: "MySpaceship") {
            decorationNode.zRotation = π / 2
        } else {
            decorationNode.zRotation = π * 1.5
        }
        decorationNode.setScale(2.0)
        addChild(decorationNode)
        
        let restartLabel = SKLabelNode(fontNamed: "Marker Felt")
        restartLabel.text = "Tap to Restart"
        restartLabel.fontSize = 200
        restartLabel.position = CGPoint(x: size.width / 2 + 300, y: size.height / 2 - 100)
        addChild(restartLabel)
        
        let mainMenuLabel = SKLabelNode(fontNamed: "Marker Felt")
        mainMenuLabel.text = "Main Menu"
        mainMenuLabel.fontSize = 100
        mainMenuLabel.position = CGPoint(x: size.width / 2 + 300, y: size.height / 2 - 300)
        mainMenuLabel.name = "MainMenu"
        addChild(mainMenuLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let nodes = self.nodes(at: location)
        
        if nodes.contains(childNode(withName: "MainMenu")!) {
            let block = SKAction.run {
                let myScene = MainMenu(fileNamed: "MainMenu")!
                myScene.scaleMode = self.scaleMode
                let reveal = SKTransition.crossFade(withDuration: 0.5)
                self.view?.presentScene(myScene, transition: reveal)
            }
            self.run(block)
        } else {
            let block = SKAction.run {
                let myScene = GameScene(size: self.size)
                myScene.scaleMode = self.scaleMode
                let reveal = SKTransition.crossFade(withDuration: 0.5)
                self.view?.presentScene(myScene, transition: reveal)
            }
            self.run(block)
        }
    }
}
