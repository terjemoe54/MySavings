//
//  ContentView.swift
//  ToDos
//
//  Created by Tunde Adegoroye on 06/06/2023.
// bra

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var invoices: [Invoice]
    
    @State private var showCreateCustomer = false
    @State private var showCreateInvoice = false
    @State private var invoiceToEdit: Invoice?
    
    @State private var showConfirmation: Bool = false
    @State private var invoiceToDelete: Invoice?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(invoices) { invoice in
                    HStack {
                        VStack(alignment: .leading) {
                            
                            Text(invoice.title)
                                .font(.system(size: 15,weight: .bold))
                            
                            Text("\(invoice.dueDate, style: .date)")
                                .font(.callout)
                            HStack{
                                if let customer = invoice.customer {
                                    Text(customer.title)
                                        .foregroundStyle(Color.blue)
                                        .bold()
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                        .background(Color.blue.opacity(0.1),
                                                    in: RoundedRectangle(cornerRadius: 8,
                                                                         style: .continuous))
                                }
                                
                                if invoice.isPaid {
                                    HStack{
                                        Text("PAID")
                                            .font(.system(size: 16,weight: .bold))
                                            .foregroundStyle(.green)
                                        
                                        Image(systemName: "heart.fill")
                                            .symbolVariant(.fill)
                                            .foregroundColor(.red)
                                            .font(.system(size: 16,weight: .bold))
                                            .bold()
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                invoice.isPaid.toggle()
                            }
                        } label: {
                            
                            Image(systemName: "checkmark")
                                .symbolVariant(.circle.fill)
                                .foregroundStyle(invoice.isPaid ? .green : .gray)
                                .font(.largeTitle)
                        }
                        .buttonStyle(.plain)
                    }
                    .swipeActions {
                        
                        Button(role: .destructive) {
                            invoiceToDelete = invoice
                            showConfirmation.toggle()
                        }
                        
                        Button {
                            invoiceToEdit = invoice
                        } label: {
                            Label("Endre", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }
            }
            .confirmationDialog(
                "Slett",
                isPresented: $showConfirmation,
                titleVisibility: .visible,
                presenting: invoiceToDelete ,
                actions: { item in
                    Button(role: .destructive) {
                        withAnimation {
                            modelContext.delete(item)
                        }
                    } label: {
                        Text("Slett")
                    }
                },
                message: { item in
                    Text("Er du sikker på at du vil slette \(item.title)?")
                })
            .navigationTitle("Faktura Liste")
            .bold()
            .sheet(item: $invoiceToEdit,
                   onDismiss: {
                invoiceToEdit = nil
            },
                   content: { editInvoice in
                NavigationStack {
                    UpdateInvoiceView(invoice: editInvoice)
                        .interactiveDismissDisabled()
                }
            })
            .sheet(isPresented: $showCreateCustomer,
                   content: {
                NavigationStack {
                    CreateCustomerView()
                }
            })
            .sheet(isPresented: $showCreateInvoice,
                   content: {
                NavigationStack {
                    CreateInvoiceView()
                }
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Ny Kunde \(Image(systemName: "person.2.fill"))") {
                        showCreateCustomer.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.system(size: 15, weight: .bold))
                    .padding(8)
                }
                
                ToolbarItem(placement: .topBarLeading)   {
                    Button("Faktura \(Image(systemName: "plus"))") {
                        showCreateInvoice.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.system(size: 15, weight: .bold))
                    .padding(8)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Invoice.self, inMemory: true)
}
