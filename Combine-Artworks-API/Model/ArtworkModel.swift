//
//  ArtworkModel.swift
//  Combine-Artworks-API 
//
//  Created by Brian McIntosh on 4/28/23.
//

struct ArtworkDataResponse: Codable {
    let data: [ArtworkModel]
}

struct ArtworkModel: Codable, Identifiable {
    let id: Int
    let title: String
    let imageId: String? //network returns snake_case
}

let previewArtwork = ArtworkModel(id: 16487, title: "The Bay of Marseille, Seen from blah blah blah", imageId: "d4ca6321-8656-3d3f-a362-2ee297b2b813")
