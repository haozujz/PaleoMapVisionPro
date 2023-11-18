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
    
    //@StateObject var modelData = ModelData()
    @Environment(ModelData.self) private var modelData
    
    //@StateObject var viewModel = MapViewModel()
    @Environment(MapViewModel.self) private var viewModel
    
    //@StateObject var selectModel = RecordSelectModel()
    @Environment(RecordSelectModel.self) private var selectModel

//    @State private var yaw: Double = 0
//    @State private var pitch: Double = 0
    
//    var isColumnVisible: NavigationSplitViewVisibility {
//        if (currentTab != .map) {
//            return .automatic
//        } else {
//            return .detailOnly
//        }
//    }
    
    var body: some View {
       
        ZStack {
            MapView()
                .frame(width: 1280, height: 720)
                .environment(viewModel)
                .environment(modelData)
                .environment(selectModel)
            
            FilterView()
                .frame(width: 300)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(currentTab == .map ? 0 : 1)
                .tag(.filter as TabBarItem)
//                .tabItem {
//                    Image(systemName: TabBarItem.filter.icon)
//                    Text("Filter")
//                }
                .environment(viewModel)
                .environment(modelData)
                .environment(selectModel)
            
            
            TabView(selection: $currentTab) {
                // Use EmptyView or a specific content based on your need
                Text("0")
                    .frame(width: 0)
                    .tag(.map as TabBarItem)
                    .tabItem {
                        Image(systemName: TabBarItem.map.icon)
                        Text("Map")
                    }


                Text("1")
                    .frame(width: 0)
                    .offset(x: 150)
                    .tag(.filter as TabBarItem)
                    .tabItem {
                        Image(systemName: TabBarItem.filter.icon)
                        Text("Filter")
                    }

            }
            .frame(width: 0)
            .allowsHitTesting(false)

            // Align the TabView to the side or bottom, so it doesn't cover the entire MapView
//            VStack {
//                Spacer() // Pushes the TabView to the bottom or side
//
//                TabView(selection: $currentTab) {
//                    // Use EmptyView or a specific content based on your need
//                    Text("O")
//                        .frame(width: 0)
//                        .tag(.map as TabBarItem)
//                        .tabItem {
//                            Image(systemName: TabBarItem.map.icon)
//                            Text("Map")
//                        }
//                    
//
//                    FilterView()
//                        .frame(width: 300)
//                        .offset(x: 150)
//                        .tag(.filter as TabBarItem)
//                        .tabItem {
//                            Image(systemName: TabBarItem.filter.icon)
//                            Text("Filter")
//                        }
//                        .environment(viewModel)
//                        .environment(modelData)
//                        .environment(selectModel)
//                    
//                }
//                .frame(width: 300)
//                //.frame(maxWidth: .infinity, alignment: .leading)
//                .border(Color.blue)
//                .allowsHitTesting(false)
//            }
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

//#Preview(windowStyle: .automatic) {
//    ContentView()
//}
