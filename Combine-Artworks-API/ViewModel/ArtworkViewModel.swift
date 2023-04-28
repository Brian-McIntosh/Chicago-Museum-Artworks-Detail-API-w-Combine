//
//  ArtworkViewModel.swift
//  Combine-Artworks-API
//
//  Created by Brian McIntosh on 4/28/23.
//

import Foundation //includes URLSession 
import Combine

class ArtworkViewModel: ObservableObject {
    
    @Published private(set) var artworks: [ArtworkModel] = []
               // the only one setting or assinging this will be inside this class
    
    private var cancellables = Set<AnyCancellable>()
    private let jsonDecoder = JSONDecoder()
    
    func fetchArtwork() {
        
        // URLs are optional!
        guard let url = URL(string: "https://api.artic.edu/api/v1/artworks") else { return }
        
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase // easier than CodingKeys
        
        // everyone loves to crap on Singletons but they're used all over...
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ArtworkDataResponse.self, decoder: jsonDecoder)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    print("It finished!")
                }
            } receiveValue: { [weak self] response in
                self?.artworks = response.data
            }
            .store(in: &cancellables)
    }
}
