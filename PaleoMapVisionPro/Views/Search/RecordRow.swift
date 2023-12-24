//
//  RecordRow.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 24/12/2023.
//

import SwiftUI

struct RecordRow: View {
    @Environment(MapViewModel.self) private var viewModel
    let record: Record
    
    var body: some View {
        HStack {
            Button(action: {
                Task { @MainActor in
                    viewModel.selectedItem = record
                }
            }) {
                HStack {
                    ImageCell(url: record.media.first!, cornerRadius: 12.0)
                        .frame(width: 60, height: 60)
                        .padding(8)
                    
                    VStack(alignment: .leading) {
                        Text(
                            (record.commonName.isEmpty
                                ? (record.family.isEmpty ? record.scientificName : record.family)
                                : record.commonName
                            ).capitalized
                        )
                        .foregroundStyle(.primary)
                        
                        Text(record.eventDate)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()

            Button(action: {
                Task { @MainActor in
                    viewModel.changeLocation(coord: record.locationCoordinate, isSpanLarge: false)
                }
            }) {
                Image(systemName: "arrow.forward.circle.fill")
                    .frame(width: 56)
                    .frame(maxHeight: .infinity)
            }
            .buttonStyle(PlainButtonStyle())
        }
            .listRowInsets(EdgeInsets())
    }
}


