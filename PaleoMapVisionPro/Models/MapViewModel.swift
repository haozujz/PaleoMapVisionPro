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
    var locationManager: CLLocationManager
    
    var cameraPosition = MapCameraPosition.userLocation(fallback:
            MapCameraPosition.region(MKCoordinateRegion(
            center: MapDetails.defaultLocation,
            span: MapDetails.defaultSpan
        ))
    )
    
    var yaw: Double = 151.2093 * .pi / 180.0
    var pitch: Double = -33.8688 * .pi / 180.0
    var isDraggingGlobe: Bool = false
    
    var isLocationServicesChecked: Bool = false
    var selectedItem: Record? = nil
    var isRecordCardShown: Bool = false
    var isShowAlert: Bool = false
    var alertMessage: String = ""

    var isGlobeShown: Bool {
        didSet {
            UserDefaults.standard.set(isGlobeShown, forKey: "isGlobeShown")
        }
    }
    
    override init() {
        self.locationManager = CLLocationManager()
        
        if UserDefaults.standard.object(forKey: "isGlobeShown") != nil {
            isGlobeShown = UserDefaults.standard.bool(forKey: "isGlobeShown")
        } else {
            isGlobeShown = true
        }
        
        super.init()
    }
    
    func checkIfLocationServicesIsEnabled() {
        Task {
            if CLLocationManager.locationServicesEnabled() {
                print("Location Services is enabled")
                locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
                locationManager.delegate = self
                
                // Request the current authorization status
                locationManager.requestWhenInUseAuthorization()
            } else {
                alertMessage = "Allow Location Access"
                Task { @MainActor in
                    isShowAlert = true
                }
            }
        }
    }

 
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func changeLocation(coord: CLLocationCoordinate2D, isSpanLarge: Bool = false) {
        Task { @MainActor in
            self.cameraPosition = MapCameraPosition.camera(
                MapCamera(centerCoordinate: coord, distance: isSpanLarge ? MapDetails.largeDistance : MapDetails.defaultDistance)
            )
        }
    }
    
}


//extension CLLocationCoordinate2D: Equatable {
//    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
//        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
//    }
//}
