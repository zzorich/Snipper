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

@MainActor
struct ImmersiveView: View {
    @Environment(GameModel.self) private var gameModel
    @State private var shootSubscription: EventSubscription?
    var body: some View {
        RealityView { content in
            await loadDrummers(numberOfDrummers: 5)
            await gameModel.loadGun()
            gameModel.attachGunToHead()
            gameModel.generateRandomLocationsForDrummers()

            for drummer in drummers {
                space.addChild(drummer)
            }
            content.add(space)
            content.add(cameraAnchor)
            shootSubscription = content.subscribe(to: AnimationEvents.PlaybackCompleted.self) { event in
                gameModel.handleShootAnimationCompletion(event: event)
            }

        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}
