//
//  IdleScene.swift
//  tomodashi
//
//  Created by Aparna Natarajan on 10/23/25.
//

import SpriteKit

class IdleScene: SKScene {
    private var pet: PetNode!
    
    override func sceneDidLoad() {
        backgroundColor = .clear
        
        pet = PetNode(size: CGSize(width: 80, height: 80))
        addChild(pet)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Position the pet in the center if it hasn't been positioned yet
        if pet.position == CGPoint.zero && size.width > 0 && size.height > 0 {
            pet.position = CGPoint(x: size.width / 2, y: size.height / 2)
        }
        pet.updateAppearance(currentTime: currentTime)
    }
    
    func handleTap(at location: CGPoint) {
        // Check if touch is on the pet
        if pet.contains(location) {
            pet.handleTap()
        }
    }
}
