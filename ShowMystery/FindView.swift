//
//  FindView.swift
//  ShowMystery
//
//  Created by Vahe Toroyan on 11/6/20.
//

import SwiftUI

struct FindView: View {

    let player = PlayerView()
    @State private var isPresented = false

    var body: some View {
            VStack {
                ZStack {
                    self.player
                        .padding(.top, 40)
                }

                Button (action: {
                    self.isPresented = true
                }, label: {
                    Image("find_button")
                }).padding(.bottom, 22)
                  .sheet(isPresented: self.$isPresented,
                         content: { ARViewIndicator() })
            }.background(Color(UIColor(red: 70/255,
                                       green: 2/255,
                                       blue: 54/255,
                                       alpha: 1)))
             .edgesIgnoringSafeArea(.all)
        }
    }

struct FindView_Previews: PreviewProvider {
    static var previews: some View {
        FindView()
    }
}

