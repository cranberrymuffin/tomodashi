//
//  PetNode.swift
//  tomodashi
//
//  Created by Aparna Natarajan on 10/23/25.
//

import SpriteKit

class PetNode: SKSpriteNode {
    private var petBirthday: Date = UserDefaults.standard.object(forKey: "petBirthday") as? Date ?? Date()
    private var lastSpriteName: String = ""
    private var isDead: Bool = false
    private var deadEyesNode: SKSpriteNode?
    
    init(size: CGSize) {
        // Set birthday if it doesn't exist
        let birthday: Date
        if UserDefaults.standard.object(forKey: "petBirthday") == nil {
            birthday = Date()
            UserDefaults.standard.set(birthday, forKey: "petBirthday")
        } else {
            birthday = UserDefaults.standard.object(forKey: "petBirthday") as? Date ?? Date()
        }
        
        // Calculate initial sprite name based on current age
        let now = Date()
        let secondsAlive = now.timeIntervalSince(birthday)
        let minutesAlive = secondsAlive / 60.0 // 1 minute = 1 day for testing
        let initialSpriteName = PetNode.spriteNameForAge(minutesAlive: minutesAlive)
        
        let texture = SKTexture(imageNamed: initialSpriteName)
        super.init(texture: texture, color: .clear, size: size)
        
        self.petBirthday = birthday
        self.lastSpriteName = initialSpriteName
        
        // Enable touch interaction
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateAppearance(currentTime: TimeInterval) {
        let currentAge = getCurrentAge()
        
        // Check if pet should die (can happen at any age, but more likely with age)
        if !isDead && shouldDie(age: currentAge) {
            makeDead()
            return
        }
        
        // Only update sprite if not dead
        if !isDead {
            let newSpriteName = PetNode.spriteNameForAge(minutesAlive: currentAge)
            if newSpriteName != lastSpriteName {
                changeSprite(to: newSpriteName)
                lastSpriteName = newSpriteName
            }
        }
    }
    
    private func getCurrentAge() -> Double {
        let now = Date()
        let secondsAlive = now.timeIntervalSince(petBirthday)
        return secondsAlive / 60.0 // 1 minute = 1 day for testing
    }
    
    private func changeSprite(to name: String) {
        self.texture = SKTexture(imageNamed: name)
    }
    
    private func shouldDie(age: Double) -> Bool {
        // Pet can die at any age, but probability increases with age
        // After senior age (5+ minutes), death becomes inevitable
        return age >= 6.0 
    }
    
    private func makeDead() {
        isDead = true
        
        // Create dead eyes overlay
        if deadEyesNode == nil {
            deadEyesNode = SKSpriteNode(imageNamed: "dead-eyes")
            deadEyesNode?.size = self.size // Same size as pet
            deadEyesNode?.position = CGPoint.zero // Same position as pet (centered)
            deadEyesNode?.zPosition = 1 // Make sure eyes appear on top
            addChild(deadEyesNode!)
        }
    }
    
    private func rebirth() {
        // Reset death state
        isDead = false
        
        // Remove dead eyes overlay
        deadEyesNode?.removeFromParent()
        deadEyesNode = nil
        
        // Set new birthday (rebirth)
        let newBirthday = Date()
        UserDefaults.standard.set(newBirthday, forKey: "petBirthday")
        petBirthday = newBirthday
        
        // Reset to baby sprite
        let babySprite = "baby"
        changeSprite(to: babySprite)
        lastSpriteName = babySprite
    }
    
    func handleTap() {
        // If pet is dead, allow rebirth on tap
        if isDead {
            rebirth()
        }
    }
    
    private static func spriteNameForAge(minutesAlive: Double) -> String {
        let babyDuration = 1.0
        let childDuration = 1.0
        let teenDuration = 1.0
        let adultDuration = 1.0
        let seniorDuration = 1.0
        
        switch minutesAlive {
        case 0..<babyDuration:
            return "baby"
        case babyDuration..<(babyDuration + childDuration):
            return "child"
        case (babyDuration + childDuration)..<(babyDuration + childDuration + teenDuration):
            return "teen"
        case (babyDuration + childDuration + teenDuration)..<(babyDuration + childDuration + teenDuration + adultDuration):
            return "adult"
        case (babyDuration + childDuration + teenDuration + adultDuration)..<(babyDuration + childDuration + teenDuration + adultDuration + seniorDuration):
            return "senior"
        default:
            return "senior" // Stay senior until death
        }
    }
}
