//
//  ContentView.swift
//  Hack0922
//
//  Created by Tema Sysoev on 24.09.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var currentPage = 0
    var body: some View {
        
        TabView(selection: $currentPage) {
            OraculView()
                .tabItem {
                Image(systemName: "eye.fill")
                Text("Oracul")
            }
                .tag(1)
            Launchpad()
                .tabItem {
                Image(systemName: "pyramid.fill")
                Text("Launchpad")
            }
                .tag(2)
        }
    }
}

struct Content_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
