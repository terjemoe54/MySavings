//
//  MonthlyInvoiceSummaryView.swift
//  MySavings
//
//  Created by Terje Moe on 11/01/2026.
//
import SwiftUI
import SwiftData

struct MonthlyInvoiceSummaryView: View {
    @StateObject private var viewModel = InvoiceViewModel()
    @Query(sort: \Invoice.dueDate, order: .reverse) private var invoices: [Invoice]
   
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                Text("Alle Bilag")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                let totalExpenses = invoices.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
                let totalIncome = invoices.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
                Text("Intekter: " + String(Int(totalIncome)))
                    .foregroundStyle(.green)
                Text("Utgifter: " + String(Int(totalExpenses)))
                    .foregroundStyle(.red)
                Text("Tilgode: " + String(Int(totalIncome) - Int(totalExpenses)))
                    .foregroundStyle(.blue)
            }
            .font(.system(size: 16, weight: .bold))
            .padding()
           
            VStack(spacing: 0) {
                // Yearly Summary Header
               
                
                List(viewModel.monthlyStats) { stats in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(stats.monthName)
                                .font(.headline)
                            Spacer()
                            Text("\(stats.invoiceCount) Bilag")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.black)
                        }
                        
                        HStack(spacing: 16) {
                            statCard(title: "Tilgode", amount: Double(Int(stats.totalAmount)), color: .blue)
                            statCard(title: "Betalt", amount: Double(Int(stats.paidAmount)), color: .green)
                            statCard(title: "Intekt", amount: Double(Int(stats.unpaidAmount)), color: .orange)
                        }
                        
                        HStack {
                            Text("Venter: \(stats.pendingCount)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.orange)
                            Spacer()
                        }
                    }
                    .padding(.vertical, 12)
                }
            }
         //   .navigationTitle("Bilag Sammendrag")
            .onAppear {
                viewModel.loadInvoices(invoices)
            }
        }
    }
    
    
    @ViewBuilder
    private func statCard(title: String, amount: Double, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(color)
            Text(amount, format: .currency(code: "").precision(.fractionLength(0)))
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
     MonthlyInvoiceSummaryView()
}

