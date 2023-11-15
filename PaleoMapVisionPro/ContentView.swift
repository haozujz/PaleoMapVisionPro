//
//  ContentView.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 25/10/2023.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var currentTab: TabBarItem = .map
    enum TabBarItem {
        case map, filter
        
        var icon: String {
            switch self {
            case .map: return "map"
            case .filter: return "line.3.horizontal"
            }
        }
    }
//    @State private var showImmersiveSpace = false
//    @State private var immersiveSpaceIsShown = false
//
//    @Environment(\.openImmersiveSpace) var openImmersiveSpace
//    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @StateObject var modelData = ModelData()
    
    //@StateObject var viewModel = MapViewModel()
    @Environment(MapViewModel.self) private var viewModel
    
    @StateObject var selectModel = RecordSelectModel()

//    @State private var yaw: Double = 0
//    @State private var pitch: Double = 0
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $currentTab) {
                MapView()
                    .tag(.map as TabBarItem)
                    .tabItem {
                        Image(systemName: TabBarItem.map.icon)
                        Text("Map")
                    }
                    .frame(width: 1280, height: 720)
                    //.cornerRadius(36.0)
                    .environmentObject(modelData)
                    //.environmentObject(viewModel)
                    .environment(viewModel)
                    .environmentObject(selectModel)
                
                    //.environmentObject(searchModel)

                FilterView()
                    .tag(.filter as TabBarItem)
                    .tabItem {
                        Image(systemName: TabBarItem.filter.icon)
                        Text("Filter")
                    }
                    .environmentObject(modelData)
                    //.environmentObject(viewModel)
                    .environment(viewModel)
                    .environmentObject(selectModel)
            }
        }
        
//        VStack {
//            Model3D(named: "Scene", bundle: realityKitContentBundle)
//                .dragRotation(
//                    yaw: $yaw,
//                    pitch: $pitch)
//                .padding(.bottom, 50)

//            Text("Hello, world!")
//
//            Toggle("Show Immersive Space", isOn: $showImmersiveSpace)
//                .toggleStyle(.button)
//                .padding(.top, 50)
//        }
//        .padding()
//        .onChange(of: showImmersiveSpace) { _, newValue in
//            Task {
//                if newValue {
//                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
//                    case .opened:
//                        immersiveSpaceIsShown = true
//                    case .error, .userCancelled:
//                        fallthrough
//                    @unknown default:
//                        immersiveSpaceIsShown = false
//                        showImmersiveSpace = false
//                    }
//                } else if immersiveSpaceIsShown {
//                    await dismissImmersiveSpace()
//                    immersiveSpaceIsShown = false
//                }
//            }
//        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
