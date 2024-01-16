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
//        searchModel.results.filter { modelData.filterDict[$0.phylum] ?? true }
        searchModel.results
    }
    
    @State var isSearchMode: Bool = false
    
    var body: some View {
        @Bindable var searchModelB = searchModel
        
        VStack {
            if !isSearchMode {
                Text("Search")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 40)
                    .padding(.top, 20)
                    .padding(.bottom, -10)
                    .transition(.opacity)
            }
            
            HStack(spacing: 0) {
                SearchBar(text: $searchModelB.searchText, isFocused: $searchModelB.isSearchBarFocused, placeholder: "Name, Phylum, Class, Order, Family.",  onSearchButtonClicked: {
                    
                    print("Search submitted: \(searchModelB.searchText)")
                    withAnimation {
                        if searchModel.searchText != "" {
                            searchModel.search(db: modelData.db, recordsTable: modelData.recordsTable)
                        }
                    }
                    
                })
                .disabled(searchModel.isSearching)
                .onChange(of: searchModel.searchText) {
                    searchModel.updateSuggestions()
                }
                .onChange(of: searchModel.isSearchBarFocused) {
                    if searchModel.isSearchBarFocused && !isSearchMode {
                        withAnimation {
                            isSearchMode = true
                        }
                    }
                }
                
                if isSearchMode {
                    Button("Cancel") {
                        withAnimation {
                            searchModel.isSearchBarFocused = false
                            searchModel.searchText = ""
                            isSearchMode = false
                            searchModel.results = []
                            searchModel.lastCompletedSearch = ""//
                            searchModel.suggestions = []
                            
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                    .frame(width: 100, height: 24)
                    .buttonStyle(.borderless)
                    .opacity(isSearchMode ? 1 : 0)
                    .offset(x: isSearchMode ? 0 : 100)
                    .padding(.horizontal, -8)
                    .padding(.leading, -28)
                }
            }
            
            if !isSearchMode {
                VStack {
                    if modelData.bookmarked.isEmpty {
//                        Text("No bookmarks.")
//                            .padding(.top)
                        ContentUnavailableView("No Bookmarks", systemImage: "bookmark", description: Text("You don't have any bookmarked records yet!"))
                    } else {
                        Text("Bookmarks")
                            .font(.title3)
                        
                        List {
                            ForEach(modelData.bookmarked.sorted(by: { getDisplayName(record: $0) < getDisplayName(record: $1) }), id: \.self) { record in
                                RecordRow(record: record)
                                    .listRowInsets(EdgeInsets())
                            }
                        }
                    }
                    
                }
            }
            
            if isSearchMode {
                if searchModel.isSearching {
                    ProgressView()
                        .scaleEffect(1.2)
                } else if searchModel.isSearchBarFocused && searchModel.searchText != "" {
                    if searchModel.suggestions.isEmpty && searchModel.searchText.count > 1 {
//                        Text("No suggestions found.")
                        ContentUnavailableView("No Suggestions", systemImage: "magnifyingglass", description: Text("There were no suggestions for \"\(searchModel.searchText)\""))
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
                        //Text("No matching records found.")
                        ContentUnavailableView.search(text: searchModel.lastCompletedSearch)//
                    } else {
                        List {
                            ForEach(filteredResults.sorted(by: { getDisplayName(record: $0) < getDisplayName(record: $1) })) { record in
                                    RecordRow(record: record)
                                        .listRowInsets(EdgeInsets())
                            }
                        }
                    }
                }
            }
            
        }
        .animation(.easeInOut(duration: 0.3), value: searchModel.results.isEmpty && searchModel.suggestions.isEmpty)
    }
        
}


//#Preview {
//    SearchView()
//}

