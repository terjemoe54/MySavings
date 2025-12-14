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
    var body: some Scene {
        WindowGroup {
            FirstView()
            .modelContainer(for: Invoice.self)
     }
  }
 
  init() {
      print(URL.applicationSupportDirectory.path(percentEncoded: false))
  }
}
