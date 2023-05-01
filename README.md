# Chicago Museum Artworks & Detail API w/ Combine

<img src="https://github.com/Brian-McIntosh/Combine-Artworks-API/blob/main/images/1.png" width="250"/>
<img src="https://github.com/Brian-McIntosh/Combine-Artworks-API/blob/main/images/2.png" width="250"/>

```swift
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
```
