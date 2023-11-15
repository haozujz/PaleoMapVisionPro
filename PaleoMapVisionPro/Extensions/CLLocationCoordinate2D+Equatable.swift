//
//  CLLocationCoordinate2D+Equatable.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 15/11/2023.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}
