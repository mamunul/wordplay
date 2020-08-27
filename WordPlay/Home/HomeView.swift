//
//  ContentView.swift
//  WordPlay
//
//  Created by Mamunul Mazid on 8/21/20.
//

import SwiftUI

struct HomeView: View {
    @State var navigateToNextView = false
    var body: some View {
        Button(action: {
            self.navigateToNextView = true
        }) {
            Text("Start").padding()
        }
        .sheet(isPresented: self.$navigateToNextView) {
            HomeViewRouter().routeToGameView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
