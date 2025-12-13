//
//  FirstView.swift
//  MySavings
//
//  Created by Terje Moe on 13/12/2025.
//

import SwiftUI

struct FirstView: View {
    var body: some View {
      
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
             Spacer()
             HStack {
                 Spacer()
                 VStack {
                     Button {
                         // TODO: Kode for kundereg
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
                         // TODO: Kode for kundereg
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
    }
}

#Preview {
    FirstView()
}
