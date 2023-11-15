//
//  MapViewModel.swift
//  Paleo
//
//  Created by Joseph Zhu on 25/5/2022.
//

import MapKit
import SwiftUI
import Observation


enum MapDetails {
    static let defaultLocation = CLLocationCoordinate2D(latitude:  -33.8688, longitude: 151.2093)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    static let largeSpan = MKCoordinateSpan(latitudeDelta: 60, longitudeDelta: 60)
    static let defaultDistance = 10000.0
    static let largeDistance = 7000000.0
}

@Observable
final class MapViewModel: NSObject, CLLocationManagerDelegate {
    var cameraPosition: MapCameraPosition
    var isShowAlert: Bool = false
    
    var locationManager: CLLocationManager?
    var alertMessage: String = ""

    override init() {
        let initialRegion = MKCoordinateRegion(
            center: MapDetails.defaultLocation,
            span: MapDetails.defaultSpan
        )
        
        let fallback = MapCameraPosition.region(initialRegion)
        self.cameraPosition = .userLocation(fallback: fallback)
        
        super.init()
    }
    
    func checkIfLocationServicesIsEnabled() {
        Task {
            if CLLocationManager.locationServicesEnabled() {
                print("Location Services is enabled")
                locationManager = CLLocationManager()
                locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
                locationManager?.delegate = self
                
                // Request the current authorization status
                locationManager?.requestWhenInUseAuthorization()
            } else {
                alertMessage = "Allow Location Access"
                Task { @MainActor in
                    isShowAlert = true
                }
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("locationManagerDidChangeAuthorization")
        
        switch manager.authorizationStatus {
        case .notDetermined:
            print("Location Authorization Not Determined")
            //manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location Authorization Restricted")
            alertMessage = "Your location is restricted, possibly due to parental controls"
            Task { @MainActor in
                isShowAlert = true
            }
        case .denied:
            print("Location Authorization Denied")
//            alertMessage = "You have denied this app location permission. Consider changing this in the settings."
//            Task { @MainActor in
//                isShowAlert = true
//            }
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location Authorization Confirmed")
            
//            let x = MKCoordinateRegion(
//                center: locationManager?.location?.coordinate ?? MapDetails.defaultLocation,
//                span: MapDetails.defaultSpan
//            )
            
//            Task { @MainActor in
                //self.cameraPosition = MapCameraPosition.region(x)
//                self.cameraPosition = MapCameraPosition.camera(
//                    MapCamera(centerCoordinate: locationManager?.location?.coordinate ?? MapDetails.defaultLocation, distance: MapDetails.defaultDistance)
//                )
//            }
        @unknown default:
            break
        }
    }

    func requestAllowOnceLocationPermission() {
        //locationManager?.requestLocation()    //slower & more accurate
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {
            alertMessage = "Could not retrieve user location"
            Task { @MainActor in
                isShowAlert = true
            }
            return
        }
        locationManager?.stopUpdatingLocation()
        
        let x = MKCoordinateRegion(
            center: latestLocation.coordinate,
            span: MapDetails.defaultSpan
        )
        
        Task { @MainActor in
            self.cameraPosition = MapCameraPosition.region(x)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
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
