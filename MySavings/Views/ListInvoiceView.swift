//
//  ContentView.swift
//  ToDos
//
//  Created by Tunde Adegoroye on 06/06/2023.
// bra

import SwiftUI
import SwiftData

struct ListInvoiceView: View {
    // Herfra
    @AppStorage("darkModeEnambled") private var darkModeEnabled = false
    @AppStorage("ShowName") private var showName = false
    @AppStorage("YourName") private var name: String = ""
    @AppStorage("TaxPercent") private var tax: String = ""
    @AppStorage("filterMinimum") var filterMinimum = 1.0
    @AppStorage("orderDescending") var orderDescending = false
    @AppStorage("showExpenses") var showExpenses = true
    @AppStorage("fromDate") var fromDate = Date()
    @AppStorage("toDate") var toDate = Date()
    @AppStorage("sortPaid") var sortPaid = false
    
    @State private var showingSettings = false
    @State private var showAddTransactionView = false
    @Environment(\.colorScheme) var colorScheme
    // Til Her
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Invoice.dueDate, order: .forward) private var invoices: [Invoice]
    @State private var showCreateCustomer = false
    @State private var showCreateInvoice = false
    @State private var invoiceToEdit: Invoice?
    @State private var showConfirmation: Bool = false
    @State private var invoiceToDelete: Invoice?
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(invoices) { invoice in
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Spacer()
                                    Text("Forfall : \(invoice.displayDueDate)")
                                    Spacer()
                                    Text("Betalt : \(invoice.displayPaidDate)")
                                    Spacer()
                                }
                                .font(.system(size: 14, weight: .bold))
                                .padding(.vertical, 5)
                                .background(Color.gray.opacity(0.4))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                
                                HStack{
                                    Text(invoice.title)
                                        .font(.system(size: 15,weight: .bold))
                                    Spacer()
                                    Text("\(invoice.displayAmount)")
                                        .font(.callout)
                                }
                                .padding(.horizontal, 8)
                                
                                HStack {
                                    Image(systemName: invoice.type == .income ? "arrow.up.forward" : "arrow.down.forward")
                                        .font(.system(size: 16, weight: .bold ))
                                        .foregroundStyle(invoice.type == .income ? Color.green : Color.red)
                                    
                                    HStack{
                                        if let customer = invoice.customer {
                                            Text(customer.title)
                                                .font(.system(size: 14,weight:.bold))
                                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                                                .bold()
                                                .padding(.vertical, 2)
                                                .background(Color.blue.opacity(0.2), in: RoundedRectangle(cornerRadius: 8))
                                        }
                                    }
                                    
                                    HStack{
                                        Spacer()
                                        Text("\(invoice.state.title)")
                                            .font(.system(size: 14,weight: .bold))
                                            .foregroundStyle(invoice.state.color)
                                        Spacer()
                                        
                                        Text("\(invoice.type.title)")
                                            .font(.system(size: 14,weight: .bold))
                                            .foregroundStyle(invoice.type.color)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            invoiceToEdit = invoice
                        }
                        .swipeActions {
                            
                            Button(role: .destructive) {
                                invoiceToDelete = invoice
                                showConfirmation.toggle()
                            }
                        }
                    }
                }
                FloatingButton()
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
                            try? modelContext.save()
                        }
                    } label: {
                        Text("Slett")
                    }
                    Button(role: .confirm) {
                        
                    } label: {
                        Text("Avbryt")
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
                ToolbarItem(placement: .topBarLeading) {
                    Button("Kunder \(Image(systemName: "person.2.fill"))") {
                        showCreateCustomer.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.system(size: 15, weight: .bold))
                    .padding(8)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                    showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(darkModeEnabled ? Color.white : Color.black)
                    }
                }
                
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(name: $name, tax: $tax, filterMinimum: $filterMinimum, darkModeEnabled: $darkModeEnabled, showName: $showName, orderDescending: $orderDescending, showExpenses: $showExpenses, fromDate: $fromDate, toDate: $toDate, sortPaid: $sortPaid)
               
            }
        }
        .preferredColorScheme(darkModeEnabled ? .dark : .light)
    }
  
    fileprivate func FloatingButton() -> some View {
        VStack {
            Spacer()
            NavigationLink {
                CreateInvoiceView()
            } label: {
                Text("+")
                    .font(.largeTitle)
                    .frame(width: 70, height: 70)
                    .foregroundStyle(Color.white)
            }
            .background(Color.green)
            .clipShape(Circle())
            .padding(.bottom, 7)
        }
    }
}

#Preview {
    ListInvoiceView()
        .modelContainer(for: Invoice.self, inMemory: true)
}
