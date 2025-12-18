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
    @AppStorage("filterMinimum") var filterMinimum = 1.0
    @AppStorage("orderDescending") var orderDescending = false
    @AppStorage("showExpenses") var showExpenses = true
    @AppStorage("fromDate") var fromDate = Date()
    @AppStorage("toDate") var toDate = Date()
    @AppStorage("sortPaid") var sortPaid = false
    @AppStorage("ShowName") private var showName = false
    @AppStorage("YourName") private var name: String = ""
    @State private var showCreateCustomer = false
    @State private var showInvoiceList = false
    @State private var showingSettings = false
    @State private var showFilters = false
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
                ToolbarItem(placement: .topBarLeading) {
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
                FiltersView(filterMinimum: $filterMinimum, orderDescending: $orderDescending, showExpenses: $showExpenses, fromDate: $fromDate, toDate: $toDate, sortPaid: $sortPaid)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(Font.system(size: 25, weight: .black))
                            .background(.clear)
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
}

#Preview {
    FirstView()
}
