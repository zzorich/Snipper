//
//  File.swift
//  Snipper
//
//  Created by lingji zhou on 3/19/24.
//

import Foundation
import Observation
import RealityKit
import Spatial
import RealityKitContent

@MainActor
@Observable
final class GameModel {
    enum State { case preparingScene, readyToStart, isPlaying, isPaused }
    var gameState = State.preparingScene
    var shootAnimationController: AnimationPlaybackController?

    var gun: Entity!
    var gunDefaultTransform: simd_float4x4 = .init()

    func generateRandomLocationsForDrummers() {
        for (index, drummer) in drummers.enumerated() {
            drummer.position = .init(x: drummerLocation[index].0, y: drummerLocation[index].1, z: .random(in: -5 ... -3))
        }
    }

    @MainActor
    func loadGun() async {
        gun = await BundleAssets.loadEntity(asset: BundleAssets.bullet)
        assert(gun != nil)
    }

    func attachGunToHead() {
        cameraAnchor.addChild(gun)
        gun.position = .init([0, 0, -0.5])
        gun.transform.rotation = .init(angle: .pi, axis: .init([0, 1, 0]))
//        gun.transform.rotation = .init(angle: .pi / 12, axis: .init([1, 0, 0])) *  gun.transform.rotation
        gunDefaultTransform = gun.transform.matrix
    }


    func shoot() {
        guard let gun else { return }
        let distanceVec = simd_normalize(gun.transform.matrix * SIMD4<Float>([0, 0, -1, 0]))
        var newTransform = Transform(matrix: gun.transform.matrix)
        newTransform.translation += 5.0 * simd_float3([distanceVec.x, distanceVec.y, distanceVec.z])
        let shootAnimationCurve = FromToByAnimation<Transform>(
            name: "Shoot animation",
            from: gun.transform,
            to: newTransform,
            duration: 3,
            bindTarget: .transform
        )

        let shootAnimation = try! AnimationResource.generate(with: shootAnimationCurve)
        shootAnimationController =  gun.playAnimation(shootAnimation, startsPaused: false)


    }

    func handleShootAnimationCompletion(event: AnimationEvents.PlaybackCompleted) {
        gun.transform.matrix = gunDefaultTransform
    }
}

