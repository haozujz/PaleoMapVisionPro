//
//  GlobeView2.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 17/11/2023.
//

import SwiftUI
import RealityKit
import RealityKitContent

import CoreLocation
import MapKit

struct GlobeView2: View {
    //@Binding var longitude: Double
    //@Binding var latitude: Double
    //@EnvironmentObject private var viewModel: MapViewModel
    
    @Environment(MapViewModel.self) private var viewModel
    @Binding var camera: MapCameraPosition
    
    
//    @Binding var yaw: Double
//    @Binding var pitch: Double
    
    @State var yaw: Double
    @State var pitch: Double
    
    @State private var baseYaw: Double
    @State private var basePitch: Double
//    
    let sensitivity: Double = 0.009
    let buffer: Double =  12 * .pi / 180
    
    init(pos: Binding<MapCameraPosition>) {
        self._camera = pos
        
//        let initialYaw = pos.wrappedValue.region?.center.longitude ?? 0 * -.pi / 180.0
//        let initialPitch = pos.wrappedValue.region?.center.latitude ?? 0 * -.pi / 180.0
        let initialYaw = pos.wrappedValue.camera?.centerCoordinate.longitude ?? 0 * -.pi / 180.0
        let initialPitch = pos.wrappedValue.camera?.centerCoordinate.latitude ?? 0 * -.pi / 180.0
        
        //self._yaw = yaw
        //self._pitch = pitch
        self._yaw = State(initialValue: initialYaw + (.pi/4))
        self._pitch = State(initialValue: initialPitch * -1)
        self._baseYaw = State(initialValue: initialYaw + (.pi/4))
        self._basePitch = State(initialValue: initialPitch * -1)
    }
    
    var body: some View {
        //Text("\(camera.camera?.centerCoordinate.latitude)")
        
        Model3D(named: "Scene", bundle: realityKitContentBundle)
//            .rotation3DEffect(.degrees((yaw * 180.0 / .pi) + 67.5), axis: (x: 0.0, y: 1.0, z: 0.0))
//            .rotation3DEffect(.degrees(pitch * 180.0 / .pi), axis: (x: 1.0, y: 0.0, z: 0.0))
        
            .rotation3DEffect(.degrees((camera.camera?.centerCoordinate.longitude ?? 0) * -1 + 67.5), axis: (x: 0.0, y: 1.0, z: 0.0))
            .rotation3DEffect(.degrees(camera.camera?.centerCoordinate.latitude ?? 0) * -1, axis: (x: 1.0, y: 0.0, z: 0.0))
//            .rotation3DEffect(.radians(camera.region?.center.longitude ?? 0 * -.pi / 180.0), axis: (x: 0.0, y: 1.0, z: 0.0))
//            .rotation3DEffect(.radians(camera.region?.center.latitude ?? 0 * -.pi / 180.0), axis: (x: 1.0, y: 0.0, z: 0.0))
        
            .gesture(
                DragGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in
                        print(camera)
//                        // if isReadyToUpdateGlobeBase {=false}
//                        
                        let delta = value.translation
                        yaw = baseYaw + Double(delta.width) * sensitivity
                        
                        let interimPitch = basePitch + Double(delta.height) * sensitivity * -1
                        let lowerLimit = -(.pi / 2) + buffer
                        let upperLimit = .pi / 2 - buffer
                        pitch = min(max(interimPitch, lowerLimit), upperLimit)
                        
                        let newLon = yawToLongitude(yaw: yaw)
                        let newLat = pitchToLatitude(pitch: pitch)
//                        
//                        viewModel.changeLocation(coord: CLLocationCoordinate2D(latitude: newLat, longitude: newLon), isSpanLarge: true)
                        camera = MapCameraPosition.camera(
                            MapCamera(
                                centerCoordinate: CLLocationCoordinate2D(latitude: newLat, longitude: newLon),
                                distance: MapDetails.largeDistance
                            )
                        )
                    }
                    .onEnded { value in
                        baseYaw = yaw
                        basePitch = pitch
                        
                        // isReadyToUpdateGlobeBase {=true}
                    }
            )
    }
}

//#Preview {
//    GlobeView(yaw: .constant(0.0), pitch: .constant(0.0))
//}


