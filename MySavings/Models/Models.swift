//
//  Models.swift
//  Invoice_ One-Many
//
//  Created by Terje Moe on 03/12/2025.
//
// Endret Category to Customer
// Ser Bra Ut


import Foundation
import SwiftData
import Combine

class AppModel: ObservableObject {
    @Published var klientname: String = "Guest"
}

@Model
class Customer {
   // @Attribute(.unique)
    var title: String = ""
    @Relationship(deleteRule: .cascade, inverse: \Invoice.customer)
    var invoices: [Invoice]?
    
    init(title: String ) {
        self.title = title
    }
}

@Model
class Invoice {
   // var id: UUID = UUID()
    var title: String = ""
    var type: TransactionType = TransactionType.expense
    var state: TransactionState = TransactionState.pending
    var dueDate: Date = Date()
    var paidDate: Date = Date()
    var amount: Double = 0.0
    var isPaid: Bool = false
    var interval: Int = 0
    var customer: Customer?
    
    init(
        title: String = "",
        type: TransactionType = .expense,
        state: TransactionState = .pending,
        dueDate: Date = .now,
        paidDate: Date = .now,
        amount: Double = 0.0,
        isPaid: Bool = false,
        interval: Int = 0
    ) {
        self.title = title
        self.type = type
        self.state = state
        self.dueDate = dueDate
        self.paidDate = paidDate
        self.amount = amount
        self.isPaid = isPaid
        self.interval = interval
    }
    
    @Transient
        var displayPaidDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: paidDate)
     }
    
    @Transient
        var displayDueDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: dueDate)
     }

    @Transient
        var displayAmount: String {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
          // numberFormatter.numberStyle = .currency
            numberFormatter.minimumFractionDigits = 2
            return numberFormatter.string(from: amount as NSNumber) ?? "$0.00"
        }

}
