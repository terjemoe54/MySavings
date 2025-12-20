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
    @Query(sort: \Customer.title, order: .forward) private var customers: [Customer]
    @Bindable var invoice: Invoice
    @State private var amount = 0.0
    @State private var title = ""
    @State private var type = TransactionType.expense
    @State private var state: TransactionState = .pending
    @State private var dueDate: Date = Date()
    @State private var paidDate: Date = Date()
    @State private var isPaid: Bool = false
    @State private var selectedType: TransactionType = .expense
    @State private var selectedState: TransactionState = .pending
    @State private var interval = 1
    @AppStorage("darkModeEnambled") private var darkModeEnabled = false
    
    var body: some View {
        
        NavigationStack {
            List {
                Section("Faktura For") {
                    TextField("Navn", text: $title)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.sentences)
                }
                
                Section {
                    
                    DatePicker("Forfallsdato",
                               selection: $dueDate, displayedComponents: .date)
                    DatePicker("Betalt dato",
                               selection: $paidDate, displayedComponents: .date)
                    HStack{
                        Text("Beløp:")
                        TextField("Beløp", value: $amount, formatter: numberFormatter)
                            .keyboardType(.decimalPad)
                    }
                    
                    // Picker for Expense / Income
                    Picker("Velg Type", selection: $selectedType) {
                        ForEach(TransactionType.allCases) { transactionType in
                            Text(transactionType.title)
                                .tag(transactionType)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 50)
                    
                    // Picker for Pending / Payed / Recieved / Taken
                    Picker("Velg Type", selection: $selectedState) {
                        ForEach(TransactionState.allCases) { transactionState in
                            Text(transactionState.title)
                                .tag(transactionState)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    HStack{
                        Text("Intervall i måneder:")
                        TextField("Intervall", value: $interval,formatter: intFormatter)
                            .keyboardType(.decimalPad)
                    }
                    
                    Picker("Velg en Kunde", selection: $invoice.customer){
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
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction){
                    Button("Avbryt") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button("Oppdater") {
                        updateInvoice()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonStyle(.borderedProminent)
                    .disabled(changed)
                    //.disabled(title.isEmpty)
                }
            }
            .preferredColorScheme(darkModeEnabled ? .dark : .light)
            .onAppear() {
                // Laster inn verdier til variablene fra databasen når vi åpner listen
                
                selectedType = invoice.type
                selectedState = invoice.state
                
                self.title = invoice.title
                self.type = invoice.type
                self.state = invoice.state
                self.amount = invoice.amount
                self.dueDate = invoice.dueDate
                self.paidDate = invoice.paidDate
                self.isPaid = invoice.isPaid
                self.interval = invoice.interval
            }
            .navigationTitle("Oppdater Faktura")
        }
        
    }
    func updateInvoice() {
        // setter verdiene fra variablene til databasen
        invoice.title = title
        invoice.type = selectedType
        invoice.state = selectedState
        invoice.amount = amount
        invoice.dueDate = dueDate
        invoice.paidDate = paidDate
        invoice.isPaid = isPaid
        invoice.interval = interval
    }
    
    var changed: Bool {
        invoice.type.title == selectedType.title
     && invoice.state.title == selectedState.title

     && invoice.title == title
     && invoice.amount == amount
     && invoice.dueDate == dueDate
     && invoice.paidDate == paidDate

     && invoice.interval == interval
     && !invoice.customer!.hasChanges
   }
}

//#Preview {
//    UpdateInvoiceView(invoice: Invoice())
//        .modelContainer(for: Invoice.self)
//}
