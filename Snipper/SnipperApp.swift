//
//  SnipperApp.swift
//  Snipper
//
//  Created by lingji zhou on 3/19/24.
//

import SwiftUI

@main
@MainActor
struct SnipperApp: App {
    var gameModel = GameModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(gameModel)
                .onAppear {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    windowScene.requestGeometryUpdate(.Vision(resizingRestrictions: UIWindowScene.ResizingRestrictions.none))
                }
        }
        .windowStyle(.plain)

        ImmersiveSpace(id: "Main") {
            ImmersiveView()
                .environment(gameModel)
        }
    }
}
