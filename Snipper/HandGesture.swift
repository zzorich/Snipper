//
//  HandGesture.swift
//  Snipper
//
//  Created by lingji zhou on 3/23/24.
//

import Foundation
import ARKit

@MainActor
class HandGesture: ObservableObject, @unchecked Sendable {
    let session = ARKitSession()
    var handTracking = HandTrackingProvider()
    @Published var latestHandTracking: HandsUpdates = .init(left: nil, right: nil)

    struct HandsUpdates {
        var left: HandAnchor?
        var right: HandAnchor?
    }

    func start() async {
        do {
            if HandTrackingProvider.isSupported {
                print("ARKitSession starting.")
                try await session.run([handTracking])
            }
        } catch {
            print("ARKitSession error:", error)
        }
    }

    func publishHandTrackingUpdates() async {
        for await update in handTracking.anchorUpdates {
            switch update.event {
            case .updated:
                let anchor = update.anchor

                // Publish updates only if the hand and the relevant joints are tracked.
                guard anchor.isTracked else { continue }

                // Update left hand info.
                if anchor.chirality == .left {
                    latestHandTracking.left = anchor
                } else if anchor.chirality == .right { // Update right hand info.
                    latestHandTracking.right = anchor
                }
            default:
                break
            }
        }
    }

    func monitorSessionEvents() async {
        for await event in session.events {
            switch event {
            case .authorizationChanged(let type, let status):
                if type == .handTracking && status != .allowed {
                    // Stop the game, ask the user to grant hand tracking authorization again in Settings.
                }
            default:
                print("Session event \(event)")
            }
        }
    }

}
