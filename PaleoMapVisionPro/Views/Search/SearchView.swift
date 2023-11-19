//
//  SearchView.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 19/11/2023.
//

import SwiftUI

//struct SearchView: View {
//    
//    
//    var body: some View {
//        
//    }
//}
//
//#Preview {
//    SearchView()
//}

struct SearchView: View {
    @Environment(ModelData.self) private var modelData
    @Environment(SearchModel.self) private var searchModel
    @Environment(MapViewModel.self) private var viewModel

    var filteredResults: [Record] {
        searchModel.results.filter { modelData.filterDict[$0.phylum] ?? true }
    }
    
    var body: some View {
        @Bindable var searchModelB = searchModel
        
        VStack {
            SearchBar(text: $searchModelB.searchText, placeholder: "Search by exact term...",  onSearchButtonClicked: {
                print("Search submitted: \(searchModelB.searchText)")
                searchModel.search(db: modelData.db, recordsTable: modelData.recordsTable)
            })
            
            if searchModel.isSearching {
                ProgressView()
                    .scaleEffect(1.2)
            } else {
                List {
                    ForEach(filteredResults) { record in
                            HStack {
                                Button(action: {
                                    Task { @MainActor in
                                        viewModel.selectedItem = record
                                    }
                                }) {
                                    HStack {
                                        ImageCell(url: record.media.first!, cornerRadius: 12.0)
                                            .frame(width: 60, height: 60)
                                        
                                        Text(
                                            (record.commonName.isEmpty
                                                ? (record.family.isEmpty ? record.scientificName : record.family)
                                                : record.commonName
                                            ).capitalized
                                        )
                                        .foregroundStyle(.primary)
                                        
//                                        Text(record.eventDate)
//                                            .foregroundStyle(.secondary)
                                        
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
                    }
                }
            }
        }
    }
        
}


//#Preview {
//    SearchView()
//}
