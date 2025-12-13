//
//  SettingsView.swift
//  Income
//
//  Created by Terje Moe on 09/11/2025.
//

import SwiftUI

struct SettingsView: View {
    @Binding var name: String
    @Binding var tax: String
    @Binding var filterMinimum: Double
    @Binding var darkModeEnabled: Bool
    @Binding var showName: Bool
    @Binding var orderDescending: Bool
    @Binding var showExpenses: Bool
    @Binding var fromDate: Date
    @Binding var toDate: Date
    @Binding var sortPaid: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Display"),
                        footer: Text("")) {
                    
                    Toggle(isOn: $darkModeEnabled) {
                        
                        Text(!darkModeEnabled ? "Dag modus" : "Natt modus")
                        
                    }
                    
                    Toggle(isOn: $showName) {
                        Text(!showName ? "Skjult bruker navn" : "Vist bruker navn")
                    }
                    HStack {
                        Text("Ditt Navn:          ")
                        TextField("Navn:", text: $name)
                    }
                }
                
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
                
                Section {
                    Link(destination: URL(string: Constants.web)!,
                         label: {
                        Label("Les VG", systemImage: "globe")
                    })
                    HStack {
                        Image(systemName: "envelope")
                        Link("Kontakt meg via mail",
                             destination: URL(string: Constants.email)!)
                    }
                    HStack {
                        Image(systemName: "phone")
                        Link("Ring meg",
                             destination: URL(string: Constants.phone)!)
                    }
                }
            }
            .foregroundStyle(darkModeEnabled ? Color.white : Color.black)
            .font(.system(size: 16, weight: .semibold))
            .navigationTitle("Instillinger")
        }
        .preferredColorScheme(darkModeEnabled ? .dark : .light)
    }
}

#Preview {
    SettingsView(name: .constant("Tomle Hue"), tax: .constant("18"), filterMinimum: .constant(0.0), darkModeEnabled: .constant(false), showName: .constant(false), orderDescending: .constant(false), showExpenses: .constant(false), fromDate: .constant(Date()), toDate: .constant(Date()), sortPaid: .constant(false))
}
