//
//  FilterView.swift
//  Paleo
//
//  Created by Joseph Zhu on 16/7/2022.
//

import SwiftUI
import MapKit

struct FilterView: View {
    @Environment(MapViewModel.self) private var viewModel
    @Environment(ModelData.self) private var modelData
    @Environment(RecordSelectModel.self) private var selectModel
    
    @State var isOn: Bool = false
    
    var body: some View {
        @Bindable var modelData = modelData
        
        VStack {
            Text("Filter")
                .font(.system(size: 32, weight: .heavy))
                .frame(width: 320, height: 50, alignment: .leading)
                .offset(x: -10, y: -20)
            
            ZStack {
//                GridStack(rows: 6, cols: 2, rowSpacing: -100, colSpacing: -120) { row, col in
//                    let phylum: Phylum = Phylum.allCases[row * 2 + col]
//                    PhylumToggle(isActive: Binding(
//                        get: { modelData.filterDict[phylum] ?? true },
//                        set: { modelData.filterDict[phylum] = $0 })
//                        , phylum: phylum)
//                }
//                .frame(width: 390, height: 600)
                Grid(horizontalSpacing: 10.0, verticalSpacing: 10.0) {
                    ForEach(Phylum.allCases, id: \.self) { phylum in
                        PhylumToggle(isActive: Binding(
                            get: { modelData.filterDict[phylum] ?? true },
                            set: { modelData.filterDict[phylum] = $0 })
                            , phylum: phylum)
                    }
                }
                Toggle("Show Globe", isOn: $isOn)
                    .toggleStyle(.button)
                    .padding(18)
                
                
            }
            .offset(y: 0)
        }
//        .onDisappear {
//            guard let recordsNearby = selectModel.recordsNearby else {return}
//            
//            guard let r = viewModel.cameraPosition.region else {return}
//            
//            if recordsNearby.count == 0 {
//                selectModel.updateRecordsSelection(coord: r.center, db: modelData.db, recordsTable: modelData.recordsTable, boxesTable: modelData.boxesTable, filter: modelData.filterDict, isIgnoreThreshold: true)
//            } else if let _ = recordsNearby.first(where: {!(modelData.filterDict[$0.phylum] ?? true)}) {
//                selectModel.updateRecordsSelection(coord: r.center, db: modelData.db, recordsTable: modelData.recordsTable, boxesTable: modelData.boxesTable, filter: modelData.filterDict, isIgnoreThreshold: true)
//            } else {
//                selectModel.freezeRecordsNearbyThenUpdate(coord: r.center, db: modelData.db, recordsTable: modelData.recordsTable, boxesTable: modelData.boxesTable, filter: modelData.filterDict, isIgnoreThreshold: true)
//            }
//        }
//        .onDisappear { [weak modelData, weak viewModel, weak selectModel] in
//            guard let modelData = modelData, let viewModel = viewModel, let selectModel = selectModel else {return}
//            
//            if modelData.filterDict == filterDict {return}
//            guard let recordsNearby = selectModel.recordsNearby else {return}
//
//            modelData.filterDict = filterDict
//
//            guard let r = viewModel.cameraPosition.region else {return}
//            
//            if recordsNearby.count == 0 {
//                selectModel.updateRecordsSelection(coord: r.center, db: modelData.db, recordsTable: modelData.recordsTable, boxesTable: modelData.boxesTable, filter: modelData.filterDict, isIgnoreThreshold: true)
//            } else if let _ = recordsNearby.first(where: {!(modelData.filterDict[$0.phylum] ?? true)}) {
//                selectModel.updateRecordsSelection(coord: r.center, db: modelData.db, recordsTable: modelData.recordsTable, boxesTable: modelData.boxesTable, filter: modelData.filterDict, isIgnoreThreshold: true)
//            } else {
//                selectModel.freezeRecordsNearbyThenUpdate(coord: r.center, db: modelData.db, recordsTable: modelData.recordsTable, boxesTable: modelData.boxesTable, filter: modelData.filterDict, isIgnoreThreshold: true)
//            }
//        }
        
    }
}

//struct FilterView_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterView()
//            .background(Color(red:0.05, green:0.05, blue:0.05))
//            .preferredColorScheme(.dark)
//        
//        FilterView()
//            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (5th generation)"))
//            .background(Color(red:0.05, green:0.05, blue:0.05))
//            .preferredColorScheme(.dark)
//    }
//}
