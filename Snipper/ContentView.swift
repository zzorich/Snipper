//
//  ContentView.swift
//  Snipper
//
//  Created by lingji zhou on 3/19/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(GameModelManager.self) private var gameManager


    var body: some View {
        VStack {
            if (!showImmersiveSpace) {
                Button {
                    Task { @MainActor () -> Void in
                        print("Button trigered")
                        await openImmersiveSpace(id: "Main")
                        showImmersiveSpace = true

                    }
                } label: {
                    Text("StartGame")
                }
                .glassBackgroundEffect()
            } else {
                Button("Shoot") {
                    gameManager.shoot()
                }
            }
        }
        .frame(height: 100)
    }
}

#Preview(windowStyle: .plain) {
    ContentView()
}
