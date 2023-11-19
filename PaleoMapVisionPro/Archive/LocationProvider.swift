//
//  LocationProvider.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 19/11/2023.
//

import SwiftUI
import MapKit
import CoreLocation
import Observation


@Observable
class MapViewModel2 {

    static let shared = MapViewModel2()

    private let manager: CLLocationManager
    private var background: CLBackgroundActivitySession?

    var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.710057, longitude: 139.810718),
        span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
    ))

    var lastLocation = CLLocation()
    var count = 0
    var isStationary = false

    var updatesStarted: Bool = false
    
    var isShowAlert: Bool = false
    var alertMessage: String = ""

    init() {
        self.manager = CLLocationManager()
    }

    func startLocationUpdates() {
        if self.manager.authorizationStatus == .notDetermined {
            self.manager.requestWhenInUseAuthorization()
        }
        Task() {
            do {
                self.updatesStarted = true
                let updates = CLLocationUpdate.liveUpdates()
                for try await update in updates {
                    if !self.updatesStarted { break }
                    if let loc = update.location {
                        self.lastLocation = loc
                        self.isStationary = update.isStationary
                        self.count += 1

                        let center = CLLocationCoordinate2D(
                            latitude: loc.coordinate.latitude,
                            longitude: loc.coordinate.longitude)

                        self.cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
                            center: center,
                            span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
                        ))
                    }
                }
            } catch {
                
            }
            return
        }
    }

    func stopLocationUpdates() {
        self.updatesStarted = false
    }
    
    func checkIfLocationServicesIsEnabled() {
    }
    
    func changeLocation(coord: CLLocationCoordinate2D, isSpanLarge: Bool = false) {
//        let x = MKCoordinateRegion(
//            center: coord,
//            span: isSpanLarge ? MapDetails.largeSpan : MapDetails.defaultSpan
//        )
        
        Task { @MainActor in
            //self.cameraPosition = MapCameraPosition.region(x)
            self.cameraPosition = MapCameraPosition.camera(
                MapCamera(centerCoordinate: coord, distance: isSpanLarge ? MapDetails.largeDistance : MapDetails.defaultDistance)
            )
        }
    }
}

    
