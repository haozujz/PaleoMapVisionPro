//
//  PaleoMapVisionProApp.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 25/10/2023.
//

import SwiftUI

@main
struct PaleoMapVisionProApp: App {
    @State private var viewModel = MapViewModel()
    @State private var modelData = ModelData()
    @State private var selectModel = RecordSelectModel()
    @State private var searchModel = SearchModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 1280, height: 720)
                .environment(viewModel)
                .environment(modelData)
                .environment(selectModel)
                .environment(searchModel)
        }
        .windowResizability(.contentSize)

//        ImmersiveSpace(id: "Globe") {
//            ImmersiveView()
//                .environment(immersiveModel)
//        }
//        .immersionStyle(selection: .constant(.mixed), in: .mixed)
//        .upperLimbVisibility(.hidden)
    }
}
