//
//  GameModelManager.swift
//  Snipper
//
//  Created by lingji zhou on 4/4/24.
//

import Foundation
import Observation
import RealityKit


@Observable
final class GameModelManager {
    @ObservationIgnored var entities: GameEntities!
    @ObservationIgnored var planAnimationResources: [Entity.ID: AnimationResource] = [:]
    @ObservationIgnored var shootAnimationResource: AnimationResource!
    @ObservationIgnored var shootAnimationController: AnimationPlaybackController?

    private var isResourceLoaded: Bool = false


    init() {
        Task {
            do {
                try await loadResources()
            } catch {
                fatalError("failed to load resources")
            }
        }
    }

    func loadResources() async throws {
        guard !isResourceLoaded else { return }
        defer { isResourceLoaded = true }
        entities = try await GameEntities()
        try generateAnimations()
    }

    private func generateAnimations() throws {
        try entities.planes.forEach { plane in
            let orbitAnimationCurve = OrbitAnimation(
                axis: .init([0, 0, -1]),
                startTransform: .init(translation: .init([0, 1, 0])),
                bindTarget: .transform,
                repeatMode: .repeat,
                delay: .random(in: 0..<2), 
                speed: 0.5
            )
            planAnimationResources[plane.id] = try .generate(with: orbitAnimationCurve)
        }

        let shootAnimationDefintion = FromToByAnimation<Transform>(
            by: .init(translation: .init(.zero, 8)),
            bindTarget: .transform
        )
        shootAnimationResource =  try .generate(with: shootAnimationDefintion)
    }

    func setupGeometries() {
        entities.planes.enumerated().forEach { index, plane in
            let location = planeLocations[index]
            plane.parent?.transform.translation = .init(x: location.0, y: location.1, z: location.2 + 3)
        }

        entities.gunParent.transform = .init(pitch: -.pi / 6, yaw: .pi)
        entities.gunParent.position = .init(.zero, -1)
    }

    func playRecurrentPlanesAnimations() {
        entities.planes.forEach { plane in
            guard let animation = planAnimationResources[plane.id] else { return }
            plane.playAnimation(animation, transitionDuration: .zero, startsPaused: false)
        }
    }

    func shoot() {
        shootAnimationController = entities.gun.playAnimation(shootAnimationResource, transitionDuration: .zero, startsPaused: false)
    }
}
