//
//  MapView.swift
//  Paleo
//
//  Created by Joseph Zhu on 25/5/2022.
//

import SwiftUI
import MapKit
//import CoreLocationUI
import Combine

import RealityKit
import RealityKitContent

struct MapView: View {
    @EnvironmentObject private var modelData: ModelData
    @EnvironmentObject private var viewModel: MapViewModel
    @EnvironmentObject private var selectModel: RecordSelectModel
    
    @State private var isLocationServicesChecked: Bool = false
    
    @State private var selectedItem: String?
    @State private var isRecordCardShown: Bool = false
    @State private var isGlobeShown: Bool = true
    
    //@Namespace var mapScope
    
//    let sydneyLongitude = 151.2093
//    let sydneyLatitude = -33.8688

    @State private var yaw: Double = 151.2093 * .pi / 180.0
    @State private var pitch: Double = -33.8688 * .pi / 180.0
    
//    @State private var yaw: Double = 151.2093 * .pi / 180.0
//    @State private var pitch: Double = -33.8688 * .pi / 180.0
    
    var body: some View {
        ZStack(alignment: .bottom) {
                Map(
                    position: $viewModel.cameraPosition,
                    selection: $selectedItem
                    //scope: mapScope
                ) {
                    UserAnnotation()
                    
                    ForEach(selectModel.records) { record in
                        Marker(record.family.capitalized, systemImage: record.icon, coordinate: record.locationCoordinate)
                            .tint(record.color)
                            .tag(record.id)
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
                //.mapScope(mapScope)
//                .onAppear {
//                    if !isLocationServicesChecked {
//                        viewModel.checkIfLocationServicesIsEnabled()
//                        isLocationServicesChecked = true
//                    }
//                }
                .task {
                    if !isLocationServicesChecked {
                        viewModel.checkIfLocationServicesIsEnabled()
                        isLocationServicesChecked = true
                    }
                }
                .onMapCameraChange(frequency: .continuous) { context in
                    selectModel.updateRecordsSelection(coord: context.region.center, db: modelData.db, recordsTable: modelData.recordsTable, boxesTable: modelData.boxesTable, filter: modelData.filterDict)
                    
                    // Convert map's center latitude and longitude to pitch and yaw.
                    let newYaw = context.region.center.longitude * -.pi / 180.0
                    let newPitch = (context.region.center.latitude) * -.pi / 180.0
                    
                    // Check the difference between the new yaw and pitch and the current ones.
                    let yawDiff = abs(newYaw - yaw)
                    let pitchDiff = abs(newPitch - pitch)
                    
                    let threshold = 0.0002
                    
                    // If the yaw difference exceeds the threshold, update the model's yaw.
                    if yawDiff > threshold {
                        Task { @MainActor in
                            yaw = newYaw
                        }
                    }
                    
                    // If the pitch difference exceeds the threshold, update the model's pitch.
                    if pitchDiff > threshold {
                        Task { @MainActor in
                            pitch = newPitch
                        }
                    }
                }
                .onChange(of: selectedItem, initial: false) {
                    guard selectedItem != nil else {
                        return
                    }
                    
                    withAnimation(.easeInOut) {
                        isRecordCardShown = true
                    }
                }
                .alert("Alert", isPresented: $viewModel.isShowAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(viewModel.alertMessage)
                }
                .mapControls {
                    ZStack {
                        MapUserLocationButton()
                        MapPitchToggle()
                        MapCompass()
                    }
                    .buttonBorderShape(.circle)
                    .padding()
                }
        }
//        .ornament(attachmentAnchor: .scene(.bottomLeading)) {

//        }
        .overlay(alignment: .bottomLeading) {
            if let recordId = selectedItem {
                if let record = selectModel.records.first(where: { $0.id == recordId }) {
                    RecordCard(record: record)
                        .frame(width: 1200)
                        .opacity(isRecordCardShown ? 1 : 0)
                        .offset(z: 200.0)
                        //.offset(x: -490, y: 36)   // For RecordCard2
                        .offset(x: -360, y: 36)
                        .rotation3DEffect(.degrees(12), axis: (x: 1.0, y: 1.0, z: 0.0))
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Toggle("Show Globe", isOn: $isGlobeShown)
                .toggleStyle(.button)
                .padding(16)
        }
        .overlay(alignment: .bottomTrailing) {
            GlobeView(yaw: $yaw, pitch: $pitch)
                .opacity(isGlobeShown ? 1 : 0)
                //.transition(.scale)
                //.animation(.easeInOut(duration: 0.2), value: isGlobeShown)
                .offset(z: 154.0)
                .offset(x: 2.0)
                .environmentObject(viewModel)
        }
        
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//            .environmentObject(MapViewModel())
//            .environmentObject(RecordSelectModel())
//    }
//}

