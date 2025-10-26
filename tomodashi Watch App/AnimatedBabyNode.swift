//
//  AnimatedBabyNode.swift
//  tomodashi
//
//  Created by Aparna Natarajan on 10/23/25.
//

import SpriteKit
import CoreMotion

class AnimatedBabyNode: SKSpriteNode {
    private var bounceAction: SKAction?
    private var rollAction: SKAction?
    private var motionManager: CMMotionManager?
    private var sceneSize: CGSize = CGSize.zero
    private var groundY: CGFloat = 0
    
    init(size: CGSize) {
        // Start with the baby texture
        let texture = SKTexture(imageNamed: "baby")
        super.init(texture: texture, color: .clear, size: size)
        
        setupMotionManager()
        setupAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMotionManager()
        setupAnimation()
    }
    
    private func setupAnimation() {
        // Animation setup will be triggered manually when needed
        
    }
    
    private func ensureAnimationSetup() {
        // Check if we can set up animations now
        if sceneSize == CGSize.zero && scene != nil {
            
            setupGroundPosition()
        }
    }
    
    private func setupMotionManager() {
        motionManager = CMMotionManager()
        
        
        if motionManager?.isDeviceMotionAvailable == true {
            motionManager?.deviceMotionUpdateInterval = 0.1
            motionManager?.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
                guard let motion = motion, let self = self else { 
                    if let error = error {
                        
                    }
                    return 
                }
                self.handleMotionUpdate(motion)
            }
            
        } else {
            
        }
    }
    
    private func setupGroundPosition() {
        // Update scene size and ground position when parent scene is available
        if let scene = self.scene {
            sceneSize = scene.size
            positionOnGround()
        } else {
            print("AnimatedBabyNode: No scene available for ground positioning")
        }
    }
    
    func updateSceneSize(_ size: CGSize) {
        sceneSize = size
        positionOnGround()
    }
    
    private func positionOnGround() {
        guard sceneSize != CGSize.zero else { return }
        
        // Ground is at y: 0 with height 25, so top of ground is at y: 12.5
        // Position baby on top of the ground
        groundY = self.size.height/2 - 10
        self.position = CGPoint(x: self.position.x, y: groundY)
        print("AnimatedBabyNode: Positioned at \(self.position)")
        
        // Start bouncing after positioning
        setupBounceAnimation()
    }
    
    private func handleMotionUpdate(_ motion: CMDeviceMotion) {
        // Get the gravity vector (which direction is "down")
        let gravity = motion.gravity
        
        // Calculate tilt amount (how much the watch is tilted)
        let tiltX = gravity.x // Left/right tilt
        let tiltY = gravity.y // Forward/back tilt
        
        
        
        // Apply rolling movement based on tilt
        applyTiltBasedMovement(tiltX: tiltX, tiltY: tiltY)
    }
    
    private func applyTiltBasedMovement(tiltX: Double, tiltY: Double) {
        // Convert tilt to movement speed and direction
        let sensitivity: CGFloat = 100.0 // Adjust for responsiveness
        let dampening: CGFloat = 0.8 // Reduce jittery movement
        
        // Calculate target position based on tilt
        let targetX = CGFloat(tiltX) * sensitivity * dampening
        
        // Keep baby within screen bounds
        let maxX = sceneSize.width/2 - self.size.width/2 - 10
        let minX = -sceneSize.width/2 + self.size.width/2 + 10
        let clampedX = max(minX, min(maxX, targetX))
        
        // Smooth movement to target position
        let moveAction = SKAction.moveTo(x: clampedX, duration: 0.2)
        moveAction.timingMode = .easeOut
        self.run(moveAction, withKey: "tiltMovement")
        
        // Add rolling rotation based on movement direction
        let rotationAmount = CGFloat(tiltX) * 0.3 // Subtle rotation
        let rotateAction = SKAction.rotate(toAngle: rotationAmount, duration: 0.2)
        rotateAction.timingMode = .easeOut
        self.run(rotateAction, withKey: "tiltRotation")
    }
    
    private func setupBounceAnimation() {
        // Remove any existing bounce animation first
        removeAction(forKey: "bounceAnimation")
        
        
        
        // Create bouncing motion relative to current ground position
        let bounceHeight: CGFloat = 20
        
        let bounceUp = SKAction.moveTo(y: groundY + bounceHeight, duration: 0.4)
        bounceUp.timingMode = .easeOut
        
        let bounceDown = SKAction.moveTo(y: groundY, duration: 0.4)
        bounceDown.timingMode = .easeIn
        
        let bounceSequence = SKAction.sequence([bounceUp, bounceDown])
        let wait = SKAction.wait(forDuration: 1.5)
        let bounceWithWait = SKAction.sequence([bounceSequence, wait])
        let repeatBounce = SKAction.repeatForever(bounceWithWait)
        
        run(repeatBounce, withKey: "bounceAnimation")
        bounceAction = repeatBounce
        
    }
    
    private func setupRollAnimation() {
        // Create a gentle rolling/swaying motion
        let rollLeft = SKAction.rotate(byAngle: CGFloat.pi / 12, duration: 1.5) // 15 degrees
        rollLeft.timingMode = .easeInEaseOut
        
        let rollRight = SKAction.rotate(byAngle: -CGFloat.pi / 6, duration: 3.0) // -30 degrees (back to center and beyond)
        rollRight.timingMode = .easeInEaseOut
        
        let rollBackToCenter = SKAction.rotate(byAngle: CGFloat.pi / 12, duration: 1.5) // back to start
        rollBackToCenter.timingMode = .easeInEaseOut
        
        let rollSequence = SKAction.sequence([rollLeft, rollRight, rollBackToCenter])
        let repeatRoll = SKAction.repeatForever(rollSequence)
        
        run(repeatRoll, withKey: "rollAnimation")
        rollAction = repeatRoll
    }
    
    private func setupCurvedMovement() {
        // Create a figure-8 or curved path movement
        let centerPosition = self.position
        
        // Create bezier path for smooth curves
        let path = CGMutablePath()
        path.move(to: centerPosition)
        
        // Create a gentle curve that follows the baby's round shape
        let control1 = CGPoint(x: centerPosition.x + 20, y: centerPosition.y + 10)
        let control2 = CGPoint(x: centerPosition.x - 20, y: centerPosition.y + 10)
        let endPoint = CGPoint(x: centerPosition.x, y: centerPosition.y)
        
        path.addCurve(to: endPoint, control1: control1, control2: control2)
        
        let followPath = SKAction.follow(path, duration: 4.0)
        followPath.timingMode = .easeInEaseOut
        
        let repeatPath = SKAction.repeatForever(followPath)
        run(repeatPath, withKey: "curvedMovement")
    }
    
    func startRandomBounce() {
        // Add some randomness to the bouncing
        let randomDelay = SKAction.wait(forDuration: Double.random(in: 0.5...2.0))
        let extraBounce = SKAction.moveBy(x: 0, y: 20, duration: 0.3)
        extraBounce.timingMode = .easeOut
        let fallBack = SKAction.moveBy(x: 0, y: -20, duration: 0.3)
        fallBack.timingMode = .easeIn
        
        let randomBounceSequence = SKAction.sequence([randomDelay, extraBounce, fallBack])
        let repeatRandomBounce = SKAction.repeatForever(randomBounceSequence)
        
        run(repeatRandomBounce, withKey: "randomBounce")
    }
    
    func stopAnimation() {
        removeAction(forKey: "bounceAnimation")
        removeAction(forKey: "tiltMovement")
        removeAction(forKey: "tiltRotation")
        removeAction(forKey: "randomBounce")
        
        // Stop motion manager
        motionManager?.stopDeviceMotionUpdates()
        
        bounceAction = nil
        rollAction = nil
    }
    
    func startAnimation() {
        
        
        // Ensure we set up animations when this is called
        ensureAnimationSetup()
        
        // Ensure we have proper positioning first
        if sceneSize == CGSize.zero {
            if let scene = self.scene {
                updateSceneSize(scene.size)
            }
        }
        
        // Set up bounce animation if not already running
        if bounceAction == nil {
            setupBounceAnimation()
            startRandomBounce()
        }
        
        // Restart motion manager if needed
        if motionManager?.isDeviceMotionActive == false {
            
            motionManager?.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
                guard let motion = motion, let self = self else { return }
                self.handleMotionUpdate(motion)
            }
        }
    }
    
    func addJoyfulWiggle() {
        // Add a playful wiggle motion
        let wiggleLeft = SKAction.moveBy(x: -3, y: 0, duration: 0.1)
        let wiggleRight = SKAction.moveBy(x: 6, y: 0, duration: 0.2)
        let wiggleBack = SKAction.moveBy(x: -3, y: 0, duration: 0.1)
        
        let wiggleSequence = SKAction.sequence([wiggleLeft, wiggleRight, wiggleBack])
        let repeatWiggle = SKAction.repeat(wiggleSequence, count: 3)
        
        run(repeatWiggle)
    }
}