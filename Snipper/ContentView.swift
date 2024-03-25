//
//  ContentView.swift
//  Snipper
//
//  Created by lingji zhou on 3/19/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

@MainActor
struct ContentView: View {

    @Environment(GameModel.self) private var gameModel
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace


    var body: some View {
        VStack {
            if (!showImmersiveSpace) {
                Button {
                    Task { @MainActor () -> Void in
                        await openImmersiveSpace(id: "Main")
                        showImmersiveSpace = true

                    }
                } label: {
                    Text("StartGame")
                }
                .glassBackgroundEffect()
            } else {
                Button("Shoot") {
                    gameModel.shoot()
                }
            }
        }
        .frame(height: 100)
    }
}

#Preview(windowStyle: .plain) {
    ContentView()
}
