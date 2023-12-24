//
//  FilterView.swift
//  Paleo
//
//  Created by Joseph Zhu on 16/7/2022.
//

import SwiftUI
import MapKit

struct FilterView: View {
    @Environment(ModelData.self) private var modelData
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: -60),
        GridItem(.flexible(), spacing: -60)
    ]
    
    var body: some View {
        @Bindable var modelData = modelData
        
        VStack {
            Text("Filter")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 40)
                .padding(.vertical, 20)
            
            ZStack {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(Phylum.allCases, id: \.self) { phylum in
                        PhylumToggle(isActive: Binding(
                            get: { modelData.filterDict[phylum] ?? true },
                            set: { modelData.filterDict[phylum] = $0 })
                            , phylum: phylum)
                        .scaleEffect(0.8)
                    }
                }
            }
        }
    }
}


