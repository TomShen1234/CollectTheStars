//
//  GameViewController.swift
//  CollectTheStars
//
//  Created by Ming Shen on 4/11/15.
//  Copyright (c) 2015 Tom & Jerry. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            view.accessibilityIgnoresInvertColors = true
        }

        let sceneName: String
        if UI_USER_INTERFACE_IDIOM() == .pad {
            sceneName = "MainMenu-iPad"
        } else {
            sceneName = "MainMenu"
        }
        
        let scene = MainMenu(fileNamed: sceneName)!
        // Configure the view.
        let skView = self.view as! SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = SKSceneScaleMode.aspectFill
        
        skView.presentScene(scene)
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .all
    }
}
