//
//  Models.swift
//  Invoice_ One-Many
//
//  Created by Terje Moe on 03/12/2025.
//
// Endret Category to Customer
// Endret Item to Invoice


import Foundation
import SwiftData

@Model
class Customer {
    @Attribute(.unique)
    var title: String
    @Relationship(deleteRule: .cascade, inverse: \Invoice.customer)
    var invoices: [Invoice]?
    
    init(title: String ) {
        self.title = title
    }
}

@Model
class Invoice {
    var title: String
    var dueDate: Date
    var paidDate: Date
    var amount: Double
    var isPaid: Bool
    var customer: Customer?
    
    init(
        title: String = "",
        dueDate: Date = .now,
        paidDate: Date = .now,
        amount: Double = 0.0,
        isPaid: Bool = false
    ) {
        self.title = title
        self.dueDate = dueDate
        self.paidDate = paidDate
        self.amount = amount
        self.isPaid = isPaid
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
