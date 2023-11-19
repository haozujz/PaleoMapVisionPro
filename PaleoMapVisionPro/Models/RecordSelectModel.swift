//
//  RecordSelectModel.swift
//  Paleo
//
//  Created by Joseph Zhu on 10/6/2022.
//

import Foundation
import MapKit
import SQLite
import Observation

@Observable
final class RecordSelectModel: ObservableObject {
    var records: [Record] = []
    var recordsNearby: [Record]? = nil
    var savedCoord = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    private let maxRecordsCount: Int = 20
    private var timer: Timer?
    private var isRecordsNearbyFrozen: Bool = false
    private let threshold: CGFloat = 0.008
    
    func updateRecordsSelection(coord: CLLocationCoordinate2D, db: Connection, recordsTable: Table, boxesTable: Table, filter: [Phylum : Bool], isIgnoreThreshold: Bool = false) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { [weak self] _ in
            guard let self = self else {return}
            
            DispatchQueue.global(qos: .userInteractive).async {
                if !isIgnoreThreshold && !self.isRecordsNearbyFrozen && (self.manhattanDistance(loc1: self.savedCoord, loc2: coord)) < self.threshold {
                    return
                }
                let x = self.roundLat(lat: coord.latitude)
                let y = self.roundLon(lon: coord.longitude)
                let gridIndex: Int = Int(x * 3600 + y)
                
                DispatchQueue.main.async {
                    self.records = self.getRecordsFromDbPerBox(centerIndex: gridIndex, db: db, recordsTable: recordsTable, boxesTable: boxesTable, filter: filter, coord: coord)
                }
                self.savedCoord = coord
                
                if self.isRecordsNearbyFrozen {
                    self.isRecordsNearbyFrozen = false
                } else {
                    DispatchQueue.main.async {
                        self.updateRecordsNearby()
                    }
                }
            }
        }
    }
    
    func freezeRecordsNearbyThenUpdate(coord: CLLocationCoordinate2D, db: Connection, recordsTable: Table, boxesTable: Table, filter: [Phylum : Bool], isIgnoreThreshold: Bool = false) {
        isRecordsNearbyFrozen = true
        updateRecordsSelection(coord: coord, db: db, recordsTable: recordsTable, boxesTable: boxesTable, filter: filter, isIgnoreThreshold: isIgnoreThreshold)
    }
    
    func roundLat(lat: Double) -> Double {
        if lat == -90 {
            return 0
        }
        else {
            var x = ceil(lat * 10)
            x += 899
            return x
        }
    }

    func roundLon(lon: Double) -> Double {
        var x = ceil(lon * 10)
        if x <= 0 {
            x += 3599
        }
        else {
            x += -1
        }
        return x
    }

    func manhattanDistance(loc1: CLLocationCoordinate2D, loc2: CLLocationCoordinate2D) -> Double {
        let xD = abs(loc1.latitude - loc2.latitude)
        let yD = abs(loc1.longitude - loc2.longitude)
        return xD + yD
    }
    
    func generateSquareModifiers(for level: Int) -> [Int] {
        guard level > 0 else { return [] }
        
        var modifiers: [Int] = []
        
        // Top and Bottom Rows
        for i in -level...level {
            modifiers.append(-3600 * level + i) // Top row
            modifiers.append(3600 * level + i)  // Bottom row
        }

        // Left and Right Columns (excluding corners already added)
        for i in stride(from: -level + 1, through: level - 1, by: 1) {
            modifiers.append(i * 3600 - level) // Left column
            modifiers.append(i * 3600 + level) // Right column
        }

        return modifiers
    }

    func getRecordsFromDbPerBox(centerIndex: Int, db: Connection, recordsTable: Table, boxesTable: Table, filter: [Phylum : Bool], coord: CLLocationCoordinate2D) -> [Record] {
        let i = centerIndex
//        let modifier: Array = [1,-1,-3600,-3601,-3599,3600,3599,3601]
//        let modifier2: Array = [2,-2, -7200,-7201,-7202,-7199,-7198, 7200,7199,7198,7201,7202, -3602,-3598, 3598,3602]
//        let modifier3: Array = [3, -3, -10800,-10801,-10802,-10803,-10799,-10798,-10797, 10800,10799,10798,10797,10801,10802,10803, -7203,-7197, -3603,-3597, 3597,3603, 7197,7203]
        
        let modifier = generateSquareModifiers(for: 1)
        let modifier2 = generateSquareModifiers(for: 2)
        let modifier3 = generateSquareModifiers(for: 3)
        let modifier4 = generateSquareModifiers(for: 4)
        let modifier5 = generateSquareModifiers(for: 5)
        
        var targets: [Int] = []
        var targets2: [Int] = []
        var targets3: [Int] = []
        var targets4: [Int] = []
        var targets5: [Int] = []
        
        var x: [Record] = []
        var x2: [Record] = []
        var x3: [Record] = []
        var x4: [Record] = []
        var x5: [Record] = []
        
        for m in modifier {
            let target = i+m
            if target < 0 || target > 6479999 {continue}
            targets.append(target)
        }
        x += queryDbPerBox(indexes: targets + [i], db: db, recordsTable: recordsTable, boxesTable: boxesTable)
        x = filterArray(array: x, filter: filter)
        
        if x.count < maxRecordsCount {
            for m in modifier2 {
                let target = i+m
                if target < 0 || target > 6479999 {continue}
                targets2.append(target)
            }
            x2 += queryDbPerBox(indexes: targets2, db: db, recordsTable: recordsTable, boxesTable: boxesTable)
            x2 = filterArray(array: x2, filter: filter)
            x.insert(contentsOf: x2, at: 0)
        }
        
        if x.count < maxRecordsCount {
            for m in modifier3 {
                let target = i+m
                if target < 0 || target > 6479999 {continue}
                targets3.append(target)
            }
            x3 += queryDbPerBox(indexes: targets3, db: db, recordsTable: recordsTable, boxesTable: boxesTable)
            x3 = filterArray(array: x3, filter: filter)
            x.insert(contentsOf: x3, at: 0)
        }
        
        if x.count < maxRecordsCount {
            for m in modifier4 {
                let target = i+m
                if target < 0 || target > 6479999 {continue}
                targets4.append(target)
            }
            x4 += queryDbPerBox(indexes: targets4, db: db, recordsTable: recordsTable, boxesTable: boxesTable)
            x4 = filterArray(array: x4, filter: filter)
            x.insert(contentsOf: x4, at: 0)
        }
        
        if x.count < maxRecordsCount {
            for m in modifier5 {
                let target = i + m
                if target < 0 || target > 6479999 { continue }
                targets5.append(target)
            }
            x5 += queryDbPerBox(indexes: targets5, db: db, recordsTable: recordsTable, boxesTable: boxesTable)
            x5 = filterArray(array: x5, filter: filter)
            x.insert(contentsOf: x5, at: 0)
        }
        
        x.sort {manhattanDistance(loc1: $0.locationCoordinate, loc2: coord) > manhattanDistance(loc1: $1.locationCoordinate, loc2: coord)}
        return Array(x.suffix(maxRecordsCount))
    }
    
    func updateRecordsNearby() {
        recordsNearby = Array(records.shuffled().prefix(5))
    }
    
    func updateSingleRecord(recordId: String, coord: CLLocationCoordinate2D, db: Connection, recordsTable: Table, isLikelyAnnotatedAlready: Bool) {
        if isLikelyAnnotatedAlready {
            if let record = records.first(where: {$0.id == recordId}) {
                recordsNearby = [record]
                return
            }
        }

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
        
        do {
            let query = recordsTable.filter(id == recordId).limit(1)
            
            for record in try db.prepare(query) {
//                let phy: Phylum = Phylum(rawValue: record[phylum]) ?? .chordata
//                let geo: GeoPoint = GeoPoint(lat: record[lat], lon: record[lon])
//                let med: [String] = record[mediaS].components(separatedBy: "|")
//                recordsNearby = [Record(id: record[id], commonName: record[cName] ?? "", scientificName: record[sName] ?? "", phylum: phy, classT: record[classT] ?? "", order: record[orderT] ?? "", family: record[family] ?? "", locality: record[locality] ?? "", eventDate: record[date] ?? "", media: med, geoPoint: geo)]
            }
        } catch {
            fatalError("Failed query:\n\(error)")
        }
    }
    
    func queryDbPerBox(indexes: [Int], db: Connection, recordsTable: Table, boxesTable: Table) -> [Record] {
        let idx = Expression<Int>("idx")
        let recordIds = Expression<String?>("recordIds")
        
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
        
        var idArray: [String] = []
        var x: [Record] = []
        
        do {
            let queryB = boxesTable.select(recordIds).filter(indexes.contains(idx))
            
            for box in try db.prepare(queryB) {
                idArray += box[recordIds]?.components(separatedBy: "|") ?? []
            }
            
            let queryR = recordsTable.filter((idArray).contains(id))
            
            for record in try db.prepare(queryR) {
                let phy: Phylum = Phylum(rawValue: record[phylum]) ?? .chordata
                let geo: GeoPoint = GeoPoint(lat: record[lat], lon: record[lon])
                let med: [String] = record[mediaS].components(separatedBy: "|")
                let r = Record(id: record[id], commonName: record[cName] ?? "", scientificName: record[sName] ?? "", phylum: phy, classT: record[classT] ?? "", order: record[orderT] ?? "", family: record[family] ?? "", locality: record[locality] ?? "", eventDate: record[date] ?? "", media: med, geoPoint: geo)
                x.append(r)
            }
        } catch {
            fatalError("Failed query:\n\(error)")
        }
        return x
    }
    
}

private func filterArray(array: [Record], filter: [Phylum : Bool]) -> [Record] {
    var x: [Record] = []
    array.forEach { record in
        if (filter[record.phylum]) ?? true {
            x.append(record)
        }
    }
    return x
}

//infix operator **
//
//func **(lhs: Double, rhs: Double) -> Double {
//    return pow(lhs, rhs)
//}
