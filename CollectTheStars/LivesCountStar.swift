//
//  LivesCountStar.swift
//  CollectTheStars
//
//  Created by Tom Shen on 2020/3/14.
//  Copyright © 2020 Tom & Jerry. All rights reserved.
//

import SpriteKit

// FIXME: Fix node

class LivesCountStar: SKNode {
    let labelNode: SKLabelNode
    
    var liveCount: Int {
        didSet {
            labelNode.text = "\(liveCount)"
        }
    }
    
    init(liveCount: Int) {
        self.labelNode = SKLabelNode()
        self.liveCount = liveCount
        
        super.init()
        
        let starNode = SKSpriteNode(imageNamed: "White Star")
        starNode.position = .zero
        starNode.size = self.frame.size
        addChild(starNode)
        
        labelNode.text = "\(liveCount)"
        labelNode.position = self.frame.center
        labelNode.zPosition = 10
        labelNode.fontName = "Marker Felt"
        labelNode.fontColor = .black
        labelNode.fontSize = 15
        addChild(labelNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
