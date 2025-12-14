//
//  FirstView.swift
//  MySavings
//
//  Created by Terje Moe on 13/12/2025.
//

import SwiftUI
import SwiftData

struct FirstView: View {
    @AppStorage("darkModeEnambled") private var darkModeEnabled = false
    @AppStorage("ShowName") private var showName = false
    @AppStorage("YourName") private var name: String = ""
    @AppStorage("filterMinimum") var filterMinimum = 1.0
    @AppStorage("orderDescending") var orderDescending = false
    @AppStorage("showExpenses") var showExpenses = true
    @AppStorage("fromDate") var fromDate = Date()
    @AppStorage("toDate") var toDate = Date()
    @AppStorage("sortPaid") var sortPaid = false
    @State private var showCreateCustomer = false
    @State private var showInvoiceList = false
    @State private var showingSettings = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            ZStack {
                Color(Color.gray)
                    .ignoresSafeArea()
                    .opacity(0.3)
                Image("CityView")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.6)
                    .ignoresSafeArea()
                VStack {
                    Text(name)
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Color.blue)
                        
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
                                .font(.system(size: 25, weight: .bold))
                                .background(.blue)
                                .opacity(0.3)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .padding(.horizontal,35)
                        
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
                                .font(.system(size: 25, weight: .bold))
                                .background(.blue)
                                .opacity(0.3)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .padding(.horizontal,35)
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
            SettingsView(name: $name,filterMinimum: $filterMinimum, darkModeEnabled: $darkModeEnabled, showName: $showName, orderDescending: $orderDescending, showExpenses: $showExpenses, fromDate: $fromDate, toDate: $toDate, sortPaid: $sortPaid)
            }
        }
     }
}

#Preview {
    FirstView()
}
