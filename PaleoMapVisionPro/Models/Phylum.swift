//
//  Phylum.swift
//  Paleo
//
//  Created by Joseph Zhu on 16/7/2022.
//

import Foundation
import SwiftUI

enum Phylum: String, Codable, CaseIterable {
    case annelida = "annelida"
    case archaeocyatha = "archaeocyatha"
    case arthropoda = "arthropoda"
    
    case brachiopoda = "brachiopoda"
    case bryozoa = "bryozoa"
    case chordata = "chordata"
    
    case cnidaria = "cnidaria"
    case coelenterata = "coelenterata"
    case echinodermata = "echinodermata"
    
    case mollusca = "mollusca"
    case platyhelminthes = "platyhelminthes"
    case porifera = "porifera"
    
    var icon: String {
        switch self {
        case .annelida: return "hurricane"
        case .archaeocyatha: return "aqi.medium"
        case .arthropoda: return "ant.fill"
        case .brachiopoda:
            if #available(iOS 16.0, *) { return "fossil.shell.fill" }
            else { return "seal.fill" }
        case .bryozoa: return "aqi.medium"
        case .chordata: return "hare.fill"
        case .cnidaria: return "snowflake"
        case .coelenterata: return "aqi.medium"
        case .echinodermata: return "staroflife.fill"
        case .mollusca:
            if #available(iOS 16.0, *) { return "fossil.shell.fill" }
            else { return "seal.fill" }
        case .platyhelminthes: return "hurricane"
        case .porifera: return "aqi.medium"
        }
    }
    
    var colors: [Color] {
        switch self {
        case .annelida: return [.brown]
        case .archaeocyatha: return [.blue]
        case .arthropoda: return [.purple]
        case .brachiopoda: return [.orange]
        case .bryozoa: return [.blue]
        case .chordata: return [.yellow, .cyan, .cyan, .green, .green, .indigo, .indigo, .yellow]
        case .cnidaria: return [.pink]
        case .coelenterata: return [.blue]
        case .echinodermata: return [.red]
        case .mollusca: return [.orange]
        case .platyhelminthes: return [.brown]
        case .porifera: return [.blue]
        }
    }
}
