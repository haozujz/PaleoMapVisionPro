//
//  ContentView.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 25/10/2023.
//

import SwiftUI
import RealityKit
import RealityKitContent

import MapKit

struct ContentView: View {
    @State private var currentTab: TabBarItem = .map
    enum TabBarItem {
        case map, filter, search
        
        var icon: String {
            switch self {
            case .map: return "map"
            case .filter: return "line.3.horizontal"
            case .search: return "magnifyingglass"
            }
        }
    }
    
    @Environment(ModelData.self) private var modelData
    @Environment(MapViewModel.self) private var viewModel
    @Environment(RecordSelectModel.self) private var selectModel
    @Environment(SearchModel.self) private var searchModel
    
//    @State private var showImmersiveSpace = false
//    @State private var immersiveSpaceIsShown = false
//    @Environment(\.openImmersiveSpace) var openImmersiveSpace
//    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapView()
                    .frame(width: 1280, height: 720)
                    .environment(viewModel)
                    .environment(modelData)
                    .environment(selectModel)
                    .environment(searchModel)
                
                SearchView()
                    .frame(maxHeight: .infinity, alignment: .top)
                    .frame(width: 400, height: 660)
                    .glassBackgroundEffect()
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(currentTab == .search ? 1 : 0)
                    .environment(viewModel)
                    .environment(modelData)
                    .environment(searchModel)
    
                FilterView()
                    .frame(maxHeight: .infinity, alignment: .top) 
                    .frame(width: 400, height: 660)
                    .glassBackgroundEffect()
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(currentTab == .filter ? 1 : 0)
                    .environment(modelData)
                
                TabView(selection: $currentTab) {
                        Text("0")
                            .frame(width: 0)
                            .tag(.map as TabBarItem)
                            .tabItem {
                                Image(systemName: TabBarItem.map.icon)
                                Text("Map")
                            }
        
                        Text("1")
                            .frame(width: 0)
                            .tag(.search as TabBarItem)
                            .tabItem {
                                Image(systemName: TabBarItem.search.icon)
                                Text("Search")
                            }
                    
                        Text("2")
                            .frame(width: 0)
                            .tag(.filter as TabBarItem)
                            .tabItem {
                                Image(systemName: TabBarItem.filter.icon)
                                Text("Filter")
                            }
                    

                    }
                    .frame(width: 0)
                    .allowsHitTesting(false)
            }
        }

//        VStack {
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

// Makes the underlying MapView unresponsive if opening/closing new window
//            TabView(selection: $currentTab) {
//                Text("0")
//                    .frame(width: 0)
//                    .tag(.map as TabBarItem)
//                    .tabItem {
//                        Image(systemName: TabBarItem.map.icon)
//                        Text("Map")
//                    }
//
//                Text("1")
//                    .frame(width: 0)
//                    .tag(.filter as TabBarItem)
//                    .tabItem {
//                        Image(systemName: TabBarItem.filter.icon)
//                        Text("Filter")
//                    }
//
//            }
//            .frame(width: 0)
//            .allowsHitTesting(false)
