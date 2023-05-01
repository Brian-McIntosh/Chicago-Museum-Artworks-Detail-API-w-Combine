# Chicago Museum Artworks & Detail API w/ Combine

| <img src="https://github.com/Brian-McIntosh/Combine-Artworks-API/blob/main/images/1.png" width="250"/>        | <img src="https://github.com/Brian-McIntosh/Combine-Artworks-API/blob/main/images/2.png" width="250"/>           |
| ------------- |:-------------:|

Views > **ContentView**.swift
```swift
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
```
Views > **ArtworkRow**.swift
```swift
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
```

Views > **ArtworkDetailView**.swift
```swift
struct ArtworkDetailView: View {
    
    let artwork: ArtworkModel
    
    var body: some View {
        ScrollView {
            
            artworkImageView
            
            Text(artwork.title)
                .font(.title)
                .padding()
        }
        .navigationTitle("Artwork Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder var artworkImageView: some View {
        if let imageID = artwork.imageId,
           let imageURL = URL(string: "https://www.artic.edu/iiif/2/\(imageID)/full/843,/0/default.jpg") {
            AsyncImage(url: imageURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
        }else{
            Text("Image is not available")
        }
    }
}
```

ViewModels > **ArtworkViewModel**.swift
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
