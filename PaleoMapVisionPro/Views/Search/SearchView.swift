//
//  SearchView.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 19/11/2023.
//

import SwiftUI

struct SearchView: View {
    @Environment(ModelData.self) private var modelData
    @Environment(MapViewModel.self) private var viewModel
    @Environment(SearchModel.self) private var searchModel

    var filteredResults: [Record] {
        searchModel.results.filter { modelData.filterDict[$0.phylum] ?? true }
    }
    
    var body: some View {
        @Bindable var searchModelB = searchModel
        
        VStack {
            if searchModel.results.isEmpty && searchModel.suggestions.isEmpty  {
                Text("Search")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 40)
                    .padding(.top, 20)
                    .padding(.bottom, -10)
                    .transition(.opacity)
            }
            
            SearchBar(text: $searchModelB.searchText, isFocused: $searchModelB.isSearchBarFocused, placeholder: "Name, Phylum, Class, Order, Family.",  onSearchButtonClicked: {
                print("Search submitted: \(searchModelB.searchText)")
                if searchModel.searchText != "" {
                    searchModel.search(db: modelData.db, recordsTable: modelData.recordsTable)
                }
            })
            .disabled(searchModel.isSearching)
            .onChange(of: searchModel.searchText) {
                searchModel.updateSuggestions()
            }
            
            if searchModel.isSearching {
                ProgressView()
                    .scaleEffect(1.2)
            } else if searchModel.isSearchBarFocused && searchModel.searchText != "" {
                if searchModel.suggestions.isEmpty && searchModel.searchText.count > 2 {
                    Text("No suggestions found.")
                } else {
                    List {
                        ForEach(searchModel.suggestions, id: \.self) { suggestion in
                            Button(action: {
                                print("Search submitted: \(suggestion)")
                                searchModel.search(db: modelData.db, recordsTable: modelData.recordsTable, suggestion: suggestion)
                                // Dismiss keyboard, else induces Attributecycle error
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                searchModel.isSearchBarFocused = false
                            }) {
                                Text("\(suggestion.capitalized) ...")
                            }
                        }
                    }
                }
            } else {
                if filteredResults.isEmpty && searchModel.lastCompletedSearch != "" {
                    Text("No matching records found.")
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
                                    //.help("\(record.locality)".capitalized)
                                }
                                    .listRowInsets(EdgeInsets())
                        }
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: searchModel.results.isEmpty && searchModel.suggestions.isEmpty)
    }
        
}


//#Preview {
//    SearchView()
//}
