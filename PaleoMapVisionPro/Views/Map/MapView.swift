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
    //@State private var trackingMode: MapUserTrackingMode = .follow
    
    @State private var selectedItem: String?
    @State private var isRecordCardShown: Bool = false
    
    @State private var isGlobeShown: Bool = false
    
    //@Namespace var mapScope
    
    let sydneyLongitude = 151.2093
    let sydneyLatitude = -33.8688

    @State private var yaw: Double = 151.2093 * .pi / 180.0
    @State private var pitch: Double = -33.8688 * .pi / 180.0
    
    struct MapAnnotationView: View {
        let color: Color
        let icon: String
        
        var body: some View {
            ZStack {
                Image(systemName: "circle.fill")
                    .foregroundColor(color)
                    .saturation(0.6)
                    .font(.system(size: 35))
                Image(systemName: icon)
                    .foregroundColor(Color.init(red:0.1, green:0.1, blue:0.1))
                    .scaleEffect(CGSize(width: icon == "hare.fill" || icon == "fossil.shell.fill" || icon == "bird.fill" ? -1.0 : 1.0, height: 1.0))
                    .scaleEffect(icon == "seal.fill" ? 0.8 : 1.0)
                    .rotationEffect(.degrees(icon == "hurricane" ? -20.0 : 0.0))
                    .font(.system(size: icon == "hare.fill" || icon == "ant.fill" ? 20 : 25, weight: icon == "seal.fill" ? .thin : .bold))
                    .offset(y: icon == "hare.fill" || icon == "ant.fill" ? -1 : 0)
            }
            .symbolRenderingMode(.monochrome)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) { //[weak modelData, weak viewModel, weak selectModel] in
            //if let modelData = modelData, let viewModel = viewModel, let selectModel = selectModel {//
                
                Map(
                    position: $viewModel.cameraPosition,
                    selection: $selectedItem
                    //scope: mapScope
                ) {
                    //UserAnnotation()
                    
                    ForEach(selectModel.records) { record in
//                        Annotation(record.family.capitalized, coordinate: record.locationCoordinate) {
//                            MapAnnotationView(color: record.color, icon: record.icon)
//                                .onTapGesture {
//                                    print("tapped")
//                                    selectModel.updateSingleRecord(recordId: record.id, coord: record.locationCoordinate, db: modelData.db, recordsTable: modelData.recordsTable, isLikelyAnnotatedAlready: true)
//                                }
//                        }
//                        .annotationTitles(.hidden)
                        Marker(record.family.capitalized, systemImage: record.icon, coordinate: record.locationCoordinate)
                            .tint(record.color)
                            .tag(record.id)
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
//                .overlay(alignment: .bottomTrailing) {
//                    VStack {
//                        MapPitchToggle(scope: mapScope)
//                    }
//                    .padding(.trailing, 10)
//                    .buttonBorderShape(.circle)
//                }
                //.mapScope(mapScope)
                .onAppear {
                    if !isLocationServicesChecked {
                        viewModel.checkIfLocationServicesIsEnabled()
                        isLocationServicesChecked = true
                    }
                }
                .onMapCameraChange(frequency: .onEnd) { context in
                    selectModel.updateRecordsSelection(coord: context.region.center, db: modelData.db, recordsTable: modelData.recordsTable, boxesTable: modelData.boxesTable, filter: modelData.filterDict)
                    
                    // Convert map's center latitude and longitude to pitch and yaw.
                    let newYaw = context.region.center.longitude * -.pi / 180.0
                    let newPitch = (context.region.center.latitude) * -.pi / 180.0
                    
                    // Check the difference between the new yaw and pitch and the current ones.
                    let yawDiff = abs(newYaw - yaw)
                    let pitchDiff = abs(newPitch - pitch)
                    
                    let threshold = 0.005 // This can be adjusted based on your needs.
                    
                    // If the yaw difference exceeds the threshold, update the model's yaw.
                    if yawDiff > threshold {
                        yaw = newYaw
                    }
                    
                    // If the pitch difference exceeds the threshold, update the model's pitch.
                    if pitchDiff > threshold {
                        pitch = newPitch
                    }
                    
                    print("yaw\(yaw)")
                    print("pitch\(pitch)")
                }
                .onChange(of: selectedItem, initial: true) {
                    guard selectedItem != nil else {
                        withAnimation(.easeInOut) {
                            isRecordCardShown = false
                        }
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

//                RecordCarousel()
//                    .offset(y: -35)
//                    .frame(maxHeight: .infinity, alignment: .bottom)
//                    .frame(width: 600, alignment: .center)
//                    .clipped()
        
            //}//
            
        }
//        .ornament(attachmentAnchor: .scene(.bottomLeading)) {

//        }
        
        .overlay(alignment: .bottomLeading) {
            if let recordId = selectedItem {
                if let record = selectModel.records.first(where: { $0.id == recordId }) {
                    RecordCard(record: record)
                    //.frame(width: 400, height: 280,  alignment: .leading)
                        .frame(width: 1200)
                        .opacity(isRecordCardShown ? 1 : 0)
                        .offset(z: 360.0)
                        .offset(x: -300, y: -20)
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Toggle("Show Globe", isOn: $isGlobeShown)
                .toggleStyle(.button)
                .padding(10)
        }
        .overlay(alignment: .bottomTrailing) {
//            ItemView(item: .)
//                .opacity(isGlobeShown ? 1 : 0)
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .dragRotation(
                    yaw: $yaw,
                    pitch: $pitch)
        }
//        .onChange(of: yaw, initial: false) {
//            guard let lat = viewModel.cameraPosition.region?.center.latitude,
//                  let lon = viewModel.cameraPosition.region?.center.longitude else { return }
//            
//            let newLat = pitch * 180.0 / .pi
//            let newLon = yaw * 180.0 / .pi
//            
//            let latDiff = abs(newLat - lat)
//            let lonDiff = abs(newLon - lon)
//            
//            let threshold = 2.0
//            
//            if (latDiff > threshold) && (lonDiff > threshold) {
//                viewModel.changeLocation(coord: CLLocationCoordinate2D(latitude: newLat, longitude: newLon))
//            }
//        }
//        .onChange(of: pitch, initial: false) {
//            guard let lat = viewModel.cameraPosition.region?.center.latitude,
//                  let lon = viewModel.cameraPosition.region?.center.longitude else { return }
//                  
//            let newLat = pitch * 180.0 / .pi
//            let newLon = yaw * 180.0 / .pi
//            
//            let latDiff = abs(newLat - lat)
//            let lonDiff = abs(newLon - lon)
//            
//            let threshold = 2.0
//            
//            if (latDiff > threshold) && (lonDiff > threshold) {
//                viewModel.changeLocation(coord: CLLocationCoordinate2D(latitude: newLat, longitude: newLon))
//            }
//        }
    }
}

private struct ItemView: View {
    var item: Item
    var orientation: SIMD3<Double> = .zero
    
    private let modelDepth: Double = 200

    var body: some View {
        Model3D(named: item.name, bundle: realityKitContentBundle) { model in
            model.resizable()
                .scaledToFit()
                .rotation3DEffect(
                    Rotation3D(
                        eulerAngles: .init(angles: orientation, order: .xyz)
                    )
                )
                .frame(depth: modelDepth)
                .offset(z: -modelDepth / 2)
                .accessibilitySortPriority(1)
        } placeholder: {
            ProgressView()
                .offset(z: -modelDepth * 0.75)
        }
        //.dragRotation(yaw: $yaw, pitch: $pitch)
        .offset(z: modelDepth)
    }
}

private enum Item: String, CaseIterable, Identifiable {
    case globe
    var id: Self { self }
    var name: String { rawValue.capitalized }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//            .environmentObject(MapViewModel())
//            .environmentObject(RecordSelectModel())
//    }
//}

