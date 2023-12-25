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
    
    @GestureState var gestureState: CGSize = .zero
    
    @State private var baseYaw: Double
    @State private var basePitch: Double
    
    let sensitivity: Double = 0.008
    // Buffer for the top and bottom of the globe
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
                    .rotation3DEffect(.degrees(((gestureState != .zero ? getYawDegFrom(width: gestureState.width) : yaw) * 180.0 / .pi) + 67.5 ), axis: (x: 0.0, y: 1.0, z: 0.0))
                    .rotation3DEffect(.degrees((gestureState != .zero ? getPitchDegFrom(height: gestureState.height) : pitch) * 180.0 / .pi ), axis: (x: 1.0, y: 0.0, z: 0.0))
                    .gesture(
                        DragGesture()
                            .updating($gestureState) { value, state, transaction in
                                if !viewModel.isDraggingGlobe {
                                    viewModel.isDraggingGlobe = true
                                }
                                
                                state = value.translation
                                
                                let newYaw = getYawDegFrom(width: value.translation.width)
                                let newPitch = getPitchDegFrom(height: value.translation.height)
                                
                                let newLon = yawToLongitude(yaw: newYaw)
                                let newLat = pitchToLatitude(pitch: newPitch)
                                
                                viewModel.changeLocation(coord: CLLocationCoordinate2D(latitude: newLat, longitude: newLon), isSpanLarge: true)
                            }
                            .onEnded { value in
                                onChange(delta: value.translation)
                                viewModel.isDraggingGlobe = false
                                
                                // Redundant
                                baseYaw = yaw
                                basePitch = pitch
                            }
                    )
                    .onChange(of: yaw) {
                        baseYaw = yaw
                    }
                    .onChange(of: pitch) {
                        basePitch = pitch
                    }
            @unknown default:
                Text("Error default")
            }
        }
    }
    
    private func onChange(delta: CGSize) {
        if !viewModel.isDraggingGlobe {
            viewModel.isDraggingGlobe = true
        }
        
        yaw = getYawDegFrom(width: Double(delta.width))
        pitch = getPitchDegFrom(height: Double(delta.height))
        
        let newLon = yawToLongitude(yaw: yaw)
        let newLat = pitchToLatitude(pitch: pitch)
        
        viewModel.changeLocation(coord: CLLocationCoordinate2D(latitude: newLat, longitude: newLon), isSpanLarge: true)
    }
    
    private func getYawDegFrom(width: Double) -> Double {
        let x = baseYaw + width * sensitivity

        return x
    }
    
    private func getPitchDegFrom(height: Double) -> Double {
        let interimPitch = basePitch + height * sensitivity * -1
        let lowerLimit = -(.pi / 2) + buffer
        let upperLimit = .pi / 2 - buffer
        let x = min(max(interimPitch, lowerLimit), upperLimit)
        
        return x
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





