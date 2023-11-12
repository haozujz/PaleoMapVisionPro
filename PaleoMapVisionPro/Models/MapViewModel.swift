//
//  MapViewModel.swift
//  Paleo
//
//  Created by Joseph Zhu on 25/5/2022.
//

import MapKit
import SwiftUI

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}

//extension MKCoordinateSpan: Equatable {}
//
//public func ==(lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
//    return lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
//}
//
//extension MKCoordinateRegion: Equatable {}
//
//public func ==(lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
//    return lhs.center == rhs.center && lhs.span == rhs.span
//}

enum MapDetails {
    static let defaultLocation = CLLocationCoordinate2D(latitude:  -33.8688, longitude: 151.2093)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    //@Published var region: MKCoordinateRegion
    @Published var cameraPosition: MapCameraPosition
    @Published var isShowAlert: Bool = false
    var locationManager: CLLocationManager?
    var alertMessage: String = ""

    override init() {
        let initialRegion = MKCoordinateRegion(
            center: MapDetails.defaultLocation,
            span: MapDetails.defaultSpan
        )
        
        //self.region = initialRegion
        self.cameraPosition = MapCameraPosition.region(initialRegion)
        
        super.init()
    }
    
    func checkIfLocationServicesIsEnabled() {
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager?.delegate = self
            
        // Request the current authorization status
        locationManager?.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("Location Authorization Not Determined")
            //manager.requestWhenInUseAuthorization()
        case .restricted:
            alertMessage = "Your location is restricted, possibly due to parental controls"
            isShowAlert = true
        case .denied:
            alertMessage = "You have denied this app location permission. Go into settings to change it."
            isShowAlert = true
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location Authorization Confirmed")
//            var initialLocation: CLLocationCoordinate2D
//            let savedLat = UserDefaults.standard.double(forKey: "lat")
//            let savedLon = UserDefaults.standard.double(forKey: "lon")
//            
//            if (savedLat == 0.0) && (savedLon == 0.0) {
//                initialLocation = MapDetails.defaultLocation
//            } else {
//                initialLocation = CLLocationCoordinate2D(latitude: savedLat, longitude: savedLon)
//            }
//
////            region = MKCoordinateRegion(
////                center: manager.location?.coordinate ?? initialLocation,
////                span: MapDetails.defaultSpan)
////            
//            DispatchQueue.main.async {
//                self.region = MKCoordinateRegion(
//                    center: manager.location?.coordinate ?? initialLocation,
//                    span: MapDetails.defaultSpan)
//                self.cameraPosition = MapCameraPosition.region(self.region)
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
            isShowAlert = true
            return
        }
        locationManager?.stopUpdatingLocation()
        
        UserDefaults.standard.set(latestLocation.coordinate.latitude, forKey: "lat")
        UserDefaults.standard.set(latestLocation.coordinate.longitude, forKey: "lon")
        
//        DispatchQueue.main.async {
//            self.region = MKCoordinateRegion(
//                center: latestLocation.coordinate,
//                span: MapDetails.defaultSpan)
//            self.cameraPosition = MapCameraPosition.region(self.region)
//        }
        
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
    
    func changeLocation(coord: CLLocationCoordinate2D) {
//        DispatchQueue.main.async {
//            self.region = MKCoordinateRegion(
//                center: coord,
//                span: self.cameraPosition.region!.span)
//            self.cameraPosition = MapCameraPosition.region(self.region)
//        }
        
        let x = MKCoordinateRegion(
            center: coord,
            span: self.cameraPosition.region!.span
        )
        
        Task { @MainActor in
            self.cameraPosition = MapCameraPosition.region(x)
        }
    }
}
