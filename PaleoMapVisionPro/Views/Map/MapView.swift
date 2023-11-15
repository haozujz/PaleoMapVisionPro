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
    //@EnvironmentObject private var viewModel: MapViewModel
    @EnvironmentObject private var selectModel: RecordSelectModel
    
    @Environment(MapViewModel.self) private var viewModel
    
    @State private var isLocationServicesChecked: Bool = false
    
    @State private var selectedItem: String?
    @State private var salientRecord: Record? = nil
    @State private var isRecordCardShown: Bool = false
    @State private var isGlobeShown: Bool = true
    
    @Namespace var mapScope
    
//    let sydneyLongitude = 151.2093
//    let sydneyLatitude = -33.8688

    @State private var yaw: Double = 151.2093 * .pi / 180.0
    @State private var pitch: Double = -33.8688 * .pi / 180.0
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        GeometryReader { geometry in
                Map(
                    position: $viewModel.cameraPosition,
                    //interactionModes: [.pan, .zoom, .pitch, .rotate],
                    selection: $selectedItem,
                    scope: mapScope
                ) {
                    UserAnnotation()
                    
                    ForEach(selectModel.records) { record in
                        Marker(record.commonName == "" ? record.family.capitalized : record.commonName.capitalized, systemImage: record.icon, coordinate: record.locationCoordinate)
                            .tint(record.color)
                            .annotationTitles(.hidden)
                            .tag(record.id)
                    }
                }
                .mapStyle(.hybrid(
                    elevation: .realistic,
                    pointsOfInterest:
                            .including([.amusementPark,
                                        .aquarium,
                                        .campground,
                                        .museum,
                                        .nationalPark,
                                        .park,
                                        .zoo]), 
                    showsTraffic: false)
                )
                .mapControlVisibility(.hidden)
                .overlay(alignment: .topTrailing) {
                    VStack(spacing: 8) {
                        MapUserLocationButton(scope: mapScope)
                        MapPitchToggle(scope: mapScope)
                        MapCompass(scope: mapScope)
                    }
                    .buttonBorderShape(.circle)
                    .padding(8)
                    .padding(.top, 8)
                    .padding(.trailing, 8)
                    //.offset(z: 1.0)
                }
                .mapScope(mapScope)
//                .mapControls {
//                    VStack {
//                        MapUserLocationButton()
//                            .padding(.bottom, geometry.safeAreaInsets.trailing + 50)
//                        MapPitchToggle()
//                        MapCompass()
//                    }
//                    .buttonBorderShape(.circle)
//                    .padding(30)
//                    .padding(.bottom, geometry.safeAreaInsets.trailing + 50)
//                }
                .overlay(alignment: .bottomTrailing) {
                    Toggle("Show Globe", isOn: $isGlobeShown)
                        .toggleStyle(.button)
                        .padding(18)
                        //.offset(z: 1.0)
                }
//                .ornament(visibility: .automatic, attachmentAnchor: .scene(.bottomLeading)) {
//                }
                .overlay(alignment: .bottom) {
                    GlobeView(yaw: $yaw, pitch: $pitch)
                        .opacity(isGlobeShown ? 1 : 0)
                        //.transition(.scale)
                        //.animation(.easeInOut(duration: 0.2), value: isGlobeShown)
                        .offset(z: 148.0)
                        .environment(viewModel)
                        .offset(x: 536)
                }
                .overlay(alignment: .bottom) {
                    if let salientRecord = salientRecord {
                        RecordCard(record: salientRecord)
                            .opacity(isRecordCardShown ? 1 : 0)
                            .rotation3DEffect(.degrees(12), axis: (x: 1.0, y: 1.0, z: 0.0))
                            .offset(x: -374.0)
                            .offset(z: 270.0)
                            
                    }
                }
                .task {
                    // Consider removing this later
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
                    
                    let threshold = 0.0001
                    
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
                    withAnimation(.easeInOut) {
                        if selectedItem == nil {
                            Task { @MainActor in
                                isRecordCardShown = false
                            }
                        } else {
                            if let record = selectModel.records.first(where: { $0.id == selectedItem }) {
                                Task { @MainActor in
                                    salientRecord = record
                                    isRecordCardShown = true
                                }
                            }
                        }
                    }
                    
                }
                .alert("Alert", isPresented: $viewModel.isShowAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(viewModel.alertMessage)
                }
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

