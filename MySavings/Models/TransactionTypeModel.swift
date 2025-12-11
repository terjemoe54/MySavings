//
//  TransactionType.swift
//  Income
//
//  Created by Terje Moe on 08/11/2025.
//

import Foundation
import SwiftUI

enum TransactionState: String, CaseIterable, Identifiable, Codable {
    case   resieved, pending, paid, taken
    var id: Self { self }
    
    var title: String {
        switch self {
        case .paid: return "Mottatt"
        case .pending: return "Venter"
        case .resieved: return "Betalt"
        case .taken: return "Trukket"
        }
    }
    
    var color: Color {
        switch self {
        case .paid: return .blue
        case .pending: return .yellow
        case .resieved: return .green
        case .taken: return .red
        }
    }
}

enum TransactionType: String, CaseIterable, Identifiable, Codable {
    case income, expense, all
    var id: Self { self }
    
    var title: String {
        switch self {
        case .income: return "Intekt"
        case .expense: return "Utgift"
        case .all: return "Alle"
        }
    }
    
    var color: Color {
        switch self {
        case .income: return .green
        case .expense: return .red
        case .all: return .primary
        }
    }
}

var numberFormatter: NumberFormatter {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    
    return numberFormatter
}

var intFormatter: NumberFormatter {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .none
    return numberFormatter
}
