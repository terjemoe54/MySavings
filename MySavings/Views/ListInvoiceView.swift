//
//  ContentView.swift
//  ToDos
//  dette er for nå
//  Created by Tunde Adegoroye on 06/06/2023.
// bra

import SwiftUI
import SwiftData

struct ListInvoiceView: View {
    @AppStorage("darkModeEnambled") private var darkModeEnabled = false
    @AppStorage("filterMinimum") var filterMinimum = 1.0
    @AppStorage("orderDescending") var orderDescending = false
    @AppStorage("showUnpaid") var showUnpaid = true
    @AppStorage("showExpenses") var showExpenses = true
    @AppStorage("fromDate") var fromDate = Date()
    @AppStorage("toDate") var toDate = Date()
    @AppStorage("sortPaid") var sortPaid = false
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @Query var transactions: [Invoice]
    @Query(sort: \Invoice.dueDate, order: .forward) private var invoices: [Invoice]
    @State private var showFilters = false
    @State private var showAddTransactionView = false
    @State private var showCreateCustomer = false
    @State private var showCreateInvoice = false
    @State private var invoiceToEdit: Invoice?
    @State private var showConfirmation: Bool = false
    @State private var invoiceToDelete: Invoice?
    @State private var showFilteredCustomer: Bool = false
    let calendar = Calendar.current
    @State private var selectedCustomer: Customer?
    @Query private var customers: [Customer]
    
    var body: some View {
        
        NavigationStack {
            Section {
                Text("Sum : \(total)")
                    .font(.system(size: 16,weight: .black))
                    .background(.blue)
                    .opacity(0.4)
                    .clipShape(.capsule)
                    
                Toggle(isOn: $showFilteredCustomer) {
                    Text("Filter")
                }
                Picker("Velg en Klient", selection: $selectedCustomer){
                    ForEach(customers.sorted { $0.title < $1.title }) { customer in
                        Text(customer.title)
                            .tag(customer as Customer?)
                    }
                    .labelsHidden()
                    .pickerStyle(.inline)
                    Text("Klienter")
                        .tag(nil as Customer?)
                }.disabled(!showFilteredCustomer)
            
            }.frame(width: 200,height: 20,  alignment: .center)
         
            ZStack {
                List {
                    ForEach(displayTransactions) { invoice in
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
                                        .font(.system(size: 15,weight: .bold))
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
                    Button("Tilbake \(Image(systemName: "arrowshape.turn.up.backward.2.fill"))") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.system(size: 15, weight: .bold))
                    .padding(8)
                }
            }

            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFilters = true
                    } label: {
                        HStack {
                            Text("Filtere")
                            Image(systemName: "engine.emission.and.filter")
                                .foregroundStyle(darkModeEnabled ? Color.white : Color.black)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .sheet(isPresented: $showFilters) {
                FiltersView(filterMinimum: $filterMinimum, orderDescending: $orderDescending,showUnpaid: $showUnpaid, showExpenses: $showExpenses, fromDate: $fromDate, toDate: $toDate, sortPaid: $sortPaid)
            }
        }
        .preferredColorScheme(darkModeEnabled ? .dark : .light)
    }
    
  private var total: String {
        let sumExpenses = displayTransactions
            .filter { $0.type == .expense && $0.amount >= filterMinimum }
            .reduce(0, { $0 + $1.amount })
        let sumIncome = displayTransactions
            .filter { $0.type == .income && $0.amount >= filterMinimum }
            .reduce(0, { $0 + $1.amount })
        let total = sumIncome - sumExpenses
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: total as NSNumber) ?? "NOK 0.00"
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

  // Sorting
    
    private var displayTransactions: [Invoice] {
        let sortedTransactions =  sortPaid ? orderDescending ? transactions.sorted(by: { calendar.startOfDay(for: $0.paidDate) > calendar.startOfDay(for: $1.paidDate)}) : transactions.sorted(by: { calendar.startOfDay(for: $0.paidDate) < calendar.startOfDay(for: $1.paidDate)}) :  orderDescending ? transactions.sorted(by: { calendar.startOfDay(for: $0.dueDate) > calendar.startOfDay(for: $1.dueDate)}) : transactions.sorted(by: { calendar.startOfDay(for: $0.dueDate) < calendar.startOfDay(for: $1.dueDate) })
        guard filterMinimum > 0 else {
            return sortedTransactions
        }
    
 // Filtering
        let myCustomer = selectedCustomer?.title ?? ""
        
        if showFilteredCustomer {
            let filteredTransactions1 = sortedTransactions.filter({ ($0.amount >= filterMinimum) && (showExpenses ? $0.type == .expense : $0.type != .all) && (showUnpaid ? $0.state == .pending : $0.type != .all)  &&  $0.customer?.title == myCustomer })
            
            let filteredTransactions2 = sortedTransactions.filter({ sortPaid ? (calendar.startOfDay(for:$0.paidDate) >= calendar.startOfDay(for: fromDate)) && (calendar.startOfDay(for: $0.paidDate) <= calendar.startOfDay(for: toDate)) : (calendar.startOfDay(for: $0.dueDate) >= calendar.startOfDay(for: fromDate)) && (calendar.startOfDay(for: $0.dueDate) <= calendar.startOfDay(for: toDate))})
            
            let filteredTransactions = filteredTransactions1.filter({ filteredTransactions2.contains($0) })
            
            return filteredTransactions
        } else {
            let filteredTransactions1 = sortedTransactions.filter({ ($0.amount >= filterMinimum) && (showExpenses ? $0.type == .expense : $0.type != .all) && (showUnpaid ? $0.state == .pending : $0.type != .all)})
            
            let filteredTransactions2 = sortedTransactions.filter({ sortPaid ? (calendar.startOfDay(for:$0.paidDate) >= calendar.startOfDay(for: fromDate)) && (calendar.startOfDay(for: $0.paidDate) <= calendar.startOfDay(for: toDate)) : (calendar.startOfDay(for: $0.dueDate) >= calendar.startOfDay(for: fromDate)) && (calendar.startOfDay(for: $0.dueDate) <= calendar.startOfDay(for: toDate))})
            
            let filteredTransactions = filteredTransactions1.filter({ filteredTransactions2.contains($0) })
            
            return filteredTransactions
        }
        
       
        
    }
 }

#Preview {
    ListInvoiceView()
        .modelContainer(for: Invoice.self, inMemory: true)
}
