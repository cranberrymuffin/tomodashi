//
//  AnimatedTeenNode.swift
//  tomodashi
//
//  Created by Aparna Natarajan on 10/24/25.
//

import SpriteKit

class AnimatedTeenNode: SKSpriteNode {
    private let originalSize: CGSize
    private var sceneSize: CGSize = CGSize.zero
    
    init(size: CGSize) {
        self.originalSize = size
        let texture = SKTexture(imageNamed: "teen")
        super.init(texture: texture, color: .clear, size: size)
        
        setupNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNode() {
        print("AnimatedTeenNode: Setting up teen node")
        // Position on ground when scene size is available
    }
    
    func updateSceneSize(_ size: CGSize) {
        self.sceneSize = size
        positionOnGround()
    }
    
    private func positionOnGround() {
        guard sceneSize != CGSize.zero else { return }
        
        // Ground is at y: 0 with height 25, so top of ground is at y: 12.5
        // Position teen on top of the ground
        let groundY = 12.5 + self.size.height/2
        self.position = CGPoint(x: 0, y: groundY)
        print("AnimatedTeenNode: Positioned at \(self.position)")
    }
    
    func startAnimation() {
        print("AnimatedTeenNode: Starting animation (no animation implemented yet)")
        // TODO: Implement teen animations
    }
    
    func stopAnimation() {
        print("AnimatedTeenNode: Stopping animation")
        removeAllActions()
    }
    
    func addJoyfulWiggle() {
        print("AnimatedTeenNode: Adding joyful wiggle")
        // Simple wiggle for now
        let wiggle = SKAction.sequence([
            SKAction.rotate(byAngle: 0.1, duration: 0.1),
            SKAction.rotate(byAngle: -0.2, duration: 0.2),
            SKAction.rotate(byAngle: 0.1, duration: 0.1)
        ])
        run(wiggle)
    }
}