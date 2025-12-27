//
//  Funcsions.swift
//  MySavings
//
//  Created by Terje Moe on 16/12/2025.
//

import SwiftUI
import SwiftData

struct BalanceView: View {
    @EnvironmentObject var model: AppModel
    @Query var transactions: [Invoice]
    private let calendar = Calendar.current
    @AppStorage("filterMinimum") var filterMinimum = 1.0
    @AppStorage("showUnpaid") var showUnpaid = true
    @AppStorage("showExpenses") var showExpenses = true
    @AppStorage("orderDescending") var orderDescending = false
    @AppStorage("sortPaid") var sortPaid = false
    @AppStorage("showFilteredCustomer") var showFilteredCustomer = false
    @AppStorage("fromDate") var fromDate = Date()
    @AppStorage("toDate") var toDate = Date()
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.green)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("På Konto")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color.black)
                        Text("\(total)")
                            .font(.system(size: 42, weight: .light))
                            .foregroundStyle(Color.black)
                    }
                }
                .padding(.top)
                
                HStack(spacing: 25) {
                    VStack(alignment: .leading) {
                        Text("Utgifter")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.black)
                        Text("\(expenses)")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.black)
                    }
                    VStack(alignment: .leading) {
                        Text("Intekter")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.black)
                        Text("\(income)")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.black)
                    }
                    VStack(alignment: .leading) {
                        Text("Poster")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.black)
                        Text("\(displayTransactions.count)")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.black)
                    }
                }
                Spacer()
            }
        }
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        .frame(height: 150)
        .padding(.horizontal,7)
    }
    
    private var displayTransactions: [Invoice] {
        let sortedTransactions =  sortPaid ? orderDescending ? transactions.sorted(by: { calendar.startOfDay(for: $0.paidDate) > calendar.startOfDay(for: $1.paidDate)}) : transactions.sorted(by: { calendar.startOfDay(for: $0.paidDate) < calendar.startOfDay(for: $1.paidDate)}) :  orderDescending ? transactions.sorted(by: { calendar.startOfDay(for: $0.dueDate) > calendar.startOfDay(for: $1.dueDate)}) : transactions.sorted(by: { calendar.startOfDay(for: $0.dueDate) < calendar.startOfDay(for: $1.dueDate) })
        
        let myCustomer = model.klientname
        
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
    
    private var expenses: String {
        let sumExpenses = displayTransactions
            .filter { $0.type == .expense && $0.amount >= filterMinimum }
            .reduce(0, { $0 + $1.amount })
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
       
        return numberFormatter.string(from: sumExpenses as NSNumber) ?? "NOK 0.00"
    }
    
    private var income: String {
        let sumIncome = displayTransactions
            .filter { $0.type == .income && $0.amount >= filterMinimum }
            .reduce(0, { $0 + $1.amount })
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
       
        return numberFormatter.string(from: sumIncome as NSNumber) ?? "NOK 0.00"
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
}

#Preview {
    BalanceView()
}
