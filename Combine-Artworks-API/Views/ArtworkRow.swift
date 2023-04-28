//
//  ArtworkView.swift
//  Combine-Artworks-API
//
//  Created by Brian McIntosh on 4/28/23.
//

import SwiftUI

struct ArtworkRow: View {
    
    let artwork: ArtworkModel
    
    var body: some View {
        NavigationLink {
            ArtworkDetailView(artwork: artwork)
        } label: {
            Text(artwork.title)
        }
    }
}

struct ArtworkRow_Previews: PreviewProvider {
    static var previews: some View {
        ArtworkRow(artwork: previewArtwork)
            .previewLayout(.sizeThatFits)
    }
}
