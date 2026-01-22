//
//  ContentView.swift
//  ToDos
//  dette er for nå
//  Created by Tunde Adegoroye on 06/06/2023.
// bra

import SwiftUI
import SwiftData

struct ListInvoiceView: View {
    @EnvironmentObject var model: AppModel
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("filterMinimum") var filterMinimum = 1.0
    @AppStorage("orderDescending") var orderDescending = false
    @AppStorage("showUnpaid") var showUnpaid = false
    @AppStorage("showDueUnpaid") var showDueUnpaid = false
    @AppStorage("showAllPosts") var showAllPosts = false
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
    @AppStorage("showFilteredCustomer") var showFilteredCustomer = false
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
                    Text("Filter Klient")
                    
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
                }
                .disabled(!showFilteredCustomer)
                .onChange(of: selectedCustomer) { oldValue, newValue in
                    if let title = newValue?.title {
                        model.klientname = title
                    }
                }
            }.frame(width: 200,height: 20,  alignment: .center)
            ZStack {
                List {
                   ForEach(showAllPosts == true && showFilteredCustomer == false ? showAllTransactions : displayTransactions) { invoice in
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Spacer()
                                    Text("Forfall : \(invoice.displayDueDate)")
                                    Spacer()
                                    Text(invoice.state != .pending ? "Betalt : \(invoice.displayPaidDate)" : "Reg: \(invoice.displayPaidDate)")
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                }
            }
            .sheet(isPresented: $showFilters) {
                FiltersView(filterMinimum: $filterMinimum, orderDescending: $orderDescending,showUnpaid: $showUnpaid,showDueUnpaid: $showDueUnpaid, fromDate: $fromDate, toDate: $toDate, sortPaid: $sortPaid,showAllPosts: $showAllPosts)
            }
        }
        .onDisappear{
           showFilteredCustomer = false
        }
        .onAppear() {
          duplicateAllInvoices()
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
    
    private var displayTransactions: [Invoice] {
        let sortedTransactions: [Invoice] = { 
            let sortKey: KeyPath<Invoice, Date> = sortPaid ? \.paidDate : \.dueDate
            return transactions.sorted {
                let lhs = calendar.startOfDay(for: $0[keyPath: sortKey])
                let rhs = calendar.startOfDay(for: $1[keyPath: sortKey])
                return orderDescending ? lhs > rhs : lhs < rhs
            }
        }()
        
        let myCustomer = selectedCustomer?.title ?? ""
        
        func matchesBasicFilters(_ invoice: Invoice) -> Bool {
            guard invoice.amount >= filterMinimum else { return false }
            if showUnpaid && invoice.state != .pending && !showFilteredCustomer { return false }
            if !showUnpaid && invoice.isPaid == false && !showFilteredCustomer { return false }
           
            return true
        }
        
        func matchesDateRange(_ invoice: Invoice) -> Bool {
            let date = sortPaid ? invoice.paidDate : invoice.dueDate
            let start = calendar.startOfDay(for: fromDate)
            let end = calendar.startOfDay(for: toDate)
            let invoiceDay = calendar.startOfDay(for: date)
            return invoiceDay >= start && invoiceDay <= end
        }
        
        func matchesCustomer(_ invoice: Invoice) -> Bool {
            guard showFilteredCustomer else { return true }
            return invoice.customer?.title == myCustomer
        }
        
        func matchesDueUnpaid(_ invoice: Invoice) -> Bool {
            guard showDueUnpaid else { return true }
            let today = calendar.startOfDay(for: Date())
            let invoiceDay = calendar.startOfDay(for: invoice.dueDate)
            return invoiceDay <= today && invoice.isPaid == false
        }
        
        
        let filtered = sortedTransactions.filter { invoice in
              matchesBasicFilters(invoice)
          &&  matchesDateRange(invoice)
          &&  matchesCustomer(invoice)
          &&  matchesDueUnpaid(invoice)
        }
        
        return filtered
        
    }
    
    //********
    
    
    private var showAllTransactions: [Invoice] {
        // This selects all post sorted on duedate and filtered by from - to date
        let sortedTransactions: [Invoice] = {
            let sortKey: KeyPath<Invoice, Date> = sortPaid ? \.paidDate : \.dueDate
            return transactions.sorted {
                let lhs = calendar.startOfDay(for: $0[keyPath: sortKey])
                let rhs = calendar.startOfDay(for: $1[keyPath: sortKey])
                return orderDescending ? lhs > rhs : lhs < rhs
            }
        }()
        
        let myCustomer = selectedCustomer?.title ?? ""
        
        func matchesDateRange(_ invoice: Invoice) -> Bool {
            let date = sortPaid ? invoice.paidDate : invoice.dueDate
            let start = calendar.startOfDay(for: fromDate)
            let end = calendar.startOfDay(for: toDate)
            let invoiceDay = calendar.startOfDay(for: date)
            return invoiceDay >= start && invoiceDay <= end
        }
        
        let filtered = sortedTransactions.filter { invoice in
            matchesDateRange(invoice)
        }
        
        return filtered
    }
    
    
    //********
    
    
    
    
    private var selectTransactions: [Invoice] {
        // Sort by most recent paidDate first
        let sortedTransactions = transactions.sorted { calendar.startOfDay(for: $0.paidDate) > calendar.startOfDay(for: $1.paidDate) }
        // Filter to only those with dueDate after today
        let filtered = sortedTransactions.filter { (calendar.startOfDay(for: $0.dueDate) <= calendar.startOfDay(for: Date()) && ($0.interval > 0 && $0.isPaid == false ))}
   
        return filtered
    }
    
    private func duplicateAllInvoices() {
        let source = selectTransactions
        guard !source.isEmpty else { return }
        
        for original in source {
            if !original.isPaid && original.state != .pending { original.isPaid = true
                try? modelContext.save()
            }
        guard original.progress < 1 else { return }
            let copy = Invoice()
            copy.title = "Copy of \(original.title)"
            copy.type = original.type
            copy.state = .pending //original.state
            copy.amount = original.amount
            let monthsToAdd = original.interval
            let newDue = Calendar.current.date(byAdding: .month, value: monthsToAdd, to: original.dueDate) ?? original.dueDate
            copy.dueDate = newDue
            copy.paidDate = newDue //original.paidDate
            copy.isPaid = false
            copy.interval = original.interval
            copy.customer = original.customer
            original.progress = original.progress + 1
            modelContext.insert(copy)
            copy.customer?.invoices?.append(copy)
            original.isPaid = ((original.state == .paid) || (original.state == .resieved) || (original.state == .taken))  ? true : false
        }
        try? modelContext.save()
    }
}

#Preview {
    ListInvoiceView()
        .modelContainer(for: Invoice.self, inMemory: true)
}

