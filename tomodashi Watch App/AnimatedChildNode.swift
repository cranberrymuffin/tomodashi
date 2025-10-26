//
//  AnimatedChildNode.swift
//  tomodashi
//
//  Created by Aparna Natarajan on 10/23/25.
//

import SpriteKit

class AnimatedChildNode: SKSpriteNode {
    private var animationAction: SKAction?
    private var sceneSize: CGSize = CGSize.zero

    init(size: CGSize) {
        // Start with the first child frame
        let texture = SKTexture(imageNamed: "child")
        super.init(texture: texture, color: .clear, size: size)
                    setupAnimation()

        // Don't start animation in init - wait until added to scene
    }

    func updateSceneSize(_ size: CGSize) {
        self.sceneSize = size
        positionOnGround()
    }

    private func positionOnGround() {
        guard sceneSize != CGSize.zero else { return }
        
        // Ground is at y: 0 with height 25, so top of ground is at y: 12.5
        // Position child on top of the ground
        let groundY = 12.5 + self.size.height/2
        self.position = CGPoint(x: 0, y: groundY)
        print("AnimatedChildNode: Positioned at \(self.position)")
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
                    setupAnimation()

        // Don't start animation in init - wait until added to scene
    }
    
    private func ensureAnimationSetup() {
        // Check if we can set up animations now
        if animationAction == nil && parent != nil {
            
            setupAnimation()
        }
    }
    
    private func setupAnimation() {
        // Create animation frames
        let frame1 = SKTexture(imageNamed: "child")
        let frame2 = SKTexture(imageNamed: "child-2")
        
        let frames = [frame1, frame2]
        
        // Create the animation action
        let animateAction = SKAction.animate(with: frames, timePerFrame: 1.0)
        let repeatAction = SKAction.repeatForever(animateAction)
        
        // Run the animation
        run(repeatAction, withKey: "childAnimation")
        animationAction = repeatAction
    }
    
    func stopAnimation() {
        removeAction(forKey: "childAnimation")
        animationAction = nil
    }
    
    func startAnimation() {
        
        
        // Ensure we set up animations when this is called
        ensureAnimationSetup()
        
        // If animation still doesn't exist, set it up directly
        if animationAction == nil {
            setupAnimation()
        }
    }
}