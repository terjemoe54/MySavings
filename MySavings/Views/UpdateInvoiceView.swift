//
//  UpdateToDoView.swift
//  ToDos
//
//  Created by Tunde Adegoroye on 08/06/2023.
//

import SwiftUI
import SwiftData

struct UpdateInvoiceView: View {
    @Environment(\.dismiss) var dismiss
    @State var selectedCustomer: Customer?
    @Query private var customers: [Customer]
    @Bindable var invoice: Invoice
    @State private var amount = 0.0
    @State private var title = ""
    @State private var dueDate: Date = Date()
    @State private var isPaid: Bool = false
    
    var body: some View {
        List {
            Section("Faktura For") {
                TextField("Navn", text: $title)
            }
            HStack{
                Text("Beløp:")
                TextField("Beløp", value: $amount, formatter: numberFormatter)
                    .keyboardType(.decimalPad)
            }
            
            Section {
                DatePicker("Forfallsdato",
                           selection: $dueDate, displayedComponents: .date)
                Toggle("Betalt ?", isOn: $isPaid)
            }
            
            Section("Velg en Kunde") {
                Picker("", selection: $invoice.customer){
                    ForEach(customers) { customer in
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
                Button("Oppdater") {
                    updateInvoice()
                    dismiss()
                }
            }
        }
        .onAppear() {
            // Laster inn verdier til variablene fra databasen når vi åpner listen
            self.title = invoice.title
            self.amount = invoice.amount
            self.dueDate = invoice.dueDate
            self.isPaid = invoice.isPaid
        }
        .navigationTitle("Oppdater Faktura")
    }
}

#Preview {
    UpdateInvoiceView(invoice: Invoice())
        .modelContainer(for: Invoice.self)
}

extension UpdateInvoiceView {
    
    
    func updateInvoice() {
        // setter verdiene fra variablene til databasen
        invoice.title = title
        invoice.amount = amount
        invoice.dueDate = dueDate
        invoice.isPaid = isPaid
        
    }
}
