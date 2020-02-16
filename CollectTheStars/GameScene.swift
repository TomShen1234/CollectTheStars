//
//  GameScene.swift
//  CollectTheStars
//
//  Created by Ming Shen on 4/11/15.
//  Copyright (c) 2015 Tom & Jerry. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var lastUpdateTime : TimeInterval = 0
    var dt : TimeInterval = 0
    var velocity = CGPoint.zero
    let spaceShipMovePointsPerSec : CGFloat = 480.0
    let spaceship = SKSpriteNode(imageNamed: "MySpaceship")
    let playableRect : CGRect
    let spaceshipRotatedRadiansPerSec : CGFloat = 4.0 * π
    let particleLayerNode = SKNode()
    let explotionEmitter = SKEmitterNode(fileNamed: "Explosion")!
    var invincible : Bool = false
    var lives = 5
    let starMovePointsPerSec : CGFloat = 480.0
    var gameOver : Bool = false
    
    override init(size: CGSize) {
        let maxAspectRadio : CGFloat = 16.0/9.0 // 1
        let playableHeight = size.width / maxAspectRadio
        let playableMargin = (size.height - playableHeight) / 2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }

    override func didMove(to view: SKView) {
        /* Setup your scene here */
        backgroundColor = UIColor.black
        let starfieldNode = SKNode()
        starfieldNode.name = "starfieldNode"
        starfieldNode.addChild(starfieldEmitterNode(speed: -48, lifetime: size.height / 23, scale: 0.2, birthRate: 1, color: SKColor.lightGray))
        starfieldNode.zPosition = -5
        addChild(starfieldNode)
        var emitterNode = starfieldEmitterNode(speed: -32, lifetime: size.height / 10, scale: 0.14, birthRate: 2, color: SKColor.gray)
        emitterNode.zPosition = -10
        starfieldNode.addChild(emitterNode)
        emitterNode = starfieldEmitterNode(
            speed: -20, lifetime: size.height / 5, scale: 0.1, birthRate: 5, color: SKColor.darkGray)
        emitterNode.zPosition = -15
        addChild(emitterNode)
        spaceship.position = CGPoint(x: 400, y: 400)
        createSpaceshipEngine()
        spaceship.zPosition = -1
        addChild(spaceship)
        // moveSpaceShipToward(CGPoint(x: 500, y: 400))
        debugDrawPlayableArea()
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnBomb), SKAction.wait(forDuration: 1.5)])))
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnStar),SKAction.wait(forDuration: 1.0)])))
        particleLayerNode.zPosition = 10
        addChild(particleLayerNode)
    }
    
    func createSpaceshipEngine() {
        let engineEmitter = SKEmitterNode(fileNamed: "SpaceshipParticle")
        engineEmitter?.position = CGPoint(x: -80, y: 0)
        engineEmitter?.name = "engineEmitter"
        engineEmitter?.zPosition = spaceship.zPosition - 1
        spaceship.addChild(engineEmitter!)
    }
    
    func rotateSprite(_ sprite: SKSpriteNode, direction: CGPoint, rotateRadiansPerSec: CGFloat) {
        let shortest = shortestAngleBetween(sprite.zRotation, angle2: velocity.angle)
        let amountToRotate = min(rotateRadiansPerSec * CGFloat(dt), abs(shortest))
        sprite.zRotation += shortest.sign() * amountToRotate
    }

    
    func starfieldEmitterNode(speed: CGFloat, lifetime: CGFloat, scale: CGFloat, birthRate: CGFloat, color: SKColor) -> SKEmitterNode {
        // more to come
        let star = SKLabelNode(fontNamed: "Helvetica")
        star.fontSize = 140.0
        star.text = "✦"
        let textureView = SKView()
        let texture = textureView.texture(from: star)
        texture?.filteringMode = .nearest
        let emitterNode = SKEmitterNode()
        emitterNode.particleTexture = texture
        emitterNode.particleBirthRate = birthRate
        emitterNode.particleColor = color
        emitterNode.particleLifetime = lifetime
        emitterNode.particleSpeed = speed
        emitterNode.particleScale = scale
        emitterNode.particleColorBlendFactor = 1
        emitterNode.position = CGPoint(x: frame.midX, y: frame.maxY)
        emitterNode.particlePositionRange = CGVector(dx: frame.maxX, dy: 0)
        emitterNode.particleAction = SKAction.repeatForever(SKAction.sequence([SKAction.rotate(byAngle: -(CGFloat.pi / 4), duration: 1), SKAction.rotate(byAngle: CGFloat.pi / 4, duration: 1)]))
        emitterNode.particleSpeedRange = 16.0
        //1
        let twinkles = 20
        let colorSequence = SKKeyframeSequence(capacity: twinkles*2)
        //2
        let twinkleTime = 1.0/CGFloat(twinkles)
        for i in 0..<twinkles {
            //3
            colorSequence.addKeyframeValue(
            SKColor.white,time: CGFloat(i)*2 * twinkleTime/2)
            colorSequence.addKeyframeValue(
            SKColor.yellow, time: (CGFloat(i)*2+1)*twinkleTime/2)
        }
        //4
        emitterNode.particleColorSequence = colorSequence
        emitterNode.advanceSimulationTime(TimeInterval(lifetime))
        emitterNode.emissionAngle = CGFloat.pi / 4
        return emitterNode
    }
    
    func spawnStar() {
        let star = SKSpriteNode(imageNamed: "MyStar")
        let point = CGPoint(
            x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX),
            y: CGFloat.random(min: playableRect.minY, max: playableRect.maxY))
        star.position = point
        star.setScale(0)
        star.name = "star"
        addChild(star)
        
        let appear = SKAction.scale(to: CGFloat.random(min: 0.9, max: 1.1), duration: 0.5)
        star.zRotation = -π / 16.0
        let leftWiggle = SKAction.rotate(byAngle: π/8.0, duration: 0.5)
        let rightWiggle = leftWiggle.reversed()
        let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])
        let scaleUp = SKAction.scale(by: 1.2, duration: 0.25)
        let scaleDown = scaleUp.reversed()
        let fullScale = SKAction.sequence([scaleUp, scaleDown, scaleUp, scaleDown])
        let group = SKAction.group([fullScale, fullWiggle])
        let groupWait = SKAction.repeat(group, count: 10)
        let disappear = SKAction.scale(to: 0, duration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear, groupWait, disappear, removeFromParent]
        star.run(SKAction.sequence(actions))
    }

    override func didEvaluateActions() {
        checkCollison()
    }
    
    func spawnBomb() {
        let bomb = SKSpriteNode(imageNamed: "Bomb")
        bomb.name = "bomb"
        let point = CGPoint(x: size.width + bomb.size.width / 2, y: CGFloat.random(
            min: playableRect.minY + bomb.size.height/2,
            max: playableRect.maxY - bomb.size.height/2))
        bomb.position = point
        bomb.zPosition = 0
        addChild(bomb)
        /*
        // Actions
        let actionMidMove = SKAction.moveByX(-size.width/2-enemy.size.width/2, y: -CGRectGetHeight(playableRect)/2 + enemy.size.height/2, duration: 1.0)
        let actionMove = SKAction.moveByX( -size.width/2-enemy.size.width/2, y: CGRectGetHeight(playableRect)/2 - enemy.size.height/2, duration: 1.0)
        let wait = SKAction.waitForDuration(0.25)
        let logMessage = SKAction.runBlock() {
        println("Reached bottom!")
        }
        let halfSequence = SKAction.sequence([actionMidMove, logMessage, wait, actionMove])
        let sequence = SKAction.sequence([halfSequence, halfSequence.reversedAction()])
        let repeat = SKAction.repeatActionForever(sequence)
        enemy.runAction(repeat)
        */
        let actionMove = SKAction.moveBy(x: -size.width - bomb.size.width, y: 0, duration: 2.0)
        let actionRemove = SKAction.removeFromParent()
        bomb.run(SKAction.sequence([actionMove, actionRemove]))
    }

    func checkCollison() {
        var hitStars : [SKSpriteNode] = []
        enumerateChildNodes(withName: "star") { node, _ in
            let star = node as! SKSpriteNode
            if star.frame.intersects(self.spaceship.frame) {
                hitStars.append(star)
            }
        }
        for star in hitStars {
            spaceshipHitStar(star)
        }
        var hitBombs : [SKSpriteNode] = []
        enumerateChildNodes(withName: "bomb") { node, _ in
            let bomb = node as! SKSpriteNode
            if node.frame.insetBy(dx: 25, dy: 25).intersects(self.spaceship.frame) {
                hitBombs.append(bomb)
            }
        }
        for bomb in hitBombs {
            spaceshipHitBomb(bomb)
        }
    }

    func spaceshipHitStar(_ star : SKSpriteNode)
    {
        star.name = "train"
        star.removeAllActions()
        run(SKAction.playSoundFileNamed("Bell(Star).mp3", waitForCompletion: false))
        
        let fadeToRed = SKAction.colorize(with: SKColor.red, colorBlendFactor: 1.0, duration: 0.2)
        star.run(fadeToRed)
    }
    
    func spaceshipHitBomb(_ bomb : SKSpriteNode)
    {
        if invincible {
            return
        }
        invincible = true
        lives -= 1
        explotionEmitter.position = spaceship.position
        if explotionEmitter.parent == nil {
            particleLayerNode.addChild(explotionEmitter)
        }
        run(SKAction.playSoundFileNamed("Explosion.mp3", waitForCompletion: false))
        explotionEmitter.resetSimulation()
        bomb.removeFromParent()
        loseStar()
        // lives = 0
        if lives == 0 {
            spaceship.removeFromParent()
            let wait = SKAction.wait(forDuration: 1.0)
            let block = SKAction.run(presentLosingGameOverScene)
            let sound = SKAction.playSoundFileNamed("Losing.mp3", waitForCompletion: false)
            let group = SKAction.group([block, sound])
            run(SKAction.sequence([wait, group]))
        }
        let blinkTimes = 10.0
        let duration = 3.0
        let blinkAction = SKAction.customAction(withDuration: duration) {
            node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(dividingBy: slice)
            node.isHidden = remainder > slice / 2
        }
        let setHidden = SKAction.run() {
                self.spaceship.isHidden = false
                self.invincible = false
        }
        spaceship.run(SKAction.sequence([blinkAction, setHidden]))
    }
    
    func presentLosingGameOverScene() {
        let scene = GameOverScene(size: self.size, won: false)
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        self.view?.presentScene(scene, transition:transition)
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        moveSprite(spaceship, velocity: velocity)
        boundsCheckSpaceship()
        rotateSprite(spaceship, direction: velocity, rotateRadiansPerSec: spaceshipRotatedRadiansPerSec)
        moveTrain()
    }
    
    func moveSpaceShipToward(_ location:CGPoint) {
        let offset = location - spaceship.position
        let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        let direction = offset / CGFloat(length)
        velocity = direction * spaceShipMovePointsPerSec
    }
    
    func loseStar() {
        // 1
        var loseCount = 0
        enumerateChildNodes(withName: "train") { node, stop in
            // 2
            var randomSpot = node.position
            randomSpot.x = CGFloat.random(min: -100, max: 100)
            randomSpot.y = CGFloat.random(min: -100, max: 100)
            // 3
            node.name = ""
            node.run(SKAction.sequence([SKAction.group([SKAction.rotate(byAngle: π*4, duration: 1.0), SKAction.move(to: randomSpot, duration: 1.0), SKAction.scale(to: 0, duration: 1.0)]), SKAction.removeFromParent()]))
            // 4
            loseCount += 1
            if loseCount >= 2 {
                stop.pointee = true
            }
        }

    }
    
    func moveSprite(_ sprite:SKSpriteNode, velocity:CGPoint) {
        // 1
        let amountToMove = velocity * CGFloat(dt)
        // 2
        sprite.position += amountToMove
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        moveSpaceShipToward(touchLocation!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        moveSpaceShipToward(touchLocation!)
    }
    
    func boundsCheckSpaceship() {
        let bottomLeft = CGPoint(x: 0, y: playableRect.minY)
        let topRight = CGPoint(x: size.width, y: playableRect.maxY)
        if spaceship.position.x <= bottomLeft.x {
            spaceship.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        if spaceship.position.x >= topRight.x {
            spaceship.position.x = topRight.x
            velocity.x = -velocity.x
        }
        if spaceship.position.y <= bottomLeft.y {
            spaceship.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        if spaceship.position.y >= topRight.y {
            spaceship.position.y = topRight.y
            velocity.y = -velocity.y
        }
    }
    
    func moveTrain() {
        var targetPosition = spaceship.position
        var trainCount = 0
        
        enumerateChildNodes(withName: "train") { node, stop in
            trainCount += 1
            
            if !node.hasActions() {
                let actionDuration = 0.3
                let offset = targetPosition - node.position
                let direction = offset.normalized()
                let amountToMovePerSec = direction * self.starMovePointsPerSec
                let amountToMove = amountToMovePerSec * CGFloat(actionDuration)
                let moveAction = SKAction.moveBy(x: amountToMove.x, y: amountToMove.y, duration: actionDuration)
                node.run(moveAction)
            }
            targetPosition = node.position
            
        }
        // trainCount = 30
        if trainCount >= 30 && !gameOver {
            gameOver = true
            self.run(SKAction.playSoundFileNamed("WinningApplause.mp3", waitForCompletion: false))
            // backgroundMusicPlayer.stop()
            // 1
            let gameOverScene = GameOverScene(size: size, won: true)
            gameOverScene.scaleMode = scaleMode
            // 2
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            // 3
            view?.presentScene(gameOverScene, transition: reveal)
        }

    }

}
