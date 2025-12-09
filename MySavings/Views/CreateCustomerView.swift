//
//  ContentView.swift
//  Invoice_ One-Many
//
//  Created by Terje Moe on 03/12/2025.
//

import SwiftUI
import SwiftData

struct CreateCustomerView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Customer.title, order: .forward) private var customers: [Customer]
    @State private var title: String = ""
    @State private var customerToEdit: Customer?
    var body: some View {
        NavigationView {
            List {
                Section("Kunde: ") {
                    TextField("Kunde Navn", text: $title)
                    Button("Opprett Kunde") {
                        withAnimation{
                            let customer = Customer(title: title)
                            modelContext.insert(customer)
                            customer.invoices = []
                            title = ""
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(title.isEmpty)
                }
                
                Section("Kunder") {
                    ForEach(customers) { customer in
                        Text(customer.title)
                            .swipeActions {
                                Button(role: .destructive){
                                    withAnimation {
                                        modelContext.delete(customer)
                                    }
                                } label: {
                                    Label("Slett" , systemImage: "trash.fill")
                                }
                                
                                Button {
                                    customerToEdit = customer
                                } label: {
                                    Label("Endre", systemImage: "pencil")
                                }
                                .tint(.orange)
                                
                            }
                            .onTapGesture {
                                customerToEdit = customer
                            }
                    }
                    
                }
            }
            .navigationTitle("Opprett Kunde")
            .sheet(item: $customerToEdit,
                   onDismiss: {
                customerToEdit = nil
            },
                   content: { editCustomer in
                NavigationStack {
                    UpdateCustomerView(customer: editCustomer)
                }
                .interactiveDismissDisabled()
            })
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Avslutt") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CreateCustomerView()
}
