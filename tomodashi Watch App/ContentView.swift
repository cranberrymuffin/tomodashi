//
//  ContentView.swift
//  tomodashi Watch App
//
//  Created by Aparna Natarajan on 10/23/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 10) {
            IdleSpriteView()
            Text("Your pet is evolving!")
                .font(.caption)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
