//
//  MySavingsApp.swift
//  MySavings
//
//  Created by Terje Moe on 08/12/2025.
//

import SwiftUI
import SwiftData

@main
struct MySavingsApp: App {
    @StateObject var model = AppModel()
    var body: some Scene {
        WindowGroup {
            FirstView()
            .environmentObject(model)
            .modelContainer(for: Invoice.self)
     }
  }
 
  init() {
      print(URL.applicationSupportDirectory.path(percentEncoded: false))
  }
}
