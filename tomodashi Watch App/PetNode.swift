//
//  PetNode.swift
//  tomodashi
//
//  Created by Aparna Natarajan on 10/23/25.
//

import SpriteKit

class PetNode {
    private var petBirthday: Date = UserDefaults.standard.object(forKey: "petBirthday") as? Date ?? Date()
    private var lastSpriteName: String = ""
    private var isDead: Bool = false
    private var deadEyesNode: SKSpriteNode?
    
    // Animated nodes for different life stages
    private var animatedBabyNode: AnimatedBabyNode?
    private var animatedChildNode: AnimatedChildNode?
    private var animatedTeenNode: AnimatedTeenNode?
    private var animatedAdultNode: AnimatedAdultNode?
    private var animatedSeniorNode: AnimatedSeniorNode?
    
    private var currentNode: SKSpriteNode?
    private let nodeSize: CGSize
    
    init(size: CGSize) {
        self.nodeSize = size
        
        // Set birthday if it doesn't exist
        let birthday: Date
        if UserDefaults.standard.object(forKey: "petBirthday") == nil {
            birthday = Date()
            UserDefaults.standard.set(birthday, forKey: "petBirthday")
        } else {
            birthday = UserDefaults.standard.object(forKey: "petBirthday") as? Date ?? Date()
        }
        
        self.petBirthday = birthday
        
        // Calculate initial sprite name based on current age
        let now = Date()
        let secondsAlive = now.timeIntervalSince(birthday)
        let minutesAlive = secondsAlive / 60.0 // 1 minute = 1 day for testing
        
        let initialSpriteName = spriteNameForAge(minutesAlive)
        self.lastSpriteName = initialSpriteName
        
        // Create the initial animated node
        self.currentNode = createAnimatedNode(for: initialSpriteName)
    }
    
    func updateAppearance(currentTime: TimeInterval) {
        let currentAge = getCurrentAge()
        
        // Check if pet should die
        if !isDead && shouldDie(age: currentAge) {
            makeDead()
            return
        }
        
        // Skip appearance updates if dead
        if isDead {
            return
        }
        
        let newSpriteName = spriteNameForAge(currentAge)
        
        if newSpriteName != lastSpriteName {
            changeSprite(to: newSpriteName)
            lastSpriteName = newSpriteName
        }
    }
    
    private func getCurrentAge() -> Double {
        let now = Date()
        let secondsAlive = now.timeIntervalSince(petBirthday)
        return secondsAlive / 60.0 // 1 minute = 1 day for testing
    }
    
    private func changeSprite(to name: String) {
        print("PetNode: Changing sprite to \(name)")
        
        // Stop current node animation
        stopCurrentNodeAnimation()
        
        // Create new animated node
        currentNode = createAnimatedNode(for: name)
    }
    
    private func createAnimatedNode(for spriteName: String) -> SKSpriteNode? {
        switch spriteName {
        case "baby":
            if animatedBabyNode == nil {
                animatedBabyNode = AnimatedBabyNode(size: nodeSize)
            }
            return animatedBabyNode
        case "child":
            if animatedChildNode == nil {
                animatedChildNode = AnimatedChildNode(size: nodeSize)
            }
            return animatedChildNode
        case "teen":
            if animatedTeenNode == nil {
                animatedTeenNode = AnimatedTeenNode(size: nodeSize)
            }
            return animatedTeenNode
        case "adult":
            if animatedAdultNode == nil {
                animatedAdultNode = AnimatedAdultNode(size: nodeSize)
            }
            return animatedAdultNode
        case "senior":
            if animatedSeniorNode == nil {
                animatedSeniorNode = AnimatedSeniorNode(size: nodeSize)
            }
            return animatedSeniorNode
        default:
            return nil
        }
    }
    
    private func stopCurrentNodeAnimation() {
        animatedBabyNode?.stopAnimation()
        animatedChildNode?.stopAnimation()
        animatedTeenNode?.stopAnimation()
        animatedAdultNode?.stopAnimation()
        animatedSeniorNode?.stopAnimation()
    }
    
    private func shouldDie(age: Double) -> Bool {
        // Pet can die at any age, but probability increases with age
        // After senior age (5+ minutes), death becomes inevitable
        return age >= 6.0 
    }
    
    private func makeDead() {
        isDead = true
        print("PetNode: Pet is now dead")
        
        // Stop any animations
        stopCurrentNodeAnimation()
        
        // Note: Dead eyes overlay will be handled by the scene that manages this PetNode
    }
    
    private func rebirth() {
        // Reset death state
        isDead = false
        print("PetNode: Pet is reborn!")
        
        // Stop all animations
        stopCurrentNodeAnimation()
        
        // Set new birthday (rebirth)
        let newBirthday = Date()
        UserDefaults.standard.set(newBirthday, forKey: "petBirthday")
        petBirthday = newBirthday
        
        // Reset to baby sprite with animation
        let babySprite = "baby"
        changeSprite(to: babySprite)
        lastSpriteName = babySprite
        
        // Add a special rebirth wiggle after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let baby = self.animatedBabyNode {
                baby.addJoyfulWiggle()
            }
        }
    }
    
    func handleTap() {
        // If pet is dead, allow rebirth on tap
        if isDead {
            rebirth()
        } else {
            // Add joyful wiggle to current node
            if let baby = currentNode as? AnimatedBabyNode {
                baby.addJoyfulWiggle()
            } else if let child = currentNode as? AnimatedChildNode {
                child.addJoyfulWiggle()
            } else if let teen = currentNode as? AnimatedTeenNode {
                teen.addJoyfulWiggle()
            } else if let adult = currentNode as? AnimatedAdultNode {
                adult.addJoyfulWiggle()
            } else if let senior = currentNode as? AnimatedSeniorNode {
                senior.addJoyfulWiggle()
            }
        }
    }
    
    private func spriteNameForAge(_ age: Double) -> String {
        // Full evolution system enabled
        if age < 2 {
            return "baby"
        } else if age < 5 {
            return "child"
        } else if age < 10 {
            return "teen"
        } else if age < 15 {
            return "adult"
        } else {
            return "senior"
        }
    }
    
    // Public methods to get the current animated node and other info
    func getCurrentNode() -> SKSpriteNode? {
        return currentNode
    }
    
    func updateSceneSize(_ size: CGSize) {
        // Update scene size for all animated nodes
        animatedBabyNode?.updateSceneSize(size)
        animatedChildNode?.updateSceneSize(size)
        animatedTeenNode?.updateSceneSize(size)
        animatedAdultNode?.updateSceneSize(size)
        animatedSeniorNode?.updateSceneSize(size)
    }
    
    func startCurrentAnimation() {
        if let baby = currentNode as? AnimatedBabyNode {
            baby.startAnimation()
        } else if let child = currentNode as? AnimatedChildNode {
            child.startAnimation()
        } else if let teen = currentNode as? AnimatedTeenNode {
            teen.startAnimation()
        } else if let adult = currentNode as? AnimatedAdultNode {
            adult.startAnimation()
        } else if let senior = currentNode as? AnimatedSeniorNode {
            senior.startAnimation()
        }
    }
    
    func getIsDead() -> Bool {
        return isDead
    }
}
