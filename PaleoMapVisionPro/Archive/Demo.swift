//
//  Demo.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 14/11/2023.
//

import SwiftUI
import MapKit

struct Demo: View {
    @Environment(MapViewModel.self) private var viewModel
    @State var position = MapCameraPosition.region(MKCoordinateRegion(
        center: MapDetails.defaultLocation,
        span: MapDetails.defaultSpan
    ))
                                                    

    var body: some View {
        //.@Bindable var viewModelB = viewModel
        
        Map(position: $position)
            .task {
                viewModel.checkIfLocationServicesIsEnabled()
            }
            .onChange(of: viewModel.cameraPosition) {
                position = viewModel.cameraPosition
            }
    }
}

#Preview {
    Demo()
}
