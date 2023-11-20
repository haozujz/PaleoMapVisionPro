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
    @Environment(ModelData.self) private var modelData
    @Environment(RecordSelectModel.self) private var selectModel
    @Environment(MapViewModel.self) private var viewModel
    @Environment(SearchModel.self) private var searchModel
    
    @Namespace var mapScope
    
    @State private var isRecordCardShown: Bool = false
    @State private var isGlobeShown: Bool = true
    @State private var yaw: Double = 151.2093 * .pi / 180.0
    @State private var pitch: Double = -33.8688 * .pi / 180.0
 
    var body: some View {
        @Bindable var viewModelB = viewModel
        
        ZStack {
                Map(
                    position: $viewModelB.cameraPosition,
                    //interactionModes: [.pan, .zoom, .pitch, .rotate],
                    selection: $viewModelB.selectedItem,
                    scope: mapScope
                ) {
                    UserAnnotation()
                    
                    ForEach(selectModel.records) { record in
                        Marker(record.commonName == "" ? record.family.capitalized : record.commonName.capitalized, systemImage: record.icon, coordinate: record.locationCoordinate)
                            .tint(record.color)
                            .annotationTitles(.hidden)
                            .tag(record)
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
                }
                .mapScope(mapScope)
//                .mapControls {
//                    VStack {
//                        MapUserLocationButton()
//                        MapPitchToggle()
//                        MapCompass()
//                    }
//                    .buttonBorderShape(.circle)
//                }
                .overlay(alignment: .bottomTrailing) {
                    Toggle(isGlobeShown ? "Hide Globe" : "Show Globe", isOn: $isGlobeShown)
                        .toggleStyle(.button)
                        .padding(18)
                        .offset(x: isGlobeShown ? -110 : 0)
                        .animation(.easeInOut(duration: 0.1), value: isGlobeShown)
                }
//                .ornament(visibility: .automatic, attachmentAnchor: .scene(.bottomLeading)) {
//                }
                .overlay(alignment: .bottom) {
                    GlobeView(yaw: $yaw, pitch: $pitch)
                        .opacity(isGlobeShown ? 1 : 0)
                        .offset(z: 148.0)
                        .environment(viewModel)
                        .offset(x: 536)
                }
                .overlay(alignment: .bottom) {
                    if let salientRecord = viewModel.salientRecord {
                        RecordCard(record: salientRecord)
                            .opacity(isRecordCardShown ? 1 : 0)
                            .rotation3DEffect(.degrees(12), axis: (x: 1.0, y: 1.0, z: 0.0))
                            .offset(x: -374.0)
                            .offset(z: 270.0)
                            .id(salientRecord.id)
                            .animation(.easeInOut(duration: 0.1), value: isRecordCardShown)
                    }
                }
                .task {
                    if !viewModel.isLocationServicesChecked {
                        viewModel.checkIfLocationServicesIsEnabled()
                        searchModel.loadTrie()
                        viewModel.isLocationServicesChecked = true
                    }
                }
                .onChange(of: modelData.filterDict) {
                    let coord = CLLocationCoordinate2D(latitude: viewModel.locationManager.location?.coordinate.latitude ?? 0.0, longitude: viewModel.locationManager.location?.coordinate.longitude ?? 0.0)
                    
                    
                    
                    selectModel.updateRecordsSelection(coord: coord, db: modelData.db, recordsTable: modelData.recordsTable, boxesTable: modelData.boxesTable, filter: modelData.filterDict, isIgnoreThreshold: true)
                }
                .onMapCameraChange(frequency: .continuous) { context in
                    selectModel.updateRecordsSelection(coord: context.region.center, db: modelData.db, recordsTable: modelData.recordsTable, boxesTable: modelData.boxesTable, filter: modelData.filterDict)
                    
                    // Convert map's center latitude and longitude to pitch and yaw.
                    let newYaw = context.region.center.longitude * -.pi / 180.0
                    let newPitch = (context.region.center.latitude) * -.pi / 180.0
//                    let newYaw = context.camera.centerCoordinate.longitude * -.pi / 180.0
//                    let newPitch = context.camera.centerCoordinate.latitude * -.pi / 180.0
                    
                    let yawDiff = abs(newYaw - yaw)
                    let pitchDiff = abs(newPitch - pitch)
                    
                    let threshold = 0.0001
                    
                    // If the difference exceeds the threshold, update the model's yaw and/or pitch.
                    if yawDiff > threshold {
                        Task { @MainActor in
                            yaw = newYaw
                        }
                    }
                    
                    if pitchDiff > threshold {
                        Task { @MainActor in
                            pitch = newPitch
                        }
                    }
                }
                .onChange(of: viewModel.selectedItem, initial: false) {
                    withAnimation(.easeInOut) {
                        if let record = viewModel.selectedItem {
                            Task { @MainActor in
                                viewModel.salientRecord = record
                                isRecordCardShown = true
                            }
                        } else {
                            Task { @MainActor in
                                isRecordCardShown = false
                            }
                        }
                    }
                    
                }
                .alert("Alert", isPresented: $viewModelB.isShowAlert) {
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

