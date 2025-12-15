//
//  FirstView.swift
//  MySavings
//
//  Created by Terje Moe on 13/12/2025.
// 14.12.25

import SwiftUI
import SwiftData

struct FirstView: View {
    @AppStorage("darkModeEnambled") private var darkModeEnabled = false
    @AppStorage("ShowName") private var showName = false
    @AppStorage("YourName") private var name: String = ""
    @AppStorage("filterMinimum") var filterMinimum = 1.0
    @AppStorage("showExpenses") var showExpenses = true
    @State private var showCreateCustomer = false
    @State private var showInvoiceList = false
    @State private var showingSettings = false
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.modelContext) private var context
    @Query var transactions: [Invoice]
    let calendar = Calendar.current
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color(Color.cyan)
                    .ignoresSafeArea()
                    .opacity(0.1)
               
                Image("CityView")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.6)
                    .ignoresSafeArea()
                
                VStack {
                    
                    Text(showName ? name : "")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Color.blue)
                BalanceView()
                    Spacer()
                    
                 HStack {
                        Spacer()
                        VStack {
                            Button {
                                showCreateCustomer.toggle()
                            } label: {
                                Image(systemName: "person.2.fill")
                                    .font(.system(size: 50, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(.borderedProminent)
                            Text("Kunder")
                                .font(.system(size: 25, weight: .black))
                                .opacity(0.3)
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal)
                     VStack {
                            Button {
                                showInvoiceList.toggle()
                            } label: {
                                Image(systemName: "norwegiankronesign.arrow.trianglehead.counterclockwise.rotate.90")
                                    .font(.system(size: 50, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(.borderedProminent)
                            Text("Fakturaer")
                                .font(.system(size: 25, weight: .black))
                                .opacity(0.3)
                                .foregroundColor(.black)
                        }
                       .padding(.horizontal)
                        Spacer()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                    showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .background(.white)
                            .foregroundStyle(Color.black)
                   }
                }
            }
            .sheet(isPresented: $showCreateCustomer,
                   content: {
                NavigationStack {
                    CreateCustomerView()
                }
            })
            .sheet(isPresented: $showInvoiceList,
                   content: {
                NavigationStack {
                    ListInvoiceView()
                }
            })
            
            .sheet(isPresented: $showingSettings) {
            SettingsView(name: $name, darkModeEnabled: $darkModeEnabled, showName: $showName)
            }
        }
        .preferredColorScheme(darkModeEnabled ? .dark : .light)
     }
   // Her begynner funcsjoner
    
    private var expenses: String {
        let sumExpenses =  transactions.filter({ $0.type == .expense &&  $0.amount > filterMinimum }).reduce(0, { $0 + $1.amount})
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        
        return numberFormatter.string(from: sumExpenses as NSNumber) ?? "NOK 0.00"
        
    }
    
    private var income: String {
        let sumIncome =  transactions.filter({ $0.type == .income &&  $0.amount > filterMinimum }).reduce(0, { $0 + $1.amount})
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        guard !showExpenses else {
            return "0.00"
        }
        return numberFormatter.string(from: sumIncome as NSNumber) ?? "NOK 0.00"
        
    }
    
    private var total: String {
        let sumExpenses =  transactions.filter({ $0.type == .expense &&  $0.amount > filterMinimum }).reduce(0, { $0 + $1.amount})
        let sumIncome =  transactions.filter({ $0.type == .income &&  $0.amount > filterMinimum }).reduce(0, { $0 + $1.amount})
        let total = sumIncome - sumExpenses
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: total as NSNumber) ?? "NOK 0.00"
    }
    
    fileprivate func BalanceView() -> some View {
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
                        Text("\(transactions.count)")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.black)
                    }
                }
                Spacer()
            }
        }
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        .frame(height: 150)
        .padding(.horizontal)
    
    }
    
}

#Preview {
    FirstView()
}
