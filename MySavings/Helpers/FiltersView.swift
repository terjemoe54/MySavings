//
//  FiltersView.swift
//  MySavings
//
//  Created by Terje Moe on 15/12/2025.
//

import SwiftUI
import SwiftData

struct FiltersView: View {
    @Environment(\.dismiss) var dismiss
    @Query private var customers: [Customer]
    @Binding var filterMinimum: Double
    @Binding var orderDescending: Bool
    @Binding var showUnpaid: Bool
    @Binding var showExpenses: Bool
    @Binding var fromDate: Date
    @Binding var toDate: Date
    @Binding var sortPaid: Bool
    @AppStorage("darkModeEnambled") private var darkModeEnabled = false
    @State private var selectedCustomer: Customer?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sortering / Filter")
                    .font(.system(size: 20, weight: .semibold))){
                    Toggle(isOn: $orderDescending) {
                        Text(!orderDescending ? "Dato (Elste først)" :"Dato (Nyeste først)")
                    }
                    
                    Toggle(isOn: $showUnpaid) {
                        Text("Vis Bare Ubetalte")
                    }.padding(.vertical)
                    
                    Toggle(isOn: $showExpenses) {
                        Text("Vis Bare Utgifter")
                    }
                }
                
                Section(header: Text("Beløp")
                    .font(.system(size: 20, weight: .semibold))){
                    HStack {
                        Text("Minimumsbeløp:")
                        TextField("Beløp :", value: $filterMinimum, formatter: NumberFormatter())
                    }
                    .onChange(of: filterMinimum) { oldValue, newValue in
                        if newValue < filterMinimum {
                            filterMinimum = filterMinimum
                        }
                    }
                }
                
                Section(header: Text("Intervall")
                    .font(.system(size: 20, weight: .semibold))){
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
           
            .toolbar {
                ToolbarItem(placement: .cancellationAction){
                    Button("Avslutt") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
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
    FiltersView(filterMinimum: .constant(1.0), orderDescending: .constant(false),showUnpaid: .constant(false), showExpenses: .constant(false), fromDate: .constant(Date()), toDate: .constant(Date()), sortPaid: .constant(false))
}


