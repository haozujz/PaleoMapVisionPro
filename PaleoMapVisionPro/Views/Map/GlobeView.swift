//
//  GlobeView.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 12/11/2023.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct GlobeView: View {
    //@Binding var longitude: Double
    //@Binding var latitude: Double

    @Binding var yaw: Double
    @Binding var pitch: Double
    
    @State private var baseYaw: Double
    @State private var basePitch: Double
    
    let sensitivity = 0.01
    
    init(yaw: Binding<Double>, pitch: Binding<Double>) {
        self._yaw = yaw
        self._pitch = pitch
        // Initialize baseYaw and basePitch with the initial values of yaw and pitch
        self._baseYaw = State(initialValue: yaw.wrappedValue + (.pi/4))
        self._basePitch = State(initialValue: pitch.wrappedValue * -1)
    }
    
    var body: some View {
        Model3D(named: "Scene", bundle: realityKitContentBundle)
            //.rotation3DEffect(.degrees((longitude * 180.0 / .pi) + 67.5), axis: (x: 0.0, y: 1.0, z: 0.0))
            .rotation3DEffect(.degrees((yaw * 180.0 / .pi) + 67.5), axis: (x: 0.0, y: 1.0, z: 0.0)) // Apply yaw
            .rotation3DEffect(.degrees(pitch * 180.0 / .pi), axis: (x: 1.0, y: 0.0, z: 0.0)) // Apply pitch
        
            
            .gesture(
                DragGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in
                        let delta = value.translation
                        yaw = baseYaw + Double(delta.width) * sensitivity
                        pitch = basePitch + Double(delta.height) * sensitivity * -1
                    }
                    .onEnded { value in
                        baseYaw = yaw
                        basePitch = pitch
                    }
            )
    }
}

#Preview {
    GlobeView(yaw: .constant(0.0), pitch: .constant(0.0))
}
