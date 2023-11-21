//
//  ImmersiveModel.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 21/11/2023.
//

import SwiftUI
import Observation
import ARKit
import RealityKit
import RealityKitContent

@Observable
class ImmersiveModel {
    let arSession = ARKitSession()
    let worldTracking = WorldTrackingProvider()
    let handTracking = HandTrackingProvider()
    var contentEntity = Entity()
    
    func setupContentEntity(name: String = "Earth") async -> Entity {
        if let immersiveContentEntity = try? await Entity(named: name, in: realityKitContentBundle) {
            await contentEntity.addChild(immersiveContentEntity)
            print("Loaded entity: \(name)")
        }
        return contentEntity
    }

    func runSession() async {
            print("WorldTrackingProvider.isSupported: \(WorldTrackingProvider.isSupported)")
            print("HandTrackingProvider.isSupported: \(HandTrackingProvider.isSupported)")
            print("PlaneDetectionProvider.isSupported: \(PlaneDetectionProvider.isSupported)")
            print("SceneReconstructionProvider.isSupported: \(SceneReconstructionProvider.isSupported)")

            Task {
                let authorizationResult = await arSession.requestAuthorization(for: [.worldSensing, .handTracking])

                for (authorizationType, authorizationStatus) in authorizationResult {
                    print("Authorization status for \(authorizationType): \(authorizationStatus)")
                    switch authorizationStatus {
                    case .allowed:
                        break
                    case .denied:
                        break
                    case .notDetermined:
                        break
                    @unknown default:
                        break
                    }
                }
            }

            Task {
                try await arSession.run([worldTracking])

                for await update in worldTracking.anchorUpdates {
                    switch update.event {
                    case .added, .updated:
                        print("Anchor position updated.")
                    case .removed:
                        print("Anchor position now unknown.")
                    }
                }
            }
        }
}
