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
    @Query private var customers: [Customer]
    @Bindable var customer: Customer
    
    var body: some View {
        List {
            Section("Kunde") {
                TextField("Navn", text: $customer.title)
            }
            
            Section {
                Button("Oppdater") {
                    dismiss()
                }
            }
        }
        .navigationTitle("Oppdater Kunde")
    }
}

