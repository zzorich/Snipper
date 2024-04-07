//
//  CollisionSystem.swift
//  Snipper
//
//  Created by lingji zhou on 4/6/24.
//

import Foundation
import RealityKit

class CollisionSystem: System {
    required init(scene: Scene) {
    }
    
    func update(context: SceneUpdateContext) {
        context.entities(matching: .init(where: .has(CollideComponent.self)), updatingSystemWhen: .rendering).forEach { entity in
            guard let event = entity.components[CollideComponent.self]?.event else { return }
            if event.entityA.name == "gun" && event.entityB.name == "plane" {
                event.entityB.removeFromParent()
            } else if event.entityB.name == "gun" && event.entityA.name == "plane" {
                event.entityA.removeFromParent()
            }
            entity.removeFromParent()
        }
    }
}

struct CollideComponent: Component {
    let event: CollisionEvents.Began
}
