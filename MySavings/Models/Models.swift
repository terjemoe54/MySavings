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
    var amount: Double
    var isPaid: Bool
    var customer: Customer?
    
    init(
        title: String = "",
        dueDate: Date = .now,
        amount: Double = 0.0,
        isPaid: Bool = false
    ) {
        self.title = title
        self.dueDate = dueDate
        self.amount = amount
        self.isPaid = isPaid
    }
    
    //
    //    @Transient
    //    var displayRegDate: String {
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateStyle = .medium
    //        return dateFormatter.string(from: regDate)
    //    }
    @Transient
    var displayExpDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: dueDate)
    }
    @Transient
    var displayAmount: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: amount as NSNumber) ?? "$0.00"
    }
    
    
}
