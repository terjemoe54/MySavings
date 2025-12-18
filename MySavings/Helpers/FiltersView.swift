//
//  FiltersView.swift
//  MySavings
//
//  Created by Terje Moe on 15/12/2025.
//

import SwiftUI
import SwiftData

struct FiltersView: View {
    @Query private var customers: [Customer]
    @Binding var filterMinimum: Double
    @Binding var orderDescending: Bool
    @Binding var showExpenses: Bool
    @Binding var fromDate: Date
    @Binding var toDate: Date
    @Binding var sortPaid: Bool
    @AppStorage("darkModeEnambled") private var darkModeEnabled = false
    @State private var selectedCustomer: Customer?
    
    var body: some View {
        NavigationView {
            Form {
                let myCustomer = selectedCustomer?.title ?? ""
                  Text("Kunde: \(myCustomer)")
                
                Section(header: Text("Sortering / Filter"),
                        footer: Text("")) {
                    
                    Toggle(isOn: $orderDescending) {
                        Text(!orderDescending ? "Dato (Elste først)" :"Dato (Nyeste først)")
                    }
                    VStack {
                       Toggle(isOn: $showExpenses) {
                            Text("Vis Bare Utgifter")
                        }
                        HStack {
                            Text("Minimumsbeløp:")
                            TextField("Beløp :", value: $filterMinimum, formatter: NumberFormatter())
                        }
                        Toggle(isOn: $sortPaid) {
                            Text(!sortPaid ? "Forfalls-Dato" : "Betalt-Dato")
                         }
                        HStack{
                            VStack (alignment: .center) {
                                Text("Fra Dato")
                                    .padding(.leading)
                                  DatePicker("", selection: $fromDate,
                                           displayedComponents: .date)
                                .padding(.trailing)
                            }
                       VStack (alignment: .center) {
                                Text("Til Dato")
                                    .padding(.leading)
                                  DatePicker("", selection: $toDate,
                                           displayedComponents: .date)
                                .padding(.trailing)
                            }
                        }
                    }
                }
            }
            .foregroundStyle(darkModeEnabled ? Color.white : Color.black)
            .font(.system(size: 16, weight: .semibold))
            .navigationTitle("Filter")
        }
        .preferredColorScheme(darkModeEnabled ? .dark : .light)
    }
}

#Preview {
    FiltersView(filterMinimum: .constant(0.0), orderDescending: .constant(false), showExpenses: .constant(false), fromDate: .constant(Date()), toDate: .constant(Date()), sortPaid: .constant(false))
}


