//
//  IdleScene.swift
//  tomodashi
//
//  Created by Aparna Natarajan on 10/23/25.
//

import SpriteKit

class IdleScene: SKScene {
    private var pet: PetNode?
    private var currentPetNode: SKSpriteNode?
    private var groundNode: SKSpriteNode?
    private var deadEyesNode: SKSpriteNode?
    
    override func sceneDidLoad() {
        backgroundColor = .clear
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Create pet once we have proper scene dimensions
        if pet == nil && size.width > 0 && size.height > 0 {
            pet = PetNode(size: CGSize(width: 80, height: 80))
            pet?.updateSceneSize(size)
            
            // Get the current animated node and add it to the scene
            if let node = pet?.getCurrentNode() {
                currentPetNode = node
                node.position = CGPoint(x: size.width / 2, y: 40)
                addChild(node)
                pet?.startCurrentAnimation()
            }
        }
        
        // Update pet appearance and handle node changes
        if let pet = pet {
            let oldNode = currentPetNode
            pet.updateAppearance(currentTime: currentTime)
            
            // Check if we need to switch nodes
            if let newNode = pet.getCurrentNode(), newNode !== oldNode {
                // Remove old node
                oldNode?.removeFromParent()
                
                // Add new node
                currentPetNode = newNode
                newNode.position = CGPoint(x: size.width / 2, y: 40)
                addChild(newNode)
                pet.startCurrentAnimation()
                print("IdleScene: Switched to new animated node")
            }
            
            // Handle death state
            if pet.getIsDead() && deadEyesNode == nil {
                createDeadEyesOverlay()
            } else if !pet.getIsDead() && deadEyesNode != nil {
                removeDeadEyesOverlay()
            }
        }
        
        // Create ground once we have proper scene dimensions
        if groundNode == nil && size.width > 0 && size.height > 0 {
            createGround()
        }
    }
    
    private func createGround() {
        // Create a visible ground at the bottom of the scene
        let groundWidth = size.width
        let groundHeight: CGFloat = 25
        
        groundNode = SKSpriteNode(color: UIColor.purple, size: CGSize(width: groundWidth, height: groundHeight))
        groundNode?.position = CGPoint(x: size.width / 2, y: 0)
        groundNode?.zPosition = -1 // Behind everything else
        
        addChild(groundNode!)
    }
    
    private func createDeadEyesOverlay() {
        guard let currentNode = currentPetNode else { return }
        
        deadEyesNode = SKSpriteNode(imageNamed: "dead-eyes")
        deadEyesNode?.size = currentNode.size
        deadEyesNode?.position = currentNode.position
        deadEyesNode?.zPosition = 2 // On top of everything
        addChild(deadEyesNode!)
        print("IdleScene: Created dead eyes overlay")
    }
    
    private func removeDeadEyesOverlay() {
        deadEyesNode?.removeFromParent()
        deadEyesNode = nil
        print("IdleScene: Removed dead eyes overlay")
    }
    
    func handleTap(at location: CGPoint) {
        // Let the pet handle the tap
        pet?.handleTap()
    }
}
