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

struct GameEntities {

    let scene: Entity
    let gun: Entity
    let gunParent: Entity
    let planes: [Entity]
    let headAnchor: Entity

    @MainActor
    init() async throws {
        scene = Entity()
        async let _gun = loadEntity(named: .gun)
        async let _plane = loadEntity(named: .plane)

        let (gun, plane) = try await (_gun, _plane)
        gunParent = Entity()
        gunParent.addChild(gun)
        self.gun = gun

        headAnchor = AnchorEntity(.head)
        headAnchor.addChild(gunParent)
        scene.addChild(headAnchor)

        let planeParent = Entity()
        planeParent.addChild(plane)
        var planes = [Entity]()
        planes.append(plane)
        for _ in 1..<maxNumberOfPlanes {
            let copyedPlane = plane.clone(recursive: true)
            let copyedPlaneParent = Entity()
            copyedPlaneParent.addChild(copyedPlane)
            scene.addChild(copyedPlaneParent)
            planes.append(copyedPlane)
        }
        self.planes = planes
    }
}

extension String {
    static let plane = "Plane.usdz"
    static let gun = "DrumStick.usdz"
    static let drummer = "Drummer.usdz"
}

private func loadEntity(named asset: String) async throws -> Entity {
    try await Entity(named: asset, in: .realityKitContentBundle)
}
