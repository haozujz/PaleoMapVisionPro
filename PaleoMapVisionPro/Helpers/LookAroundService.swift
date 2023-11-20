//
//  LookAroundService.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 19/11/2023.
//

import Foundation
import CoreLocation
import MapKit

enum LookAroundService {
    enum LookaroundError: Error {
        case unableToCreateScene
    }

    static func fetchSnapshot(coord: CLLocationCoordinate2D) async throws -> UIImage {
        guard let scene = try await MKLookAroundSceneRequest(coordinate: coord).scene else {
            throw LookaroundError.unableToCreateScene
        }
        let options = MKLookAroundSnapshotter.Options()
        options.size = CGSize(width: 1000, height: 210)
        return try await MKLookAroundSnapshotter(scene: scene, options: options).snapshot.image
    }

    static func fetchScene(coord: CLLocationCoordinate2D) async throws -> MKLookAroundScene {
        guard let request = try await MKLookAroundSceneRequest(coordinate: coord).scene else {
            throw LookaroundError.unableToCreateScene
        }
        return request
    }
}
