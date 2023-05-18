//
//  GameScene.swift
//  coins-in-box
//
//  Created by baochuquan on 2023/5/17.
//

import SpriteKit
import GameplayKit
import CoreMotion
import AudioToolbox

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private let manager = CMMotionManager()
    private let impact = UIImpactFeedbackGenerator(style: .soft)
    private var debounceTimer: Timer?
    private var debounceEnable = false

    override func didMove(to view: SKView) {

        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self

        for _ in 0 ..< 50 {
            let texture = SKTexture(imageNamed: "icon_qa_coin")
            let node = SKSpriteNode(texture: texture)
            let body = SKPhysicsBody(texture: texture, size: CGSize(width: node.size.width, height: node.size.height))
            body.isDynamic = true
            body.affectedByGravity = true
            body.allowsRotation = true
            body.restitution = 0.6
            body.contactTestBitMask = 1
            body.velocity = CGVector(dx: Double(arc4random() % 500) - 250.0, dy: Double(arc4random() % 500) - 250.0)
            node.physicsBody = body
            node.position = CGPoint(x: 0, y: 0)
            node.zPosition = 0
            addChild(node)
        }
        useGyroPush()
        setupDebounceImpact()
    }

    func useGyroPush() {
        if manager.isAccelerometerAvailable {
            manager.accelerometerUpdateInterval = 0.05
            manager.startAccelerometerUpdates(to: OperationQueue.main) { data, error in
//                print("acceData => \(data)")
                self.physicsWorld.gravity = CGVector(dx: (data?.acceleration.x ?? 0.0) * 9.8, dy: (data?.acceleration.y ?? 0.0) * 9.8)
            }
        }
        if manager.isGyroAvailable {
            manager.gyroUpdateInterval = 0.5
            manager.startGyroUpdates(to: OperationQueue.main) { data, error in
//                print("gyroData => \(data)")
//                self.world.gravity = CGVector(dx: data?.rotationRate.x ?? 0, dy: data?.rotationRate.y ?? 0)
            }
        }
    }

    func setupDebounceImpact() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            guard self.debounceEnable else { return }
            self.debounceEnable = false
            self.impact.impactOccurred()
        }
        debounceTimer?.fire()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard contact.collisionImpulse > 2 else { return }
        if contact.bodyA.contactTestBitMask == 1 && contact.bodyB.contactTestBitMask == 1 {
            self.debounceEnable = true
        }
        print("didBegin => \(contact.collisionImpulse)")
    }

    func didEnd(_ contact: SKPhysicsContact) {
    }
}
