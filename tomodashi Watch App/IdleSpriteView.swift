//
//  ContentView.swift
//  tomodashi Watch App
//

import SwiftUI
import SpriteKit

struct IdleSpriteView: View {
    @State private var idleScene = IdleScene()
    
    var scene: SKScene {
        idleScene.scaleMode = .resizeFill
        idleScene.size = WKInterfaceDevice.current().screenBounds.size
        return idleScene
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea() // fills the entire watch screen
            .background(Color.white)
            .onTapGesture { location in
                // Convert SwiftUI coordinates to SpriteKit coordinates
                let sceneLocation = CGPoint(
                    x: location.x,
                    y: idleScene.size.height - location.y // Flip Y coordinate
                )
                idleScene.handleTap(at: sceneLocation)
            }
    }
}

#Preview {
    ContentView()
}
