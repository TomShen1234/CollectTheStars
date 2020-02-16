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
        // Put in image here.
        backgroundColor = UIColor.white
        let background = SKSpriteNode(imageNamed: "Original")
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        background.zPosition = -5
        addChild(background)
        let label = SKLabelNode(fontNamed: "Marker Felt")
        label.text = labeltext
        label.position = CGPoint(x: size.width / 2 + 300, y: size.height / 2 + 200)
        label.fontSize = 250
        addChild(label)
        let decorationNode = SKSpriteNode(imageNamed: imageName)
        decorationNode.position = CGPoint(x: size.width / 2 - 500, y: size.height / 2 - 300)
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let block = SKAction.run {
            let myScene = GameScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.run(block)
    }
}
