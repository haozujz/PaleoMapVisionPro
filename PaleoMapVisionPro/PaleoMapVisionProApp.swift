//
//  PaleoMapVisionProApp.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 25/10/2023.
//

import SwiftUI

@main
struct PaleoMapVisionProApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 1280, height: 720)
        }
        .windowResizability(.contentSize)

//        ImmersiveSpace(id: "ImmersiveSpace") {
//            ImmersiveView()
//        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
