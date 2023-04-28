//
//  ContentView.swift
//  Combine-Artworks-API
//
//  Created by Brian McIntosh on 4/28/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = ArtworkViewModel()

    var body: some View {
        
        NavigationStack {
            List(vm.artworks) { artwork in
                ArtworkRow(artwork: artwork)
            }
            .navigationTitle("Artworks")
            .onAppear {
                vm.fetchArtwork()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
