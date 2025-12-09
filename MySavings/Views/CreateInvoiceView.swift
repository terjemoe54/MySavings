//
//  CreateInvoiceView.swift
//  Invoice_ One-Many
//
//  Created by Terje Moe on 04/12/2025.

import SwiftUI
import SwiftData

struct CreateInvoiceView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query private var invoices: [Invoice]
    @Query private var customers: [Customer]
    
    @State private var invoice = Invoice()
    @State private var selectedCustomer: Customer?
    @State private var title = ""
    @State private var amount: Double = 0.0
    @State private var dueDate = Date()
    @State private var isPaid: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Faktura For:"){
                    TextField("Navn", text: $title)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.sentences)
                }
                
                Section("Detaljer"){
                    HStack{
                        Text("Beløp:")
                        TextField("Beløp", value: $amount, formatter: numberFormatter)
                            .keyboardType(.decimalPad)
                    }
                    
                    DatePicker("Forfalls Dato", selection: $dueDate, displayedComponents: .date)
                    Toggle("Betalt:", isOn: $isPaid)
                }
                
                Section("Velg en Kunde") {
                    Picker("", selection: $selectedCustomer){
                        ForEach(customers.sorted { $0.title < $1.title }) { customer in
                            Text(customer.title)
                                .tag(customer as Customer?)
                        }
                        .labelsHidden()
                        .pickerStyle(.inline)
                        Text("Ingen")
                            .tag(nil as Customer?)
                    }
                }
                
                Section {
                    Button("Opprett"){
                        save()
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .navigationTitle("Opprett Faktura")
            .toolbar {
                ToolbarItem(placement: .cancellationAction){
                    Button("Avslutt"){
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CreateInvoiceView()
        .modelContainer(for: Invoice.self)
}

extension CreateInvoiceView {
    
    
    func save() {
        // Lagrer verdiene til databasen og oppdaterer relasjon
        invoice.title = title
        invoice.amount = amount
        invoice.dueDate = dueDate
        invoice.isPaid = isPaid
        
        modelContext.insert(invoice)
        invoice.customer = selectedCustomer
        selectedCustomer?.invoices?.append(invoice)
    }
}
