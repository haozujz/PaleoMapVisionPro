//
//  SearchModel.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 19/11/2023.
//

import Foundation
import SwiftUI
import SQLite

@Observable
final class SearchModel {
    var searchText: String = ""
    var isSearching: Bool = false
    var lastSubmittedText: String = ""
    var lastCompletedSearch: String = ""
    var isSearchBarFocused: Bool = false

    enum AbortEvent: Equatable { case cancel, search }
    private var abortKey: Int = 0
    var results: [Record] = []
    
    private var trie: Trie?
    private var timer: Timer?
    var suggestions: [String] = []
    
    func loadTrie() {
        let newTrie = Trie()
        loadTrieFromBundle(trie: newTrie, fileName: "trieData")
        trie = newTrie
    }
    
    func updateSuggestions() {
        guard !isSearching else { return }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.12, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            Task { @MainActor in
                if self.searchText.count > 1 {
                    guard let trie = self.trie else { return }
                    var x = trie.collectWords(startingWith: self.searchText)
                    x.sort { $0 < $1 }
                    
                    guard !self.isSearching else { return }
                    self.suggestions = x
                } else {
                    guard !self.isSearching else { return }
                    self.suggestions = []
                }
            }
        }
    }
    
    func search(db: Connection, recordsTable: SQLite.Table, suggestion: String? = nil) {
        logSearchEvent()
        isSearching = true
        
        if let suggestion = suggestion {
            searchText = suggestion
        }
        
        lastSubmittedText = searchText.capitalized
        let submittedText: String = searchText.lowercased()
        let savedAbortKey: Int = abortKey
        
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: DispatchTime.now(), execute: { [weak self] in
            guard let self = self else { return }
            
            let id = Expression<String>("id")
            let sName = Expression<String?>("sName")
            let cName = Expression<String?>("cName")
            let phylum = Expression<String>("phylum")
            let classT = Expression<String?>("classT")
            let orderT = Expression<String?>("orderT")
            let family = Expression<String?>("family")
            let date = Expression<String?>("date")
            let locality = Expression<String?>("locality")
            let lat = Expression<Double>("lat")
            let lon = Expression<Double>("lon")
            let mediaS = Expression<String>("media")
            
            var x: [Record] = []
            
            do {
                let query = recordsTable.filter(phylum == submittedText || classT == submittedText || orderT == submittedText || family == submittedText || sName == submittedText || cName == submittedText)
                
                for record in try db.prepare(query) {
                    if savedAbortKey != self.abortKey { break }
                    let phy: Phylum = Phylum(rawValue: record[phylum]) ?? .chordata
                    let geo: GeoPoint = GeoPoint(lat: record[lat], lon: record[lon])
                    let med: [String] = record[mediaS].components(separatedBy: "|")
                    let r = Record(id: record[id], commonName: record[cName] ?? "", scientificName: record[sName] ?? "", phylum: phy, classT: record[classT] ?? "", order: record[orderT] ?? "", family: record[family] ?? "", locality: record[locality] ?? "", eventDate: record[date] ?? "", media: med, geoPoint: geo)
                    x.append(r)
                }
            } catch {
                fatalError("Failed query:\n\(error)")
            }

            if savedAbortKey == self.abortKey { x.sort {$0.family < $1.family} }
            
            DispatchQueue.main.async {
                if savedAbortKey == self.abortKey {
                    self.results = x
                    self.lastCompletedSearch = submittedText.capitalized
                    self.isSearching = false
                    
                    print("Search count: \(self.results.count)")
                }
            }
        })
    }
    
    func logSearchEvent() {
        if abortKey < 1000 { abortKey += 1 }
        else { abortKey = 0 }
    }
}
