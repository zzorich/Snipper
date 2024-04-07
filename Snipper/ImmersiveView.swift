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
    @State private var shootCompletedSubscription: EventSubscription?

    @State private var collisionSubscription: EventSubscription?
    var body: some View {
        RealityView { content in
            do {
                try await gameManager.loadResources()
            } catch {
                fatalError("Fail to load Resources")
            }
            content.add(gameManager.entities.scene)
            gameManager.setupGeometries()
//            gameManager.playRecurrentPlanesAnimations()

            shootCompletedSubscription = content.subscribe(to: AnimationEvents.PlaybackCompleted.self, on: gameManager.entities.gun, gameManager.onShootAnimationCompleted(event:))

            collisionSubscription = content.subscribe(to: CollisionEvents.Began.self, { event in
                let collisionEntity = Entity()
                collisionEntity.components.set(CollideComponent(event: event))
                gameManager.entities.scene.addChild(collisionEntity)
            })

        }
        .onTapGesture {
            
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}
