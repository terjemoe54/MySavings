//
//  UpdateCustomerView.swift
//  Invoice_ One-Many
//
//  Created by Terje Moe on 06/12/2025.
//

import SwiftUI
import SwiftData

struct UpdateCustomerView: View {
    @Environment(\.dismiss) var dismiss
    @State var selectedCustomer: Customer?
    @Query(sort: \Customer.title, order: .forward) private var customers: [Customer]
    @Bindable var customer: Customer
    @State private var title = ""
    
    var body: some View {
        List {
            Section("Kunde") {
                TextField("Navn", text: $title)
            }
            
            Section {
                Button("Oppdater") {
                    customer.title = title
                    dismiss()
                }
            }
        }
        .onAppear() {
            // Laster inn verdier til variablene fra databasen når vi åpner listen
            self.title = customer.title
        }
        .navigationTitle("Oppdater Kunde")
    }
}

