//
//  GlobeView.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 12/11/2023.
//

import SwiftUI
import RealityKit
import RealityKitContent

import CoreLocation

struct GlobeView: View {
    @Environment(MapViewModel.self) private var viewModel
    @Binding var yaw: Double
    @Binding var pitch: Double

    @State private var baseYaw: Double
    @State private var basePitch: Double
    
    let sensitivity: Double = 0.009
    let buffer: Double =  12 * .pi / 180
    
    init(yaw: Binding<Double>, pitch: Binding<Double>) {
        self._yaw = yaw
        self._pitch = pitch
        self._baseYaw = State(initialValue: yaw.wrappedValue + (.pi/4))
        self._basePitch = State(initialValue: pitch.wrappedValue * -1)
    }
    
    var body: some View {
        Model3D(named: "Scene", bundle: realityKitContentBundle) { phase in
            switch phase {
                case .empty:
                    ProgressView()
                case .failure(let error):
                    Text("Error \(error.localizedDescription)")
                case .success(let model):
                    model
                    .rotation3DEffect(.degrees((yaw * 180.0 / .pi) + 67.5), axis: (x: 0.0, y: 1.0, z: 0.0))
                    .rotation3DEffect(.degrees(pitch * 180.0 / .pi), axis: (x: 1.0, y: 0.0, z: 0.0))
                    .gesture(
                        DragGesture()
                            .targetedToAnyEntity()
                            .onChanged { value in
                                // if isReadyToUpdateGlobeBase {=false}
                                
                                let delta = value.translation
                                yaw = baseYaw + Double(delta.width) * sensitivity
                                
                                let interimPitch = basePitch + Double(delta.height) * sensitivity * -1
                                let lowerLimit = -(.pi / 2) + buffer
                                let upperLimit = .pi / 2 - buffer
                                pitch = min(max(interimPitch, lowerLimit), upperLimit)
                                
                                let newLon = yawToLongitude(yaw: yaw)
                                let newLat = pitchToLatitude(pitch: pitch)
                                
                                viewModel.changeLocation(coord: CLLocationCoordinate2D(latitude: newLat, longitude: newLon), isSpanLarge: true)
                            }
                            .onEnded { value in
                                baseYaw = yaw
                                basePitch = pitch
                                
                                // isReadyToUpdateGlobeBase {=true}
                            }
                    )
            @unknown default:
                Text("Error default")
            }
        }
        
    }
    
}

#Preview {
    GlobeView(yaw: .constant(0.0), pitch: .constant(0.0))
}

func pitchToLatitude(pitch: Double) -> Double {
    let latitude = pitch * -180.0 / .pi
    // Ensure latitude is within the valid range
    return max(min(latitude, 90.0), -90.0)
}

func yawToLongitude(yaw: Double) -> Double {
    var longitude = yaw * -180.0 / .pi
    // Normalize the longitude to be within the range of -180 to 180 degrees
    longitude = longitude.truncatingRemainder(dividingBy: 360.0)
    if longitude < -180 {
        longitude += 360
    } else if longitude > 180 {
        longitude -= 360
    }
    return longitude
}
