//
//  ImmersiveView.swift
//  Snipper
//
//  Created by lingji zhou on 3/19/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Combine

struct ImmersiveView: View {

    @Environment(GameModelManager.self) private var gameManager

    var body: some View {
        RealityView { content in
            do {
                try await gameManager.loadResources()
            } catch {
                fatalError("Fail to load Resources")
            }
            content.add(gameManager.entities.scene)
            gameManager.setupGeometries()
            gameManager.playRecurrentPlanesAnimations()
        }
        .onTapGesture {
            
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}
